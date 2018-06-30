package com.berzerkrpg.io.googlesheetsAPI {
	import com.lachhh.utils.Utils;
	/**
	 * @author LachhhSSD
	 */
	public class GoogleSheetData {
		public var values : Array;

		public function GoogleSheetData(pValues:Array) {
			values = pValues;
		}
		
		public function getAt(x:int, y:int):String{
			return getValue(values, x, y);
		}
		
		public function getValue(array:Array, x:int, y:int):String {
			if(array == null) return "";
			 if (y >= array.length) return "";
            var list:Array = array[y] as Array;
			if(list == null) return "";
            if (x >= list.length) return "";
            return list[x];
		}
		
		public function isInColumn(x:int, name:String):Boolean {
			var crntName:String = ""; 
			var i:int = 1;
			crntName = getValue(values, x, i);
			while(crntName != "") {
				if(name.toLowerCase() == crntName.toLowerCase()) return true;
				i++;
				crntName = getValue(values, x, i); 
			}
			return false;
		}
		
		public function getColumnOfDataNotNull(x:int):Array {
			var result:Array = new Array();
			var crntName:String = ""; 
			var i:int = 1;
			crntName = getValue(values, x, i);
			while(crntName != "") {
				result.push(crntName);
				i++;
				crntName = getValue(values, x, i); 
			}
			return result;
		}
		
		public function getAllDataNotNull():Array {
			var result:Array = new Array();
			var crntName:String = ""; 
			var x:int = 0;
			crntName = getValue(values, x, 0);
			while(crntName != "") {
				result = addIfNotIn(result, getColumnOfDataNotNull(x));
				x++;
				crntName = getValue(values, x, 0); 
			}
			return result;
		}
		
		private function addIfNotIn(output:Array, src:Array):Array {
			for (var i : int = 0; i < src.length; i++) {
				var data:String = src[i];
				data = data.toLowerCase();
				Utils.AddInArrayIfNotIn(output, data);
			}
			return output;
		}
		
		

		static public function createFromJSON(json : Object) : GoogleSheetData {
			var values:Array = json.values as Array;
			var result:GoogleSheetData = new GoogleSheetData(values);
			return result;
			
		}
	}
}
