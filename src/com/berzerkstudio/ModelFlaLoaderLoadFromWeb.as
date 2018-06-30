package com.berzerkstudio {
	import flash.net.URLLoaderDataFormat;
	import com.lachhh.io.Callback;
	import com.lachhhStarling.ModelFlaEnum;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * @author LachhhSSD
	 */
	public class ModelFlaLoaderLoadFromWeb {
		
		static private var callbackOnEnd:Callback ;
		
		static private var crntModel : ModelFla;
		private static var urlLoader : URLLoader;
		
		static public function loadAllFlas(pCallbackOnEnd : Callback) : void {
			ModelFla.registerClassForSerialization();
			callbackOnEnd = pCallbackOnEnd;
			loadNextFla();
		}
		
		static private function loadNextFla():void {
			crntModel = ModelFlaEnum.getFirstNotInit();
			if(crntModel.isNull) {
				callbackOnEnd.call();
				return ;
			}

			var urlReq:URLRequest =  new URLRequest("../../ZombIdle/bin/starling/modelFla/" + crntModel.id + ".asset");
			urlLoader = new URLLoader(urlReq);
			
			urlLoader.addEventListener(Event.COMPLETE, onByteDataLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onByteDataFailure);
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.load(urlReq);
			
		}
		
		static private function onByteDataLoaded(event:Event):void{
			//trace("loaded " + frFile.nativePath);
			urlLoader.removeEventListener(Event.COMPLETE, onByteDataLoaded);
			crntModel.loadFromByteArray(urlLoader.data);
			loadNextFla();
		}
		
		static private function onByteDataFailure(event:Event):void{
			throw new Error("Failed loading byte data for: " + crntModel.id + ".asset");
		}
	}
}
