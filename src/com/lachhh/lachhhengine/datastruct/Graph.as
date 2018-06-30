package com.lachhh.lachhhengine.datastruct {
	import com.lachhh.utils.Utils;

	/**
	 * @author Lachhh
	 */
	public class Graph {
		private var _nodes: Vector.<GraphNode> ;
		private var _links: Vector.<GraphLink> ;
		
		public function Graph() {
			_nodes = new Vector.<GraphNode>();
			_links = new Vector.<GraphLink>();
		}
		
		public function Destroy():void {
			while(_nodes.length > 0) {
				var node:GraphNode = _nodes.pop(); 
				node.destroy();
			}
			
			while(_links.length > 0) {
				var link:GraphLink = _links.pop();
				link.destroy();
			}
		}
		
		public function addNode(node : GraphNode) : void {
			_nodes.push(node);
		}
		
		public function addLink(link : GraphLink) : void {
			_links.push(link);
		}
		
		public function removeNode(node : GraphNode) : void {
			var index:int = _nodes.indexOf(node);
			if(index != -1)_nodes.splice(index, 1);
		}
		
		public function removeLink(link : GraphLink) : void {
			var index:int = _links.indexOf(link);
			if(index != -1) _links.splice(index, 1);
		}
		
		public function contagionResearch(start:GraphNode, end : GraphNode, bidirectionnal:Boolean) : Vector.<GraphNode>  {
			if(!contains(start) ) {
				throw new Error("Start Node is not in graph");
			} else if(!contains(end)) {
				throw new Error("End Node is not in graph");
			}
			
			var queue:Vector.<GraphNode> = new Vector.<GraphNode>();
			var queueIndex:int = 0 ; 
			var orig:Array = new Array();
			var origIndex:int = 1 ; 
			var finished : Boolean = false;
			var path:Vector.<GraphNode> = new Vector.<GraphNode>();
			initAllNodes();
			queue.push(start);
			start.state = GraphNode.WAITING;
			while(queueIndex < queue.length && !finished) {
				var n : GraphNode = queue[queueIndex];
				if(n == end) {
					finished = true;
					continue;
				}
				
				n.state = GraphNode.ANALYZED;
				var adj:Array = getAdjacents(n, bidirectionnal);
				for (var j:int = 0 ;j < adj.length ; j++) {
					var nAdj : GraphNode = adj[j];
					if(nAdj.state == GraphNode.READY) {
						queue.push(nAdj);
						orig[origIndex] = n;
						origIndex++;
						nAdj.state = GraphNode.WAITING;
					} 	
				}
				queueIndex++;
			}
			
			path.push(n);
			while(orig[queueIndex] != null) {
				path.push(orig[queueIndex]);
				queueIndex = queue.indexOf(orig[queueIndex]);
			}
			
			return path.reverse();
		}

		public function getAdjacents(node : GraphNode, bidirectionnal:Boolean = true) : Array {
			var result:Array = new Array();
			for (var i:int = 0 ; i < _links.length ; i++) {
				var link : GraphLink = _links[i];
				if(link.node1 == node) result.push(link.node2);
				if(bidirectionnal && link.node2 == node) result.push(link.node1);
			}
			return result;
		}
		
		public function contains(node : GraphNode) : Boolean {
			return (_nodes.indexOf(node) != -1);
		}

		private function initAllNodes():void {
			for (var i:int = 0 ; i < _nodes.length ; i++) {
				GraphNode(_nodes[i]).state = GraphNode.READY;
			}
		}
		
		public function getLink(node1:GraphNode, node2:GraphNode, bidirectionnal:Boolean):GraphLink {
			for (var i:int = 0 ; i < _links.length ; i++) {
				var link : GraphLink = _links[i];
				if(link.node1 == node1 && link.node2 == node2) return link;
				if(bidirectionnal && link.node2 == node1 && link.node1 == node2) return link;
			}
			return null;
		}
				
		public function getNodeAt(i: int) : GraphNode {
			return _nodes[i];
		}
		
		public function getLinkAt(i: int) : GraphLink {
			return _links[i];
		}
		
		public function get numNodes() : int {
			return _nodes.length;
		}
		
		public function get numLinks() : int {
			return _links.length;
		}
		 
		protected function get nodes() : Vector.<GraphNode> {
			return _nodes;
		}
		
		protected function get links() : Vector.<GraphLink> {
			return _links;
		}
	}
}
