package com.lachhhStarling.berzerk {
	import com.lachhh.io.Callback;
	import deng.fzip.FZipFile;

	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	/**
	 * @author LachhhSSD
	 */
	public class BerzerkZipTextureLoaderRequest {
		private var bitmapLoader : Loader;
		public var metaFla : MetaFla;
		public var helperBitmapData : BitmapData;
		public var onLoaded : Callback;
		public var textureName:String;

		public function BerzerkZipTextureLoaderRequest(pCurrentMetaFla : MetaFla) {
			metaFla = pCurrentMetaFla;
			bitmapLoader = new Loader();
		}
		
		public function load(helperZipFile:FZipFile):void {
			bitmapLoader.loadBytes(helperZipFile.content);
			bitmapLoader.contentLoaderInfo.addEventListener(Event.INIT, onBitmapBytesLoaded);
		}

		private function onBitmapBytesLoaded(event : Event) : void {
			helperBitmapData = new BitmapData(bitmapLoader.width,bitmapLoader.height, true, 0x00000000);
			helperBitmapData.draw(bitmapLoader, null, null, "normal", null, false);
			if(onLoaded) onLoaded.call();
		}
	}
}
