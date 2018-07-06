package com.berzerkrpg.components {
	import com.animation.exported.FX_SEARCH;
	import com.animation.exported.FX_LISTOFINGREDIENTS;
	import com.animation.exported.FX_BERZERK_PASS;
	import com.animation.exported.FX_BERZERK_USER;
	import com.animation.exported.FX_CODE_INPUT;
	import com.animation.exported.FX_INGREDIENT_QTY;
	import com.animation.exported.FX_RECIPENAME;
	import com.animation.exported.FX_SELFIE_QUOTE;
	import com.berzerkrpg.MainGame;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.ResolutionManager;
	import com.lachhh.flash.FlashAnimation;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.utils.Utils;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Shayne
	 */
	public class StarlingTextInputComponent extends ActorComponent {
		public var maxTxtField : int = 32;
	
		public var flashAnim : FlashAnimation;
		private var _flashTextField:flash.text.TextField;
		private var _bzkTextField:com.berzerkstudio.flash.display.TextField;
		private static var helperPoint : Point = new Point();
		public var onEndEditCallback:Callback ;
		public var clearOnStartEdit:Boolean = false;
		public var isSingleLine:Boolean = false;

		public function StarlingTextInputComponent() {
			super();
			setAnim(new FX_SELFIE_QUOTE());
			setEmbedSettings();

			MainGame.instance.stage.addEventListener(Event.RESIZE, onResize);
		}

		private function onResize(event : Event) : void {
			resizeTf();
		}
		public function setAsSearch() : void {
			setAnim(new FX_SEARCH());
			clearOnStartEdit = false;
			maxTxtField = 24;
			_flashTextField.text = "";
			isSingleLine = true;
		}
		
		public function setRecipeName():void {
			setAnim(new FX_RECIPENAME());
			clearOnStartEdit = false;
			maxTxtField = 24;
			_flashTextField.text = "< recipe name >";
			isSingleLine = true;
		}
		
		public function setListOfIngredients():void {
			setAnim(new FX_LISTOFINGREDIENTS());
			clearOnStartEdit = true;
			maxTxtField = 24;
			_flashTextField.text = "< Copy paste ingredients here >";
		}
		
		public function setQty() : void {
			setAnim(new FX_INGREDIENT_QTY());
			clearOnStartEdit = false;
			maxTxtField = 36;
			isSingleLine = true;
		}
		
		public function setUser():void {
			setAnim(new FX_BERZERK_USER());
			clearOnStartEdit = true;
			maxTxtField = 24;
			_flashTextField.text = "Username";
			isSingleLine = true;
		}
		
		public function setPass():void {
			setAnim(new FX_BERZERK_PASS());
			clearOnStartEdit = true;
			maxTxtField = 24;
			_flashTextField.text = "";
			isSingleLine = true;
		}
		
		public function setInputCode():void{
			setAnim(new FX_CODE_INPUT());
			clearOnStartEdit = true;
			maxTxtField = 25;
			_flashTextField.text = "[Enter Code]";
			isSingleLine = true;
		}
		
		public function setAnim(anim:FlashAnimation):void {
			cleanUpTextField();
			flashAnim = anim;
			_flashTextField = flashAnim.getChildByName("quoteTxt") as flash.text.TextField;
			_flashTextField.needsSoftKeyboard = true;
			
			resizeTf();
			//if(_bzkTextField) _flashTextField.width = _bzkTextField.width;
			
			_flashTextField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_flashTextField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut); 
			
			MainGame.instance.stage.addChild(flashAnim);
		}
		
		private function resizeTf():void {
			_flashTextField.scaleX = ResolutionManager.getWindowVsGameScaleX();
			_flashTextField.scaleY = ResolutionManager.getWindowVsGameScaleY();
		}
		
		public function setFlashTextVisible(b:Boolean):void{
			_flashTextField.visible = b;
		}
		
		public function setEmbedSettings():void {
			 var tf:TextFormat = _flashTextField.getTextFormat();
			_flashTextField.embedFonts = true;
			_flashTextField.defaultTextFormat = tf;
		}
		
		public function copyButtonDataForMobile(btn:com.berzerkstudio.flash.display.TextField):void{
			helperPoint.setTo(0, 0);
			btn.getPosOnScreen(helperPoint);
			var x:Number = helperPoint.x ;
			var y:Number = helperPoint.y ;
			var scaleX:Number = ResolutionManager.getWindowVsGameScaleX();
			var scaleY:Number = ResolutionManager.getWindowVsGameScaleY();
			x *= scaleX;
			y *= scaleY;
			flashAnim.x = x;
			flashAnim.y = y;
			
			_flashTextField.alpha = 1;
		}
		
		public function onFocusIn(e:FocusEvent):void {
			onStartEdit();
		}
		
		public function onFocusOut(e:FocusEvent):void {
			onEndEdit();
			if(onEndEditCallback) onEndEditCallback.call();
		}
		
		public function onStartEdit():void {
			if(VersionInfo.modelPlatform.isAndroid())  {
				//_flashTextField.y = -selfieQuote.y+100;
				_flashTextField.requestSoftKeyboard();
				//var ui:UI_Background = UI_Background.show();
			}
			if(clearOnStartEdit) _flashTextField.text = "";
			//ui.showChains(false);
		}
		
		public function setAsPassword(b:Boolean):void {
			_flashTextField.displayAsPassword = b;
		}
		
		public function setText(str:String):void {
			 _flashTextField.text = str;
			 refreshBerzerkText();
		}
		
		public function onEndEdit():void {
			
		}
		 
		public function giveControlOfTextField(tf:com.berzerkstudio.flash.display.TextField):void{
			_bzkTextField = tf;
			_bzkTextField.visible = false;
			_flashTextField.text = _bzkTextField.text;
			_flashTextField.alpha = 1;
			refreshBerzerkText();
		}
		
		private function refreshBerzerkText():void {
			_bzkTextField.text = _flashTextField.text;
			if(!isSingleLine) Utils.SetMaxSizeOfTxtField(_flashTextField, maxTxtField);
			_bzkTextField.height = _flashTextField.textHeight;
		}

		
		public override function start():void{
			super.start();
		}
		
		public override function update():void{
			super.update();
			
			if(_flashTextField.text != _bzkTextField.text){
				refreshBerzerkText();
			}
			copyButtonDataForMobile(_bzkTextField);
		}
		
		public override function refresh():void{
			super.refresh();
		}
		
		public function showKeyboard():void {
			MainGame.instance.stage.focus = _flashTextField;
			_flashTextField.setSelection(0, _flashTextField.text.length);
		}
		
		private function cleanUpTextField():void{
			if(flashAnim == null) return ; 
			MainGame.instance.stage.removeChild(flashAnim);
			_flashTextField.removeEventListener(FocusEvent.FOCUS_IN, onStartEdit);
			_flashTextField.removeEventListener(FocusEvent.FOCUS_OUT, onEndEdit);
			flashAnim = null;
		}
		
		public override function destroy():void{
			cleanUpTextField();
			MainGame.instance.stage.removeEventListener(Event.RESIZE, onResize);
			super.destroy();
		}
		
		public static function addToActor(actor:Actor, textToControl:com.berzerkstudio.flash.display.TextField):StarlingTextInputComponent{
			var result:StarlingTextInputComponent = new StarlingTextInputComponent();
			actor.addComponent(result);
			result.giveControlOfTextField(textToControl);
			return result;
		}

		public function showStarling() : void {
			_bzkTextField.visible = true;
			_flashTextField.visible = false;
		}
		
		public function showFlash() : void {
			_bzkTextField.visible = false;
			_flashTextField.visible = true;
		}
		
		public function isTextEmpty():Boolean {
			return (_flashTextField.text == "");
		}
		
		public function getText():String {
			return _flashTextField.text; 
		}
	}
}
