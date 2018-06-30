package com.lachhh.io {
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Lachhh
	 */
	public interface IExternalAPI  {
		function Connect(root:DisplayObjectContainer, success:Callback = null, error:Callback = null):void ;
		function get connected():Boolean ;
		function get loggedIn():Boolean ;
		function get nameOfSystem():String ;
	}
}
