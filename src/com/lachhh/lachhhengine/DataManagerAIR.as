package com.lachhh.lachhhengine {
	import com.berzerkrpg.constants.GameConstants;
	import com.lachhh.io.Callback;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.Dictionary;
	/**
	 * @author LachhhSSD
	 */
	public class DataManagerAIR {
		static private var _loadFileCallback:Callback;
		static public var loadFileRef:FileReference;
		static public var loadFile:File;
		
		static public function saveToFile(d:Dictionary):void {
			var obj:Object = DataManager.dictToObject(d); 
			var result:String = (JSON.stringify(obj));
			var fr:FileReference = new FileReference();
			fr.save(result, "JSB_Level.txt");
		}
		
		static public function loadXMLFile(url:String, onFinish:Callback):void {
			_loadFileCallback = onFinish;
			
			//var path:String = File.applicationDirectory.resolvePath(url).nativePath; 
			//loadFile = new File(path);
			
			loadFile = File.applicationDirectory.resolvePath(url);
			
			loadFile.addEventListener(Event.COMPLETE, onLoadXMLComplete);
			loadFile.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loadFile.load();
		}
		
		static private function onError(event : IOErrorEvent) : void {
			trace("error loading Balancing XML");
		}
		
		static  private function onLoadXMLComplete(event : Event) : void {
			loadFile.removeEventListener(Event.COMPLETE, onLoadXMLComplete);
			if(_loadFileCallback) _loadFileCallback.call();
		}
		
		
		static public function selectJsFileToLoad(onFinish:Callback):void {
			_loadFileCallback = onFinish;
			loadFileRef = new FileReference();
			loadFileRef.addEventListener(Event.SELECT, onSelectFile);
			var fileFilter:FileFilter = new FileFilter("Xml", "*.xml");
			loadFileRef.browse([fileFilter]);
		}

		private static function onSelectFile(event : Event) : void {
			loadFileRef.removeEventListener(Event.SELECT, onSelectFile);
			loadFileRef.addEventListener(Event.COMPLETE, onLoadJSComplete);
		    loadFileRef.load();
		}

		private static function onLoadJSComplete(event : Event) : void {
			loadFileRef.removeEventListener(Event.COMPLETE, onLoadJSComplete);
		    if(_loadFileCallback) _loadFileCallback.call();		    
		}

		static public function cloneDict(original:Dictionary):Dictionary {
		    var cloned:Dictionary = new Dictionary();
		    for(var key:Object in original) {
		      if( original[key]  is Dictionary)
		         cloned[key] = cloneDict(original[key]);
		      else
		         cloned[key] = original[key];
		    }
		    return cloned;
		}
		

		
		static public function loadDefaultBalancing():void {
			var b:BalancingXML = createBalancingXMLFromFile("./balancing/ZI_Balancing.xml");
			b.callbackOnLoaded = new Callback(GameConstants.getInstance().initFromBalancingXML, GameConstants.getInstance(), [b]);
		}
		
		static public function loadExternalBalancing():void {
			var b:BalancingXML = createBalancingXMLFromSelectedFile();
			b.callbackOnLoaded = new Callback(GameConstants.getInstance().initFromBalancingXML, GameConstants.getInstance(), [b]);
		}
		
		static public function createBalancingXMLFromSelectedFile():BalancingXML {
			var result:BalancingXML = new BalancingXML();
			DataManagerAIR.selectJsFileToLoad(new Callback(createBalancingXMLFromSelectedFile_loaded, BalancingXML, [result]));
			return result;
		}
		
		static private function createBalancingXMLFromSelectedFile_loaded(balancing:BalancingXML):void {
			balancing.initFromFileLoaded(DataManagerAIR.loadFileRef.data.toString());
			balancing.fileName = DataManagerAIR.loadFileRef.name;
		}
		
		static public function createBalancingXMLFromFile(path:String):BalancingXML {
			var result:BalancingXML = new BalancingXML();
			DataManagerAIR.loadXMLFile(path, new Callback(createBalancingXMLFromFile_loaded, BalancingXML, [result]));
			return result;
		}
		
		static private function createBalancingXMLFromFile_loaded(balancing:BalancingXML):void {
			balancing.initFromFileLoaded(DataManagerAIR.loadFile.data.toString());
			balancing.fileName = DataManagerAIR.loadFile.name;
		}
	}
}
