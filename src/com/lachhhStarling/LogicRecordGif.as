package com.lachhhStarling {
	import com.berzerkrpg.effect.CallbackWaitEffect;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhhStarling.berzerk.BerzerkStarlingManager;

	import org.bytearray.gif.encoder.GIFEncoder;

	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	/**
	 * @author Shayne
	 */
	public class LogicRecordGif extends ActorComponent {
		
		public var callbackOnFinished:Callback;
		
		private var bitmapArray:Array;
		
		private var imageWidth:Number;
		private var imageHeight:Number;
		
		private var rendererCallback:Callback;
		
		private var isRecording:Boolean = false;
		
		public function LogicRecordGif() {
			super();
			initImageData();
		}
		
		public function startRecording():void{
			bitmapArray = new Array();
			rendererCallback = new Callback(onRenderComplete, this, null);
			BerzerkStarlingManager.instance.onRenderComplete.addCallback(rendererCallback);
		}
		
		public function finishRecording():void{
			BerzerkStarlingManager.instance.onRenderComplete.removeCallback(rendererCallback);
			isRecording = false;
			if(callbackOnFinished) callbackOnFinished.call();
		}
		
		public function exportGif():ByteArray{
			var encoder:GIFEncoder = new GIFEncoder();
			encoder.start();
			
			for each(var data:BitmapData in bitmapArray){
				encoder.addFrame(data);
			}
			
			encoder.finish();
			return encoder.stream;
		}
		
		private function onRenderComplete():void{
			if(!isRecording) return;
			
			var bitmap:BitmapData = renderToNewBitmap();
			bitmapArray.push(bitmap);
		}
		
		private function initImageData():void{
			imageWidth = StarlingMain.starling.viewPort.width;
			imageHeight = StarlingMain.starling.viewPort.height;
		}
		
		private function renderToNewBitmap():BitmapData{
			var result:BitmapData = new BitmapData(imageWidth, imageHeight, false);
			StarlingMain.starling.context.drawToBitmapData(result);
			return result;
		}
		
		public static function addToActor(actor:Actor):LogicRecordGif{
			var result:LogicRecordGif = new LogicRecordGif();
			actor.addComponent(result);
			return result;
		}
		
		public static function recordForDuration(actor:Actor, duration:int, onComplete:Callback):LogicRecordGif{
			var result:LogicRecordGif = addToActor(actor);
			
			result.callbackOnFinished = onComplete;
			result.startRecording();
			CallbackWaitEffect.addWaitCallFctToActor(actor, result.finishRecording, duration);
			
			return result;
		}
	}
}
