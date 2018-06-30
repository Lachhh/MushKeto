package com.berzerkrpg.io.stats {

	/**
	 * @author Lachhh
	 */
	public class StatsStatic extends StatsGroup {
		private static var _instance : StatsStatic;
		static public const ID_MONEY_EARNED: int = instance.NewStats(0, "MONEY");
		static public const ID_MONEY_SPENT: int = instance.NewStats(0, "MONEY_SPENT");
		static public const ID_KILL : int = instance.NewStats(0, "KILL");
		
		static public const ID_USED_CODE_0 : int = instance.NewStats(0, "CODE_0");
		static public const ID_USED_CODE_1 : int = instance.NewStats(0, "CODE_1");
		static public const ID_USED_CODE_2 : int = instance.NewStats(0, "CODE_2");
		
		static public function get instance() : StatsStatic {
			if(_instance == null) _instance = new StatsStatic();
			return _instance;
		}

		override public function get name() : String {
			return "Static";
		}
	}
}
