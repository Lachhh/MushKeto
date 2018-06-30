package com.berzerkrpg.multilingual {
	import com.lachhh.flash.FlashUtils;
	/**
	 * @author LachhhSSD
	 */
	public class TextInstance {
		private static const X : String = "[x]";
		public var id : int = 0;

		public function TextInstance(pId:int) {
			id = pId;
		}

		public function getText():String {
			return TextFactory.getMsg(id);
		}
		
		public function getTextFromLang(l:ModelLanguage):String {
			if(!l.isEquals(ModelLanguageEnum.ENGLISH)) {
				if(!l.hasTextAt(id)) return getEngText();
			}
			return l.getText(id);
		}
		
		public function getEngText():String {
			return ModelLanguageEnum.ENGLISH.getText(id);
		}
		
		public function replaceXValue(str : String) : String {
			return replace(X, str);
		}

		private function replace(toReplace : String, toBeReplacedWith : String) : String {
			return FlashUtils.myReplace(getText(), toReplace, toBeReplacedWith);
		}
	}
}
