package com.lachhh.io.statsAPI {

	/**
	 * @author Lachhh
	 */
	public class MetaStatData {
		private var _name:String;
		private var _value:Number;
		private var _type:String;
		static public const TYPE_MAX:String = "max";
		static public const TYPE_MIN:String = "min";
		static public const TYPE_ADD:String = "add";
		public function MetaStatData(name:String, value:Number, type:String = TYPE_MAX):void {
			_name = name;
			_value = value;
			_type = type;
		}
		
		public function get name():String {return _name;}
		public function set name(name:String):void {_name = name;}
		public function get value():Number {return _value;}
		public function set value(value:Number):void {_value = value;}
		public function get type():String {return _type;}
		public function set type(type:String):void {_type = type;}
	}
}
