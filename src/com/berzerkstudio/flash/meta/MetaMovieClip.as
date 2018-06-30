
package com.berzerkstudio.flash.meta {
	public class MetaMovieClip extends MetaDisplayObjectContainer {
		
		public var metaMovieClipFrames: Vector.<MetaMovieClipFrame> = new Vector.<MetaMovieClipFrame>();
		public var frameToMetaId:Vector.<int>;
		public var stopOnEnter:Vector.<Boolean>;
		public var frameLabels : Vector.<String>;
		public var frameLabelsId : Vector.<int>;

		public function MetaMovieClip() {
		}

		public function HasFrameLabel(str : String) : Boolean {
			if(frameLabels == null) return false;
			for(var i:int = 0; i < frameLabels.length ; i++) {
				if(frameLabels[i] == str) return true;
			}
			return false;
		}
		
		public function GetFrame(str:String):int {
			if(frameLabels == null) return 1;
			for(var i:int = 0; i < frameLabels.length ; i++) {
				if(frameLabels[i] == str) return frameLabelsId[i];
			}
			return 1;
		}
		
		public function GetMetaFrame(i:int):MetaMovieClipFrame {
			return metaMovieClipFrames[i-1];
		}
		
		public function get numFrames():int {
			return frameToMetaId.length;
		}
		
		
		static public function create():MetaMovieClip {
			var result:MetaMovieClip = new MetaMovieClip();
			result.frameLabelsId = new Vector.<int>();
			result.stopOnEnter = new Vector.<Boolean>();
			result.stopOnEnter.push(false);
			result.frameLabels = new Vector.<String>();
			
			result.frameToMetaId = new Vector.<int>();
			result.frameToMetaId.push(0);
			result.metaMovieClipFrames.push(new MetaMovieClipFrame());
			return result;
		}
	}
}