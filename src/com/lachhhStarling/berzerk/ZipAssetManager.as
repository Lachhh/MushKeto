package com.lachhhStarling.berzerk {
	import flash.utils.ByteArray;
	import starling.utils.AssetManager;
	import com.lachhh.io.Callback;
	import flash.events.Event;
	import flash.net.URLRequest;
	import deng.fzip.FZip;
	/**
	 * @author Shayne
	 */
	public class ZipAssetManager {
		private var _fzip:FZip;
		private var _isLoading:Boolean = true;
		
		private var onCompleteCallback:Callback;
		
		private var _textureLoader : BerzerkZipTextureLoader;
		private var _modelFlaLoader : BerzerkZipModelFlaLoader;
		private var _languageAssetLoader:BerzerkZipLanguageLoader;
		
		public function ZipAssetManager(pAssetManager:AssetManager){
			_fzip = new FZip();
			
			_textureLoader = new BerzerkZipTextureLoader(this, pAssetManager);
			_modelFlaLoader = new BerzerkZipModelFlaLoader(this);
			_languageAssetLoader = new BerzerkZipLanguageLoader(this);
		}
		
		public function loadZipFile(call:Callback):void{
			onCompleteCallback = call;
			_fzip.addEventListener(Event.COMPLETE, onZipComplete);
			_fzip.load(new URLRequest("starling.zip"));
		}
		
		public function loadZipWithBytes(bytes:ByteArray):void {
			_fzip.loadBytes(bytes);
			onZipComplete(null);
		}
		
		private function onZipComplete(e:Event):void {
			_isLoading = false;
			trace("[ZIP ASSET LOADER IS FINISHED: " + _fzip.getFileCount() + " FILES ]");
			if(onCompleteCallback) onCompleteCallback.call();
		}
		
		public function get textureLoader():BerzerkZipTextureLoader{
			return _textureLoader;
		}

		public function get modelFlaLoader() : BerzerkZipModelFlaLoader {
			return _modelFlaLoader;
		}
		
		public function get languageLoader() : BerzerkZipLanguageLoader { 
			return _languageAssetLoader;
		}
		
		public function get isLoading():Boolean{;
			return _isLoading;
		}
		
		public function get fZip():FZip{
			return _fzip;
		}
	}
}
