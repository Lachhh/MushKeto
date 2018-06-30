package com.lachhh.flash.debug {
	import com.berzerkrpg.MainGame;
	import com.lachhh.lachhhengine.ui.UIBaseFlashOnly;

	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;

	/**
	 * @author LachhhSSD
	 */
	public class DebugFontLoopkup extends UIBaseFlashOnly {
		
		public var tf:TextField = new TextField();
		public function DebugFontLoopkup() {
			super(Sprite);
			
			//var f1:FontSFIronsidesExt;
			/*var f1:FontGothamBoldItalic;
			var f2:FontGothamBoldRegular;
			var f3:FontGothamBook;
			var f4:FontGothamMedium;
			var f5:FontSFIronsides;
			var f6:FontSFIronsideExt;
			var f7:FontTahoma;*/
			//var f8:FontTahomaBold;
			//var f9:FontTahomaRegular;
			//var f10:FontVinque;
			//POur checker toute les 
			var f1:Font1;
			var f2:Font2;
			var f3:Font3;
			var f4:Font4;
			var f5:Font5;
			var f6:Font6;
			var f7:Font7;
			//var f8:Font8;
			var f9:Font9;
			
			var f:AllFonts = new AllFonts();
			var tf:TextField = f.getChildAt(0) as TextField;
			trace(tf.getTextFormat().font);
			
			MainGame.instance.stage.addChild(f);
			tf.border = true;
			flash.text.Font.registerFont(Font1);
			flash.text.Font.registerFont(Font2);
			flash.text.Font.registerFont(Font3);
			flash.text.Font.registerFont(Font4);
			flash.text.Font.registerFont(Font5);
			flash.text.Font.registerFont(Font6);
			flash.text.Font.registerFont(Font7);
			flash.text.Font.registerFont(Font9);
			
			for each ( var s:Font in flash.text.Font.enumerateFonts( true ))
			{
			     if (s.fontName.substring(0,4) == "SF I")
			          trace(s.fontName + ", " + s.fontStyle + ", " + s.fontType);
			}
			destroy();
		}
	}
}
