package com.lachhh.io.statsAPI {
	import com.lachhh.io.IExternalAPI;

	/**
	 * @author Lachhh
	 */
	public interface IStatsAPI extends IExternalAPI {
		function SendStat(m:MetaStatData):void 
	}
}
