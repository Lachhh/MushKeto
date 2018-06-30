package com.lachhh.lachhhengine.datastruct {

	/**
	 * @author Lachhh
	 */
	public class GraphNode {
		static public const READY:int = 0 ;
		static public const WAITING:int = 1 ; 
		static public const ANALYZED:int = 2 ;  
		public var state:int ;
		public var x:Number ;
		public var y:Number ;
		public function GraphNode(pX:Number, pY:Number) {
			x = pX;
			y = pY;
		}
		
		public function destroy():void {
			
		}
	
	}
}
