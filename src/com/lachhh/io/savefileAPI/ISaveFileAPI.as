package com.lachhh.io.savefileAPI {
	import com.lachhh.io.Callback;
	import com.lachhh.io.IExternalAPI;

	/**
	 * @author Lachhh
	 */
	public interface ISaveFileAPI extends IExternalAPI{
		function SaveData(s:String, onDone:Callback):void;
		function ClearData():void;
		function get savedData():String;
		function get isEmpty():Boolean;
		function get dataLoaded():Boolean;			
		function set onDataLoadedCallback(c:Callback):void ;
		
	}
}
