package com.lachhhStarling.berzerk {
	import deng.fzip.FZipFile;

	import com.berzerkrpg.multilingual.ModelLanguage;
	import com.berzerkrpg.multilingual.ModelLanguageEnum;
	import com.lachhh.io.Callback;
	/**
	 * @author Eel
	 */
	public class BerzerkZipLanguageLoader {
		
		private var zipManager:ZipAssetManager;
		
		private var onFinished:Callback;
		
		public function BerzerkZipLanguageLoader(pZipManager:ZipAssetManager){
			zipManager = pZipManager;
		}
		
		public function loadAllLanguages(finished:Callback):void{
			ModelLanguage.registerClassForSerialization();
			onFinished = finished;
			
			var fileCount:int = zipManager.fZip.getFileCount();
			var file:FZipFile;
			
			for(var i:int = 0; i < fileCount; i++){
				file = zipManager.fZip.getFileAt(i);
				
				if(isLanguageAsset(file) == false) continue;
				
				var langID:String = file.filename.replace(".asset", "");
				langID = langID.replace("languages/", "");
				
				var model:ModelLanguage = ModelLanguageEnum.getFromId(langID);
				
				if(model.isNull) continue;
				
				model.loadFromByteArray(file.content);
				
				//if(model.isNull){
				//	model = new ModelLanguage(langID, "temp");
				//	model.loadFromByteArray(file.content);
				//} else {
				//	model.loadFromByteArray(file.content);
				//}
			}
			
			trace("[ZIP LANGUAGE LOADER FINISHED!]");
			if(onFinished) onFinished.call();
		}
		
		private function isLanguageAsset(file:FZipFile):Boolean{
			return file.filename.indexOf("languages") == 0;
		}
		
	}
}