package com.berzerkstudio {
	import com.lachhh.io.Callback;
	import com.lachhhStarling.berzerk.BerzerkStarlingManager;
	import com.lachhhStarling.BerzerkAnimationManager;
	import com.lachhhStarling.berzerk.MetaFla;
	import com.lachhhStarling.OptimizedImage;
	import starling.textures.TextureSmoothing;
	import starling.display.Image;

	import com.berzerkstudio.flash.display.ShapeObject;
	import com.berzerkstudio.flash.meta.Vector3;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhhStarling.StarlingAnimationFactory;

	import flash.geom.Transform;

	public class MetaCachedGO {
		static public var LIFE_CACHED : int = 10;
		static public var NULL : MetaCachedGO = createNull();

		public var go : Actor ;
		public var id:int ;
		public var cacheId:int ;
		
		public var shapeObject:com.berzerkstudio.flash.display.ShapeObject;
		
		public var meshVertices:Vector.<Vector3>;
		public var transform:Transform ;
		
		public var nextCachedGO:MetaCachedGO = null;	
		public var nextActiveGO:MetaCachedGO = null;
		public var prevActiveGO:MetaCachedGO = null;
		public var isCached:Boolean = true;
		public var starlingImage:OptimizedImage ;
		
		public var notUsed:Boolean = false;
		public var firstDraw:Boolean = false;
		public var firstDrawPerCache:Boolean = false;
		
		public var isLite:Boolean = false;
		
		public var callbackForClearImage:Callback;
		
		public var lifeCached:int = LIFE_CACHED;
		
		static private var _voidPos : Vector3 = new Vector3(-1000, -1000, -1000);
		static private var _zero : Vector3 = Vector3.zero;
		public var isNull : Boolean = false;

		public function MetaCachedGO() {
			callbackForClearImage = new Callback(clearCachedImageData, this, null);
		}

		public function init(d : com.berzerkstudio.flash.display.ShapeObject) : void {
			shapeObject = d;
			shapeObject.metaGo = this;
			lifeCached = LIFE_CACHED;
			isCached = false;
		}
		
		public function onCache():void {
			if(isCached) return ;
			
			if(starlingImage != null) {
				//starlingImage.parent.removeChild(starlingImage);
				//starlingImage.visible = false;
				StarlingAnimationFactory.cacheImage(starlingImage);
				//starlingImage.visible = false;
			}
			var fla:MetaFla = BerzerkStarlingManager.berzerkFlaLoader.getMetaFlaFromModel(shapeObject.modelFla);
			fla.callbacksOnUnloaded.removeCallback_UNSORT(callbackForClearImage);
			starlingImage = null;
			shapeObject.metaGo = null;
			shapeObject.metaCollider = null;
			isCached = true;
			shapeObject = null;
		}
		
		public function clearCachedImageData():void{
			starlingImage = null;
		}
		
		public function getImage():OptimizedImage {
			if(isCached) {
				return null;
			}
			if(starlingImage == null) {
				starlingImage = StarlingAnimationFactory.getImage(shapeObject.metaDisplayObject.textureName);
				starlingImage.blendMode = shapeObject.modelFla.blendMode;
				starlingImage.smoothing = shapeObject.modelFla.smoothing;
				starlingImage.shapeObject = shapeObject;
				var fla:MetaFla = BerzerkStarlingManager.berzerkFlaLoader.getMetaFlaFromModel(shapeObject.modelFla);
				fla.callbacksOnUnloaded.addCallback(callbackForClearImage);
			}
			
			starlingImage.visible = true;
			return starlingImage;
		}
		
	
		
		public function Dispose():void {
			
		}
		
		static private function createNull() : MetaCachedGO {
			var result:MetaCachedGO = new MetaCachedGO();
			result.isNull = true;
			return result;
		}
	} 
}