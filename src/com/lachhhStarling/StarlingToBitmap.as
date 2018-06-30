package com.lachhhStarling {
	import com.lachhhStarling.berzerk.BerzerkStarlingManager;
	import com.lachhh.ResolutionManager;
	import starling.core.RenderSupport;
	import flash.display.BitmapData;
	/**
	 * @author Shayne
	 */
	public class StarlingToBitmap {
		
		public var bitmapData:BitmapData;
		
		public function StarlingToBitmap(){
			
		}
		
		public function extractTexture():void{
			var width:Number = StarlingMain.starling.viewPort.width;
			var height:Number = StarlingMain.starling.viewPort.height;
			
			var scaleX:Number = ResolutionManager.gameSize.width / ResolutionManager.windowSize.width;
			var scaleY:Number = ResolutionManager.gameSize.height / ResolutionManager.windowSize.height;
			
			var scaledwindowWidth:Number = width * scaleX;
			var scaledwindowHeight:Number = height * scaleY;
			
			var renderSupport:RenderSupport = new RenderSupport();
			renderSupport.clear();
			renderSupport.setProjectionMatrix(0, 0, scaledwindowWidth, scaledwindowHeight);
			BerzerkStarlingManager.instance.render(renderSupport, 1.0);
			renderSupport.finishQuadBatch();
			var result:BitmapData = new BitmapData(width, height, false);
			StarlingMain.starling.context.drawToBitmapData(result);
			
			bitmapData = result;
		}
		
		
		public function destroy():void {
			bitmapData.dispose();
		}
	}
}
