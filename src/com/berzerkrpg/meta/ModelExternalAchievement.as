package com.berzerkrpg.meta {
	import com.lachhh.lachhhengine.meta.ModelBase;

	/**
	 * @author LachhhSSD
	 */
	public class ModelExternalAchievement extends ModelBase {
		public var idOnSteam:String;
		public var idArmorGames:String;
		
		public function ModelExternalAchievement(pIndex:int, pId : String) {
			super(pIndex, pId);
			idOnSteam = pId;
		}
	}
}
