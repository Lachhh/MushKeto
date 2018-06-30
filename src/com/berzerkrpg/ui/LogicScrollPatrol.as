package com.berzerkrpg.ui {
	import com.berzerkrpg.components.TweenNumberComponent;
	import com.berzerkrpg.effect.CallbackWaitEffect;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class LogicScrollPatrol extends ActorComponent {
		private var viewScrollBar:ViewScrollBar;
		public var tweenNumber:TweenNumberComponent;
		public var wait:CallbackWaitEffect;
		
		public function LogicScrollPatrol(pViewScrollbar:ViewScrollBar) {
			super();
			viewScrollBar = pViewScrollbar;
		}

		override public function start() : void {
			super.start();
			tweenNumber = new TweenNumberComponent();
			actor.addComponent(tweenNumber);
			tweenNumber.ease = 0.001;
			tweenNumber.gotoValue = 0;
			tweenNumber.value = 0;
			
			wait = CallbackWaitEffect.addWaitCallFctToActor(actor, changeDirection, 180);
		}
		
		public function faster():void {
			if(tweenNumber.ease >= 0.05) return;
			tweenNumber.ease += 0.003;
			refreshWait();
		}
		
		public function slower():void {
			if(tweenNumber.ease <= 0.001) return;
			tweenNumber.ease -= 0.003;
			refreshWait();
		}
		
		private function refreshWait():void {
			if(!wait) return ;
			var delta:Number = tweenNumber.gotoValue-tweenNumber.value;
			var numframe: int = delta/tweenNumber.ease;
			wait.wait = numframe+60;
		}
		
		private function changeDirection():void {
			if(tweenNumber.gotoValue == 0) {
				tweenNumber.gotoValue = 1;
			} else {
				tweenNumber.gotoValue = 0;
			}
			wait = CallbackWaitEffect.addWaitCallFctToActor(actor, changeDirection, (1/tweenNumber.ease)+60);
		}

		override public function destroy() : void {
			super.destroy();
			if(tweenNumber) tweenNumber.destroyAndRemoveFromActor();
		}

		override public function update() : void {
			super.update();
			if(viewScrollBar.isViewLargerThanScroll()) return ;
			if(Math.abs(tweenNumber.value-tweenNumber.gotoValue) < (tweenNumber.ease*1.5)) {
				viewScrollBar.setPrct(tweenNumber.gotoValue);
			} else {
				viewScrollBar.setPrct(tweenNumber.value);
			}
		}
	}
}
