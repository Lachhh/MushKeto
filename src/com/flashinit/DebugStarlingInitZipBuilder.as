package com.flashinit {
	import com.lachhhStarling.berzerk.ZipAssetBuilder;
	import com.lachhh.io.Callback;
	import com.flashinit.DebugStarlingInit;

	/**
	 * @author Shayne
	 */
	public class DebugStarlingInitZipBuilder extends DebugStarlingInit {
		
		public function DebugStarlingInitZipBuilder() {
			super();
		}
		
		protected override function startGame():void{
			var builder:ZipAssetBuilder = new ZipAssetBuilder();
			builder.buildZipArchive(new Callback(super.startGame, this, null));
		}
	}
}
