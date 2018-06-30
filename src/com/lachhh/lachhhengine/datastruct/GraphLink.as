package com.lachhh.lachhhengine.datastruct {

	/**
	 * @author Lachhh
	 */
	public class GraphLink {
		public var node1 : GraphNode;
		public var node2 : GraphNode;

		public function GraphLink(pNode1 : GraphNode, pNode2 : GraphNode) {
			node1 = pNode1;
			node2 = pNode2;
		}
		
		public function destroy():void {
			node1 = null;
			node2 = null;
		}
		
		public function containsNode(n : GraphNode) : Boolean {
			return (node1 == n || node2 == n);
		}
	}
}
