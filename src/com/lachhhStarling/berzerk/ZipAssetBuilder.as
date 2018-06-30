package com.lachhhStarling.berzerk {
	import deng.fzip.FZip;

	import com.berzerkrpg.multilingual.ModelLanguage;
	import com.berzerkrpg.multilingual.ModelLanguageEnum;
	import com.berzerkstudio.ModelFla;
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhhStarling.ModelFlaEnum;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * @author Shayne
	 */
	public class ZipAssetBuilder {
		
		private var _fzip:FZip;
		
		private var fileQueue:Vector.<String> = new Vector.<String>();
		private var currentFile:int = 0;
		
		private var onFinishedCallback:Callback;
		
		function ZipAssetBuilder(){
			_fzip = new FZip();
		}
		
		public function buildZipArchive(c:Callback):void{
			onFinishedCallback = c;
			
			for each(var fla:ModelFla in ModelFlaEnum.ALL){
				queueFlaAssets(fla);
			}
			
			fileHelper = File.applicationDirectory.resolvePath(VersionInfo.relativeFolderForStarling + "starling/languages");
			
			for each(var file:File in fileHelper.getDirectoryListing()){
				queueLangFile(file.name);
			}
			
			buildNextZipAsset();
		}
		
		private function queueLangFile(file:String):void{
			fileQueue.push("languages/" + file);
			trace("[ZIP BUILDER] queueing: "+ file);
		}
		
		function queueFlaAssets(fla:ModelFla):void{
			var docname:String = fla.id;
			fileQueue.push("texturePackerAssets/" + docname + fla.modelImageFormat.extension);
			fileQueue.push("texturePackerAssets/" + docname + ".xml");
			fileQueue.push("modelFla/" + docname + ".asset");
			queueAnySingularTextures(fla);
			trace("[ZIP BUILDER] queueing: " + docname);
		}
		
		private function queueAnySingularTextures(fla:ModelFla):void{
			fileHelper = File.applicationDirectory.resolvePath(VersionInfo.relativeFolderForStarling + "starling/texturesSingular/" + fla.id);
			if(!fileHelper.exists) return;
			for each(var file:File in fileHelper.getDirectoryListing()){
				fileQueue.push("texturesSingular/" + fla.id + "/" + file.name);
			}
		}
		
		private var fileHelper:File;
		
		function buildNextZipAsset():void{
			if(currentFile >= fileQueue.length){
				finalizeZipAssets();
				return;
			}
			
			fileHelper = File.applicationDirectory.resolvePath(VersionInfo.relativeFolderForStarling + "starling/" + fileQueue[currentFile]);
			
			if(fileHelper.exists){
				fileHelper.addEventListener(Event.COMPLETE, onFileLoaded);
				fileHelper.addEventListener(IOErrorEvent.IO_ERROR, onFileLoadFailure);
				fileHelper.load();
			}
			else{
				throw new Error("[ZIP ASSET BUILDER ERROR] File not found: " + fileQueue[currentFile] + "!");
			}	
		}
		
		function onFileLoaded(e:Event):void{
			fileHelper.removeEventListener(Event.COMPLETE, onFileLoaded);
			_fzip.addFile(fileQueue[currentFile], fileHelper.data);
			
			trace("[ZIP BUILDER] file zipped: " + fileQueue[currentFile]);
			
			currentFile++;
			buildNextZipAsset();
		}
		
		function finalizeZipAssets():void{
			trace("[ZIP BUILDER] finalizing...");
			
			var filePath:String = "app:/" + "starling.zip";
			var appDirFile:File = new File(filePath);
			var finalAssets:File = new File(appDirFile.nativePath);
			
			var stream:FileStream = new FileStream();
			stream.open(finalAssets, FileMode.WRITE);
			_fzip.serialize(stream);
			stream.close();
			
			trace("[ZIP BUILDER] done!");
			onFinishedCallback.call();
		}
		
		function onFileLoadFailure(e:Event):void{
			throw new Error("Failed loading data for: " + fileHelper.name);
		}
		
	}
}
