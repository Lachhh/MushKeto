//@script Serializable
package com.berzerkstudio.flash.meta {
	public class MetaMovieClipFrame {
		public var metaDisplayObjects: Vector.<MetaDisplayObject> = new Vector.<MetaDisplayObject>(); ;
		public var bounds:MetaRectangle ;
		
		public function MetaMovieClipFrame() {
			bounds = new MetaRectangle();
		}
	}
}