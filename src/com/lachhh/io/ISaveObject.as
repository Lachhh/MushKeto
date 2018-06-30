package com.lachhh.io {

	/**
	 * @author Administrator
	 */
	public interface ISaveObject {
		function Encode():String ;
		function Decode(s:String):void
		function get isDirty():Boolean ;
		function set isDirty(value:Boolean):void ; 
	}
}
