package com.lachhh.io.premiumAPI {
	import com.berzerkrpg.meta.ModelExternalAchievement;
	import com.lachhh.io.IExternalAPI;

	/**
	 * @author Lachhh
	 */
	public interface IAchievementAPI extends IExternalAPI{
		function bestowAchievement(m:ModelExternalAchievement):void
	}
}
