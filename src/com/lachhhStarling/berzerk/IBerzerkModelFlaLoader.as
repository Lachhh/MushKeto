package com.lachhhStarling.berzerk {
	import com.berzerkstudio.ModelFla;
	import com.lachhh.io.Callback;
	/**
	 * @author Shayne
	 */
	public interface IBerzerkModelFlaLoader {
		function loadAllFlas(onEndCallback:Callback):void;

		function loadModelFlaAsset(m : ModelFla, onEndCallback : Callback) : void;
		function loadBunch(m : Vector.<ModelFla>, onEndCallback : Callback) : void;

		function isModelFlaAssetLoaded(model : ModelFla) : Boolean;
	}
}
