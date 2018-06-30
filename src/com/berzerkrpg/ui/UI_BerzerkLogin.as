package com.berzerkrpg.ui {
	import com.berzerkrpg.DefaultMainGame;
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.components.StarlingTextInputComponent;
	import com.berzerkrpg.io.BerzerkPalsLogInRequest;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.io.Callback;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.io.KeyManager;
	import com.lachhh.lachhhengine.ExternalLinks;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.UIBase;
	import com.lachhh.lachhhengine.ui.UIOpenClose;

	import flash.ui.Keyboard;

	/**
	 * @author Shayne
	 */
	public class UI_BerzerkLogin extends UIOpenClose {
		
		public var lastLoginRequest:BerzerkPalsLogInRequest = new BerzerkPalsLogInRequest();
		public var onCloseCallback : Callback;
		private var textInputUser : StarlingTextInputComponent;
		private var textInputPass : StarlingTextInputComponent;
		
		private var _forceUsername:Boolean = false;

		public function UI_BerzerkLogin(forceUsername:String = "") {
			super(ModelFlashAnimationEnum.UI_BERZERKSIGNIN, 20, 35);
			
			renderComponent.animView.addChildOnNewParent(DefaultMainGame.UI_CONTAINER_ABOVE);
			
			registerClick(signinBtn, onSignIn);
			registerClick(registerBtn, onRegister);
			registerClick(forgotBtn, onForgot);
			registerClick(xBtn, close);	
			
			xBtn.hitArea.x = -40;
			xBtn.hitArea.y = -40;
			xBtn.hitArea.width = 80;
			xBtn.hitArea.height = 80;
			
			usernameTxt.text = "username";
			passwordTxt.text = "";
			
			centerOnWindow();
			refresh();
			
			endTextFieldBatchForStarlingMc(visual);
			
			if(forceUsername != ""){
				panel.gotoAndStop(2);
				_forceUsername = true;
				usernameTxt.text = forceUsername;
			} else {
				panel.gotoAndStop(1);
				_forceUsername = false;
				textInputUser = StarlingTextInputComponent.addToActor(this, usernameTxt);
				textInputUser.setUser();
			}
			
			textInputPass = StarlingTextInputComponent.addToActor(this, passwordTxt);
			textInputPass.setPass();
			
		}

				
		private function onSignIn():void{
			if(lastLoginRequest != null && !lastLoginRequest.isComplete) return;
			var name:String = "";
			var pass:String = textInputPass.getText();
			
			if(_forceUsername){
				name = usernameTxt.text;
			} else {
				name = textInputUser.getText();
			}
			
			lastLoginRequest = BerzerkPalsLogInRequest.createSendRequest(name, pass, new Callback(onSuccess, this, null), new Callback(onCredentialsError, this, null));
			UI_LoadingVecto.show(MainGame.instance.stage, "Signing in...");
			enableInput(false);
		}
		
		private function onSuccess():void{
			enableInput(true);
			UI_LoadingVecto.hide();
			close();
		}
		
		public override function close():void{
			if(onCloseCallback) onCloseCallback.call();
			super.close();
		}
		
		private function onCredentialsError():void{
			UI_LoadingVecto.hide();
			
			textInputPass.setFlashTextVisible(false);
			if(textInputUser) textInputUser.setFlashTextVisible(false);
			UI_PopUp.createOkOnly(lastLoginRequest.errorMessage, new Callback(onPopupClosed, this, null));
		}
		
		private function onPopupClosed():void{
			enableInput(true);
			textInputPass.setFlashTextVisible(true);
			if(textInputUser) textInputUser.setFlashTextVisible(true);
		}
		
		private function onRegister():void{
			var url:String = ExternalLinks.BERZERK_USER_REGISTER_URL;
			ExternalAPIManager.externalURLNavigator.gotoAndRecord(url);
		}
		
		private function onForgot():void{
			var url:String = ExternalLinks.BERZERK_FORGOT_PASSWORD_URL;
			ExternalAPIManager.externalURLNavigator.gotoAndRecord(url);
		}
		
		override public function update() : void {
			super.update();
			if(KeyManager.IsKeyPressed(Keyboard.ENTER)) {
				if(!UIBase.manager.hasInstanceOf(UI_PopUp)) onSignIn();
			}
		}
				
		override public function refresh() : void {
			super.refresh();
		}
		
		public function get panel() : MovieClip { return visual.getChildByName("panel") as MovieClip;}
		
		public function get xBtn() : MovieClip { return panel.getChildByName("xBtn") as MovieClip;}
		
		public function get usernameTxt() : TextField { return panel.getChildByName("usernameTxt") as TextField;}
		public function get passwordTxt() : TextField { return panel.getChildByName("passwordTxt") as TextField;}
		
		public function get signinBtn() : MovieClip { return panel.getChildByName("signinBtn") as MovieClip;}
		public function get registerBtn() : MovieClip { return panel.getChildByName("btnRegister") as MovieClip;}
		public function get forgotBtn() : MovieClip { return panel.getChildByName("btnForgotPassword") as MovieClip;}
	}
}
