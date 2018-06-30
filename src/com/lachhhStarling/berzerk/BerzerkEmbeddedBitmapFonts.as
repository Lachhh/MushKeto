package com.lachhhStarling.berzerk {
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	import starling.textures.TextureSmoothing;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	/**
	 * @author Shayne
	 */
	public class BerzerkEmbeddedBitmapFonts {
		
		[Embed(source="../../../../bin/starling/fonts/vinque.fnt", mimeType="application/octet-stream")]
		public static const vinqueXML:Class;

		[Embed(source="../../../../bin/starling/fonts/sf ironsides extended.fnt", mimeType="application/octet-stream")]
		public static const sfiornsidesextendedXML:Class;

		[Embed(source="../../../../bin/starling/fonts/gothambold.fnt", mimeType="application/octet-stream")]
		public static const gothamboldXML:Class;

		[Embed(source="../../../../bin/starling/fonts/cooper.fnt", mimeType="application/octet-stream")]
		public static const cooperXML:Class;
		
		[Embed(source="../../../../bin/starling/fonts/noto.fnt", mimeType="application/octet-stream")]
		public static const notoXML:Class;
		
		[Embed(source="../../../../bin/starling/fonts/fontNoto.png")]
		public static const fontNotoAtlasImg:Class;
		
		[Embed(source="../../../../bin/starling/fonts/fontatlas.png")]
		public static const fontAtlasImg:Class;
		
		[Embed(source="../../../../bin/starling/fonts/fontatlas.xml", mimeType="application/octet-stream")]
		public static const fontAtlasXML:Class;
		
		
		static public function loadFonts():void{
			var fontNotoTexture:Texture = Texture.fromEmbeddedAsset(fontNotoAtlasImg, false);
			
			
			var fontTexture:Texture = Texture.fromEmbeddedAsset(fontAtlasImg, false);
			var fontXML:XML = new XML(new fontAtlasXML);
			var fontAtlas:TextureAtlas = new TextureAtlas(fontTexture, fontXML);
			
			var tmpFont:BitmapFont;
			fontTexture = fontAtlas.getTexture("vinque_0");
			tmpFont = createFont("vinque-regular", fontTexture, vinqueXML);
			tmpFont.offsetY = 3;
			
			fontTexture = fontAtlas.getTexture("sf ironsides extended_0");
			tmpFont = createFont("sf ironsides extended", fontTexture, sfiornsidesextendedXML);
			tmpFont.offsetY = 3;
			
			fontTexture = fontAtlas.getTexture("gothambold_0");
			tmpFont = createFont("gothambold", fontTexture, gothamboldXML);
			tmpFont.offsetY = 3;
			
			fontTexture = fontAtlas.getTexture("cooper_0");
			tmpFont = createFont("cooper std black", fontTexture, cooperXML);
			tmpFont.offsetY = 3;
			
			tmpFont = createFont("noto", fontNotoTexture, notoXML);
			tmpFont.offsetY = -3;
			
			trace("all fonts loaded!");
		}
		
		static public function createFont(name:String, fontTexture:Texture, embeddedXML:Class):BitmapFont{
			var fontXML:XML = new XML(new embeddedXML);
			var font:BitmapFont = new BitmapFont(fontTexture, fontXML);
			font.smoothing = TextureSmoothing.TRILINEAR;
			starling.text.TextField.registerBitmapFont(font, name);
			return font;
		}
	}
}
