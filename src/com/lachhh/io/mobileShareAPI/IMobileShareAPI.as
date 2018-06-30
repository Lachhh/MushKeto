package com.lachhh.io.mobileShareAPI {
	import com.lachhh.io.Callback;
	import flash.display.BitmapData;
	/**
	 * @author Shayne
	 */
	public interface IMobileShareAPI {
		
		function canShare():Boolean;
		function shareMessageWithImage(subject:String, message:String, image:BitmapData, pOnShareCompleted:Callback = null):void;
		
	}
}
