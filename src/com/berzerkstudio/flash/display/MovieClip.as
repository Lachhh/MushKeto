package com.berzerkstudio.flash.display {
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import com.berzerkstudio.flash.meta.MetaMovieClip;
	import com.berzerkstudio.flash.meta.MetaMovieClipFrame;
	import com.lachhhStarling.SymbolManager;
	public class MovieClip extends DisplayObjectContainer {
		private var _currentFrame:int = 0;
		
		private var _crntMetaFrame:MetaMovieClipFrame = null;
		private var _lastFrameConstructed:MetaMovieClipFrame = null;
		private var _isPlaying:Boolean = true;
		
		private var _metaMovieClip:MetaMovieClip = null;
		
		private var _isDynamic:Boolean = true;
		private var _widthEstimated:Number = 0;
		private var _heightEstimated:Number = 0;
		private var _regXEstimated:Number = 0;
		private var _regYEstimated:Number = 0;
		// private var _dimentionChanged:Boolean;
		private var _totalFrames : int = 1;

		public function MovieClip() {
		}

		override public function onEnterFrame() : void
		{
			if(_isDynamic) return ;
			
			if(_isPlaying) {
				_currentFrame++ ;
				
				if(_currentFrame >= (_totalFrames+1)) {
					_currentFrame -= _totalFrames;
				}
				
				_crntMetaFrame = metaMovieClip.GetMetaFrame(currentFrame) ;
			}
			
			//_dimentionChanged = true;
			/*if(_isPlaying &&  className.indexOf("ASSET_") != -1) {
				gotoAndStop(1);
			}*/
			ConstructFrame();
			
			super.onEnterFrame();
		}
		
		override public function LoadFromMeta(m:MetaDisplayObject):void {
			super.LoadFromMeta(m);
			_isDynamic = false;
			_isPlaying = true;
			_lastFrameConstructed = null;
			_metaMovieClip = (metaDisplayObject as MetaMovieClip);
			_currentFrame = 1;
			_totalFrames = metaMovieClip.numFrames;
			_crntMetaFrame = metaMovieClip.GetMetaFrame(currentFrame) ;
			ConstructFrame();
			
			
			hitArea.width = width;
			hitArea.height = height;
			
		}
		
		public function gotoAndStop(i:int):void {
			_isPlaying = false;
			if(i == _currentFrame) return ;
			_currentFrame = i;
			if(i > _totalFrames) _currentFrame = _totalFrames;
			if(i < 1) _currentFrame = 1;
			
			//ConstructFrame();
			if(_metaMovieClip != null && _metaMovieClip.metaMovieClipFrames != null) {
				_crntMetaFrame = _metaMovieClip.GetMetaFrame(currentFrame) ;
				/*if(_metaMovieClip.theClassName == "WEAPONS") {
					_metaMovieClip.theClassName = "WEAPONS";
				}*/
			} /*else {
				var a:int =0 ; 
				a = 1;
			}*/
			
			
		}
		
		public function gotoAndStopStr(frame:String):void {
			if(_metaMovieClip == null) return ;
			gotoAndStop(_metaMovieClip.GetFrame(frame));
		}
		
		public function prevFrame():void {
			gotoAndStop(_currentFrame-1);
		}
		
		public function nextFrame():void {
			gotoAndStop(_currentFrame+1);
		}
		
		public function gotoAndPlayStr(frame:String):void {
			if(_metaMovieClip == null) return ;
			gotoAndPlay(_metaMovieClip.GetFrame(frame));
		}
		
		public function gotoAndPlay(i:int):void {
			_currentFrame = i;
			if(i > _totalFrames) _currentFrame = _totalFrames;
			if(i < 1) _currentFrame = 1;
			//ConstructFrame();
			if(_metaMovieClip != null && _metaMovieClip.metaMovieClipFrames != null) {
				_crntMetaFrame = _metaMovieClip.GetMetaFrame(currentFrame) ;
			}
			play();
		}
		
		public function stop():void {
			_isPlaying = false;
		}
		
		public function play():void {
			_isPlaying = true;
		}
		
		public function ConstructFrame():void {
			//if(metaMovieClip == null || metaMovieClip.metaMovieClipFrames == null) return ;
			
			var metaFrame:MetaMovieClipFrame = crntMetaFrame ;
			var displayObject:DisplayObject ;
			var bestCandidate:DisplayObject ;
			var metaDisplayObject:MetaDisplayObject ;
			
			
			if(_lastFrameConstructed != metaFrame) {
				var crntChild:DisplayObject = firstChild;
				
				for(var i:int = 0 ; i < numChildren ; i++) {
					if(crntChild.isInternal) {
						crntChild.toBeRemovedInternal = true;
					}
					crntChild = crntChild.nextSibling;
				}
				
				if(metaFrame != null) {
					for(i = 0 ; i < metaFrame.metaDisplayObjects.length ; i++) {
						metaDisplayObject = metaFrame.metaDisplayObjects[i];
						
						//Most of the time, the object doesn'T change depth order. So (i) is the best candidate to be the same displayObject
						bestCandidate = getChildAt(i);
						if(bestCandidate != null && bestCandidate.name == metaDisplayObject.name) {
							displayObject = bestCandidate;
						} else {
						 	displayObject = getChildByName(metaDisplayObject.name) ;
						}
						
						if(displayObject == null) {
							
							displayObject = SymbolManager.CreateNewSymbol(metaDisplayObject);
							
							displayObject.name = metaDisplayObject.name;
							displayObject.isInternal = true;
							addChildAt(displayObject, i);
						} else {
							displayObject.toBeRemovedInternal = false;
							//if(displayObject.childIndex != i) {
								addChildAt(displayObject, i);	
							//}
						}
						
						/*if(displayObject.className == "ZI_INTERFACES_SYMBOL_137") {
							displayObject.className = displayObject.className;
						}*/
						displayObject.transform.LoadFromTransform(metaDisplayObject.transform);
					}
				}
				
				//Remove unlisted DisplayObject.				
				crntChild = firstChild;
				for(i = 0 ; i < numChildren ; i++) {
					if(crntChild.isInternal && crntChild.toBeRemovedInternal) {
						var childToRemove:DisplayObject = crntChild;
						crntChild = crntChild.nextSibling;
						childToRemove.toBeRemovedInternal = false;
						removeChild(childToRemove);
						SymbolManager.CacheDisplayObject(childToRemove);
						i--;
					} else {
						crntChild = crntChild.nextSibling;
					}
				}
				
				_lastFrameConstructed = metaFrame;
			}
	
			
			if(metaMovieClip.stopOnEnter[currentFrame-1] == true) {
				stop();
			}
		}
		
		public function get currentFrame():int {
			return _currentFrame;
		}
		
		public function get totalFrames():int {
			return _totalFrames;
		}	
		
		public function get crntMetaFrame():MetaMovieClipFrame {
			return _crntMetaFrame ;
		}
		
		public function get metaMovieClip():MetaMovieClip { 
			return _metaMovieClip;
		}
		
		override public function addChildAt(d:DisplayObject, index:int):void {
			super.addChildAt(d, index);
			UpdateEstimated();
		}
		
		override public function removeChild(d:DisplayObject):void {
			super.removeChild(d);
			UpdateEstimated();
		}
		
		private function UpdateEstimated():void {
			if(_isDynamic) {
				if(numChildren > 0) {
					_widthEstimated = firstChild.width;
					_heightEstimated = firstChild.height;
					_regXEstimated = firstChild.regX;
					_regYEstimated = firstChild.regY;
				} else {
					_widthEstimated = 0;
					_heightEstimated = 0;
					_regXEstimated = 0;
					_regYEstimated = 0;
				}
			}
		}
		
		override public function get width():Number{
			if(_isDynamic) {
				return _widthEstimated*scaleX;
				/*if(numChildren > 0) {
					 return firstChild.width*scaleX;
				} else {
					return 0;
				}*/
			}
			return _crntMetaFrame.bounds.width;
		}
		
		
		
		override public function get height():Number{
			if(_isDynamic) {
				return _heightEstimated*scaleY;
				/*if(numChildren > 0) {
					return firstChild.height*scaleY;
				} else {
					return 0;
				}*/
			}
			return _crntMetaFrame.bounds.height;
		}
		
		override public function get regX():Number{
			if(_isDynamic) {
				return _regXEstimated;
				/*if(numChildren > 0) {
					return firstChild.regX;
				} else {
					return 0;
				}*/
			}
			return _crntMetaFrame.bounds.x ;
		}
		
		override public function get regY():Number{
			if(_isDynamic) {
				return _regYEstimated;
				/*if(numChildren > 0) {
					return firstChild.regY;
				} else {
					return 0;
				}*/
			}
			return _crntMetaFrame.bounds.y ;
		}

		public function get isPlaying() : Boolean {
			return _isPlaying;
		}
		
		public function recurStop() : void {
			stop();
			for (var i:int = 0 ; i < numChildren ; i++)	 {
				var m:MovieClip = getChildAt(i) as MovieClip;
				if(m) m.recurStop();
			}
		}
	}
}