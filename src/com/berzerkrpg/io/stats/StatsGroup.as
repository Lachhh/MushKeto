package com.berzerkrpg.io.stats {
	import com.lachhh.flash.SecureNumber;

	/**
	 * @author Lachhh
	 */
	public class StatsGroup {
		static public const AUTO_NAME:String = "AUTO";
		static private var _allStatsGroup:Array = new Array(); 
		private const SEPARATOR:String = "[STATG]";
		private var _stats:Array = new Array();
		private var _defaultStats:Array = new Array();
		
		public function StatsGroup() {
			_allStatsGroup.push(this);
		}

		public function NewStats(defaultValue:Number = 0, debugName:String = AUTO_NAME):int {
			var stats:Stats = new Stats(new SecureNumber(defaultValue), debugName); 
			_stats.push(stats);
			_defaultStats.push(new SecureNumber(defaultValue));
			return _stats.length-1; 
		}
		
		public function GetStats(id:int):Stats{
			return (_stats[id] as Stats); 	
		}
		
		public function GetValue(id:int):Number {
			return GetStats(id).secureNumber.value;
		}
		
		public function SetValue(id:int, value:Number):void {
			if(_stats[id] == null) return ;
			SecureNumber(Stats(_stats[id]).secureNumber).value = value;
		}  
		
		public function AddValue(id:int, value:Number):void {
			SetValue(id, GetValue(id) + value);
		}
		
		public function ResetToDefault():void {
			for (var i:int = 0 ; i < _stats.length ; i++) {
				SetValue(i, SecureNumber(_defaultStats[i]).value);
			}
		}
		
		public function Encode():String {
			var result:String = "";
			for (var i:int = 0 ; i < _stats.length ; i++) {
				result += GetValue(i) + SEPARATOR;
			}
			result = result.substr(0, result.length - SEPARATOR.length);
			return result;	
		}
		
		public function Decode(s:String):void {
			if(s == "" || s == null) return ;
			var params:Array = s.split(SEPARATOR) ;
			for (var i:int = 0 ; i < params.length; i++) {
				if(!isNaN(Number(params[i]))) {
					SetValue(i, params[i]) ;
				}
			}	
		}
		
		public function get numStats():int {
			return _stats.length;
		}

		public function get name():String {
			return "StatsGroup";	
		}
		
		static public function get allStatsGroup():Array {
			return _allStatsGroup;
		}
	}
}
