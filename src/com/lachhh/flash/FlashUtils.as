package com.lachhh.flash {
	import com.adobe.serialization.json.JSON;
	import com.lachhh.lachhhengine.IEncode;

	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	/**
	 * @author Lachhh
	 */
	public class FlashUtils {
		static private var localDate:Date = new Date(); 
		
		static public function mySplit(strToSplit:String, arg:String):Array {
			return strToSplit.split(arg);
		}
		
		static public function myParseFloat(s:String):Number {
			return Number(s) ;
		}
		
		static public function myReplace(msg:String, toFind:String, toBeReplacedWith:String):String {
			return msg.split(toFind).join(toBeReplacedWith) ;
		}
		
		static public function myGetQualifiedClassName(o:Object):String {
			return getQualifiedClassName(o);
		}
		
		static public function myGetTime():Number {
			var result:Number = getTimer();
			return result;
		}
		
		static public function getLocalTimeMs():Number {
			
			return localDate.time + FlashUtils.myGetTime();
		}
		
		static public function myIsFinite(n:Number):Boolean {
			return isFinite(n);
		}
		
		static public function myIsNan(n:Number):Boolean {
			return isNaN(n);
		}
		
		static public function myJSONStringify(obj:Object):String {
			return (com.adobe.serialization.json.JSON.encode(obj)); 
		}
		
		static public function myJSONParse(str:String):Object{
			return (com.adobe.serialization.json.JSON.decode(str)); 
		}
		
		static public function myReposTxt(txt:TextField, txtYStart:int):void {	
			txt.y = (txtYStart-3)+((txt.height - (txt.textHeight)) / 2);
		}
		
		
		
		static public function encodeList(list : Vector.<IEncode>) : Dictionary {
			 var result:Dictionary = new Dictionary();
			 for (var i : int = 0; i < list.length; i++) {
			 	result["item" + i] = list[i].encode();
			 }
			 return result;
		}
		
		static public function decodeList(objData:Dictionary, createFct:Function):Vector.<IEncode> {
			var output:Vector.<IEncode> = new Vector.<IEncode>();
			 var i:int = 0;
			 while(objData["item"+i]) {
				var model:IEncode = createFct(objData["item"+i]);
				output.push(model);
				i++;
			 }
			 
			 return output;
		}
		
	}
}
