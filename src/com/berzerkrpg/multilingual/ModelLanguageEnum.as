package com.berzerkrpg.multilingual {
	/**
	 * @author LachhhSSD
	 */
	public class ModelLanguageEnum {
		
		[Embed(source="../../../../lib/csv/lang_de.csv", mimeType="application/octet-stream")]
		static private const embedLachhhDE:Class;
				
		[Embed(source="../../../../lib/csv/lang_fr.csv", mimeType="application/octet-stream")]
		static private const embedLachhhFR:Class;
		
		[Embed(source="../../../../lib/csv/lang_cn.csv", mimeType="application/octet-stream")]
		static private const embedLachhhCn:Class;
		
		[Embed(source="../../../../lib/csv/lang_es.csv", mimeType="application/octet-stream")]
		static private const embedLachhhEs:Class;
		
		[Embed(source="../../../../lib/csv/lang_it.csv", mimeType="application/octet-stream")]
		static private const embedLachhhIt:Class;
		
		[Embed(source="../../../../lib/csv/lang_ja.csv", mimeType="application/octet-stream")]
		static private const embedLachhhJa:Class;
		
		[Embed(source="../../../../lib/csv/lang_norway.csv", mimeType="application/octet-stream")]
		static private const embedLachhhNorvegian:Class;
		
		[Embed(source="../../../../lib/csv/lang_danish.csv", mimeType="application/octet-stream")]
		static private const embedLachhhDanish:Class;
		
		[Embed(source="../../../../lib/csv/lang_polish.csv", mimeType="application/octet-stream")]
		static private const embedLachhhPolish:Class;
		
		[Embed(source="../../../../lib/csv/lang_ru.csv", mimeType="application/octet-stream")]
		static private const embedLachhhRussian:Class;
		
		[Embed(source="../../../../lib/csv/lang_du.csv", mimeType="application/octet-stream")]
		static private const embedLachhhDU:Class;
		
		static public var ALL:Array = new Array();
				
		static public var NULL:ModelLanguage = new ModelLanguage(-1, "", "", "");

		static public var ENGLISH:ModelLanguage = create("en", "en", "english");

		static public var FRENCH:ModelLanguage = createWithEmbededCSV("fr", "fr", "français", embedLachhhFR, "Michel Ducarme\nXorilog", false);
		static public var DEUTCH:ModelLanguage = createWithEmbededCSV("de", "de", "Deutsch", embedLachhhDE, "@THEpaduser\nSeberoth\nPixelzonelp\nDasGraMMa\nSchkai", false);
		static public var DUTCH:ModelLanguage = createWithEmbededCSV("du", "nl", "Dutch", embedLachhhDU, "Wauteurz\nSimonVerhoeven", false);
		static public var SPANISH:ModelLanguage = createWithEmbededCSV("es", "es-ES", "Spanish", embedLachhhEs, "Kaychienocilla\n@THEpaduser", false);
		static public var ITALIAN:ModelLanguage = createWithEmbededCSV("it", "it", "Italian", embedLachhhIt, "@lowseling\nHell_Flames", false);
		static public var NORVEGIAN:ModelLanguage = createWithEmbededCSV("norway", "no", "Norwegian", embedLachhhNorvegian, "Banansint", false);
		static public var CHINESE:ModelLanguage = createWithEmbededCSV("cn", "zh-CN", "中文", embedLachhhCn, "Gengo", true);
		static public var JAPANESE:ModelLanguage = createWithEmbededCSV("ja", "ja","日本語", embedLachhhJa, "Gengo", true);
		static public var DANISH:ModelLanguage = createWithEmbededCSV("danish", "da","Danish", embedLachhhDanish, "TheLostDims", false);
		//static public var POLISH:ModelLanguage = createWithEmbededCSV("polish", "Polish", embedLachhhPolish, "DarkStoorM\nPedziszewski", false);
		static public var RUSSIAN:ModelLanguage = createWithEmbededCSV("ru", "ru", "Russian", embedLachhhRussian, "Just_A_Gamer", true);
		static public var TURKISH:ModelLanguage = createWithEmbededCSV("tr", "tr", "Turkish", null, "Berkecan and Thorban", true);
		
		static public var HODOR:ModelLanguage = create("hodor", "hodor", "Hodor");
		static public var EXPORTED:ModelLanguage = createWithEmbededCSV("exported", "exported", "YourOwn!", null, "", false);
		
		static public function addInAllLanguage(id:int, txt:String):void {
			for (var i : int = 0; i < ALL.length; i++) {
				var modelLabuage:ModelLanguage = ALL[i];
				modelLabuage.addText(id, txt);
			}
		}
		
		static public function create(id:String, crowdInId:String, fullName:String):ModelLanguage {
			var m:ModelLanguage = new ModelLanguage(ALL.length, id, crowdInId, fullName);
			if(!getFromId(id).isNull) throw new Error("Duplicate ID!");
			ALL.push(m);
			return m;
		}
				
		static public function createWithEmbededCSV(id:String, crowdInId:String, fullName:String, embeddedClass:Class, pTranslationBy:String, useNotoFont:Boolean):ModelLanguage {
			var m:ModelLanguage = new ModelLanguage(ALL.length, id, crowdInId, fullName);
			if(!getFromId(id).isNull) throw new Error("Duplicate ID!");
			m.embeddedCSVClass = embeddedClass;
			m.translationBy = pTranslationBy;
			m.useNotoFont = useNotoFont;
			ALL.push(m);
			return m;
		}
		
		static public function getFromId(id:String):ModelLanguage {
			for (var i : int = 0; i < ALL.length; i++) {
				var g:ModelLanguage = ALL[i] as ModelLanguage;
				if(id == g.id) return g;
			}
			return NULL;
		} 
		
		static public function getFromCrowdInId(crowdInId:String):ModelLanguage {
			for (var i : int = 0; i < ALL.length; i++) {
				var g:ModelLanguage = ALL[i] as ModelLanguage;
				if(crowdInId == g.crowdInId) return g;
			}
			return NULL;
		} 
		
		static public function getIdOfModel(m:ModelLanguage):int {
			return ALL.indexOf(m);
		}
		
		static public function allCopyFromEnglish():void {
			for (var i : int = 0; i < getNum(); i++) {
				var m:ModelLanguage = ALL[i];
				if(m.id == ENGLISH.id) continue;
				m.copyFrom(ENGLISH);
			}
		}
		
		static public function getNext(m:ModelLanguage, mod:int):ModelLanguage {
			if(mod == 0) return m;
			var index:int = getIdOfModel(m) + mod;
			
			while(index < 0) index += ALL.length;
			while(index >= ALL.length) index -= ALL.length;
			var result:ModelLanguage = getFromIndex(index);
			if(result == m) return result;
			if(!result.isVisible()) return getNext(result, mod);
			return result;
		}
		
		static public function getFromIndex(index:int):ModelLanguage {
			if(index >= ALL.length) return NULL;
			if(index < 0) return NULL;
			return ALL[index] as ModelLanguage;
		}  
				
		static public function getNum():int {
			return ALL.length;
		}
		
		static public function getSpecialThanksText():String {
			ENGLISH.translationBy = "@Thompson_Kaa";
			var result:String = "";
			for (var i : int = 0; i < getNum(); i++) {
				var m:ModelLanguage = ALL[i];
				if(!m.hasToBeAddedToSpecialThanks()) continue;
				result = result + "\n\n" + m.getSpecialThanksText() ;
			}			
			return result;
		}
	}
}
