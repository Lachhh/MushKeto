package com.lachhh.flash.ui {
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkrpg.multilingual.TextInstance;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	//import com.lachhhEngine.multilingual.TextFactory;
	

	/**
	 * @author Simon Lachance
	 */
	public class TextFieldFinder extends MovieClip {
		private var _textFieldName:String ;
		private var _textId:String = "";
		private var textField:TextField ;
		
		static private var allTextFinder:Array = new Array();
		
		
		/*[Embed(source="../../../../../bin/fonts/SF Ironsides Extended.ttf")]
		static private var classFont:Class; */
		
		public function TextFieldFinder() {
			super();
			visible = false;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			findTextField();
			allTextFinder.push(this);
			refresh();
		}
		
		private function onRemovedFromStage(event : Event) : void {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onAddedToStage);
			
			var id:int = allTextFinder.indexOf(this);
			if(id != -1) allTextFinder.splice(-1);
		}
		
		
		private function findTextField():void {
			if(_textFieldName != null) {
				textField = parent.getChildByName(_textFieldName) as TextField;
			}
		}
		
		private function refresh() : void {
			if(textField == null) return ;
			var txtInstance:TextInstance = TextFactory.findTextInstanceFromNameOfVar(_textId); 
			if(txtInstance) textField.text = txtInstance.getText(); 
		}

		private function onMouseDown(event : MouseEvent) : void {
			trace(_textFieldName + "/" + _textId);
			var tf:TextFormat = textField.getTextFormat();
			trace(textField.embedFonts);
			trace(tf.font);
			refresh();
			//trace(classFont);
			//tf.font
		}
		
		[Inspectable(defaultValue="")]	
		public function get textFieldName():String {
			return _textFieldName;
		}
		
		public function set textFieldName(text:String):void {
			_textFieldName = text;
			findTextField();
		}
		
		[Inspectable(defaultValue="")]	
		public function get textId():String {
			return _textId;
		}
		
		public function set textId(textId:String):void {
			var bForceRefresh:Boolean = (_textId == "");
			_textId = textId;
			if(bForceRefresh) refresh();
		}
		
		static public function refreshAll():void {
			var txtFinder:TextFieldFinder;
			for (var i : int = 0; i < allTextFinder.length; i++) {
				txtFinder = allTextFinder[i];
				txtFinder.refresh();
			}
		}
		
		static public function triggerVisibleAllTExt():void {
			var txtFinder:TextFieldFinder;
			for (var i : int = 0; i < allTextFinder.length; i++) {
				txtFinder = allTextFinder[i];
				txtFinder.triggerVisible();
			}
		}

		private function triggerVisible() : void {
			if(textField == null) return;
			textField.visible = !textField.visible;
		}
	}
}
