package com.lachhh.utils {
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.flash.display.TextField;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.geom.Color;
	import com.berzerkstudio.flash.geom.ColorTransform;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.lachhhengine.actor.Actor;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * @author Simon Lachance
	 */
	public class Utils {
		static private const BLACK_N_WHITE:ColorMatrixFilter = new ColorMatrixFilter([0.3086000084877014,0.6093999743461609,0.0820000022649765,0,0,0.3086000084877014,0.6093999743461609,0.0820000022649765,0,0,0.3086000084877014,0.6093999743461609,0.0820000022649765,0,0,0,0,0,1,0]);
		static private var _theFilter:ColorMatrixFilter = ColorMatrixFilter(BLACK_N_WHITE.clone());
		static private var _theFilterArray:Array = [_theFilter];
		static public var TEMP_ARRAY:Array = new Array();
		
		static public function DeepCloneDictionary(original:Dictionary):Dictionary{
			var result:Dictionary = new Dictionary();
			
			for(var key:Object in original){
				if(original[key] is Dictionary){
					result[key] = DeepCloneDictionary(original[key]);
				} else {
					result[key] = original[key];
				}
			}
			
			return result;
		}
		
		static public function isInteger(value:Number):Boolean{
			return (value == Math.round(value));
		}
		
		static public function randomFlipCoin():Boolean{
			return (Math.random() > 0.5);
		}
		
		static public function PutBlackAndWhite(d:flash.display.DisplayObject, blackNWhite:Boolean = true):void {
			if(blackNWhite) {
				d.filters = _theFilterArray;
			} else {
				d.filters = [];
			}
		}

		static public function GetIndexOfElem(array:Array, elem:Object):int {
			for (var i:int = 0 ; i < array.length ; i++) {
				if(array[i] == elem) {
					return i;
				}
			}	
			return -1;
		}
		
		static public function IsInArray(array:Array, elem:Object):Boolean {
			for (var i:int = 0 ; i < array.length ; i++) {
				if(array[i] == elem) {
					return true;
				}
			}	
			return false;
		}
		
		static public function AddInArrayIfNotIn(array:Array, elem:Object):void {
			for (var i:int = 0 ; i < array.length ; i++) {
				if(array[i] == elem) {
					return ;
				}
			}	
			array.push(elem);
		}
		
		private static var tempArray:Array = new Array();
		static public function AreArraysEqual(list1:Array, list2:Array):Boolean{
			if(list1.length != list2.length) return false;
			
			ClearArray(tempArray);
			
			for each(var obj1:* in list1){
				tempArray.push(obj1);
			}
			
			for each(var obj2:* in list2){
				if(tempArray.indexOf(obj2) == -1) return false;
				RemoveFromArray(tempArray, obj2);
			}
			
			return true;
		}
		
		static public function CreateBmpFromMc(anim:flash.display.MovieClip):Bitmap {
			var origin:Point = GetOriginOfMc(anim);
			var bd:BitmapData = new BitmapData(anim.width, anim.height, true,0);
			var m:Matrix = new Matrix();
			var bmp:Bitmap ;
			m.translate(origin.x, origin.y);
			bd.draw(anim, m);
			bmp = new Bitmap(bd);
			bmp.x = -origin.x;
			bmp.y = -origin.y;
			return bmp;
		}

		static public function RemoveFromArray(array:Array, elem:Object):Boolean {
			for (var i:int = 0 ; i < array.length ; i++) {
				if(array[i] == elem) {
					array.splice(i,1);
					return true;
				}
			}	
			return false;
		}
		
		static public function RemoveNull(array:Array):void {
			for (var i:int = 0 ; i < array.length ; i++) {
				if(array[i] == null) {
					array.splice(i,1);
					i--;
				}
			}	
		}
		
		static public function ClearArray(array:Array):void {
			if(array == null) return;
			while(array.length > 0) array.pop();
		}
		
		static public function CopyArray(src:Array, dst:Array):void{
			for each(var obj:Object in src){
				dst.push(obj);
			}
		}
		
		static public function SetColorAnimViewUint(d:com.berzerkstudio.flash.display.DisplayObject, color:uint, prct:Number):void{
			var r:uint = Color.extractRed(color);
			var b:uint = Color.extractBlue(color);;
			var g:uint = Color.extractGreen(color);;
			SetColorAnimViewPrct(d, r, g, b, prct);
		}
		
		static public function SetColorAnimView(d:com.berzerkstudio.flash.display.DisplayObject, r:Number = 0, g:Number = 0, b:Number= 0, a:Number= 0, rm:Number= 1, gm:Number= 1, bm:Number= 1, am:Number = 1):void {
			d.setColorAnimViewAdvanced(r, g, b, a, rm, gm, bm, am);
		}
		
		static public function SetColorAnimViewPrct(d:com.berzerkstudio.flash.display.DisplayObject, r:Number, g:Number, b:Number, prct:Number ):void {
			d.setColorAnimViewPrct(r, g, b, prct);
		}
		
		static public function SetColor2AnimView(d:com.berzerkstudio.flash.display.DisplayObject, color:uint):void {
			d.setColorAnimView(color);
		}
		
		static public function SetColorBzk(d:com.berzerkstudio.flash.display.DisplayObject, r:Number, g:Number, b:Number, a:Number):void {
			var ct:com.berzerkstudio.flash.geom.ColorTransform = d.transform.colorTransform ;
			ct.color.SetTint(r, g, b, a);
			d.transform.colorTransform = ct;
		}
				
		static public function SetColor(d:flash.display.DisplayObject, r:Number = 0, g:Number = 0, b:Number= 0, a:Number= 0, rm:Number= 1, gm:Number= 1, bm:Number= 1, am:Number = 1):void {
			var ct:flash.geom.ColorTransform = d.transform.colorTransform ;
			ct.redOffset = r;
			ct.greenOffset = g;
			ct.blueOffset = b;
			ct.alphaOffset = a;
			ct.redMultiplier = rm;
			ct.greenMultiplier = gm;
			ct.blueMultiplier = bm;
			ct.alphaMultiplier = am;
			d.transform.colorTransform = ct;
		}
		
		static public function SetColor2(d:flash.display.DisplayObject, color:uint):void {
			var ct:flash.geom.ColorTransform = d.transform.colorTransform ;
			ct.color = color;
			ct.alphaOffset = 0;
			ct.redMultiplier = 0;
			ct.greenMultiplier = 0;
			ct.blueMultiplier = 0;
			ct.alphaMultiplier = 1;
			d.transform.colorTransform = ct;
			//154,136,110,0,0,0,0,1
		}
		
		static public function SetColorUnityBlackAnimView(d:com.berzerkstudio.flash.display.DisplayObject, force:Number):void {
			SetColorAnimView(d, -255*force, -255*force, -255*force);
		}
		
		/*static public function SetColorUnityBlack(d:flash.display.DisplayObject, force:Number):void {
			SetColor(d, -255*force, -255*force, -255*force);
		}
		
		static public function SetColorUnityWhite(d:flash.display.DisplayObject,force:Number):void {
			SetColor(d, 255*force, 255*force, 255*force);
		}
		
		static public function SetColorUnityRedDeath(d:flash.display.DisplayObject, force:Number):void {
			SetColor(d, 153*force,0,0,0,(1-force),(1-force),(1-force),1);		
		}*/
		
		static public function GetOriginOfMc(mc:flash.display.DisplayObject):Point {
			
			var rect:Rectangle = mc.getBounds(mc);
			var origin:Point = new Point();
						
			origin.x = (mc.x - rect.x) ;
			origin.y = (mc.y - rect.y) ;
			return origin;
		}
		
		static public function PutZero(n:int, digits:int = 2):String {
			var s:String = String(n);
			var temp:Number ;
			if(n <= 0) {
				temp = 1 / Math.pow(10, digits-1);
			} else {
				temp = n / Math.pow(10, digits-1);
			}
			
			while(temp<1) {
				temp*=10;
				s = "0" + s;
			}
			return s;
		}
		
		static public function FrameToTimeAdvanced(frame:int, fps:int, minuteLabel:String = null, secondLabel:String = null, msLabel:String = null):String {
			var min:int = Math.floor(frame / (fps * 60));
			frame-= (fps * 60)*min;
			var sec:int = Math.floor(frame / fps);
			frame-= fps*sec;
			var ms:int = Math.floor((frame / fps)*100);
			var result:String = "";
			if(minuteLabel != null) result += PutZero(min) + " " + minuteLabel ;
			if(secondLabel != null) result += PutZero(sec) + " " + secondLabel ;
			if(msLabel != null) result += PutZero(ms) + " " + msLabel ; 
			return result;
		}
		
		static public function FrameToTime(frame:int, fps:int):String {
			var min:int = Math.floor(frame / (fps * 60));
			frame-= (fps * 60)*min;
			var sec:int = Math.floor(frame / fps);
			frame-= fps*sec;
			var ms:int = Math.floor((frame / fps)*100);
			
			return (PutZero(min) + ":" + PutZero(sec) );
		}
		
		static public function MsToTime(ms:int):String {
			if(ms <= 0) return "00:00";
			var hour:int = Math.floor(ms / (1000 * 60 *60));
			ms -= (1000 * 60*60)*hour;
			
			var min:int = Math.floor(ms / (1000 * 60));
			ms -= (1000 * 60)*min;
			var sec:int = Math.floor(ms / 1000);
			ms -= (1000*sec);
			if(ms > 0) sec++;
			if(sec >= 60) {min++; sec = 0;}
			if(min >= 60) {hour++; min = 0;}
			
			if(hour > 0) {
				return PutZero(hour) + ":" + PutZero(min) + ":" + PutZero(sec) ;
			} else {
				return (PutZero(min) + ":" + PutZero(sec) );
			}
		}
		
		static public function MsToTime2(ms:int):String {
			if(ms <= 0) return "0s";
			var days:int = Math.floor(ms / (1000 * 60 *60*24));
			ms -= (1000 * 60*60*24)*days;
			
			var hour:int = Math.floor(ms / (1000 * 60 *60));
			ms -= (1000 * 60*60)*hour;
			
			var min:int = Math.floor(ms / (1000 * 60));
			ms -= (1000 * 60)*min;
			var sec:int = Math.floor(ms / 1000);
			ms -= (1000*sec);
			if(ms > 0) sec++;
			if(sec >= 60) {min++; sec = 0;}
			if(min >= 60) {hour++; min = 0;}
			
			var result:String = "";
			if(days > 0) result = days + "d";
			if(hour > 0) result = (result != "" ? result + " " : "") + hour + "h";
			if(min > 0) result = (result != "" ? result + " " : "") + min + "m";
			if(sec > 0) result = (result != "" ? result + " " : "") + sec + "s";
			  
			return result;
		}
		
		static public function MsToTimeShort(ms:int):String {
			if(ms <= 0) return "0m";
			var days:int = Math.floor(ms / (1000 * 60 *60*24));
			ms -= (1000 * 60*60*24)*days;
			
			var hour:int = Math.floor(ms / (1000 * 60 *60));
			ms -= (1000 * 60*60)*hour;
			
			var min:int = Math.floor(ms / (1000 * 60));
			ms -= (1000 * 60)*min;
			var sec:int = Math.floor(ms / 1000);
			ms -= (1000*sec);
			if(ms > 0) sec++;
			if(sec >= 60) {min++; sec = 0;}
			if(min >= 60) {hour++; min = 0;}
			
			var result:String = "";
			if(days > 0) result = days + "d";
			if(hour > 0) result = (result != "" ? result + " " : "") + hour + "h";
			if(min > 0 && (result.length < 4)) result = (result != "" ? result + " " : "") + min + "m";
			if(sec > 0 && (result.length < 4)) result = (result != "" ? result + " " : "") + sec + "s";
			//2h 33m
			return result;
		}
		
		static public function MsToTimeHours(ms:int):String {
			if(ms <= 0) return "0m";
			
			var hour:int = Math.floor(ms / (1000 * 60 *60));
			ms -= (1000 * 60*60)*hour;
			
			var min:int = Math.floor(ms / (1000 * 60));
			ms -= (1000 * 60)*min;
			var sec:int = Math.floor(ms / 1000);
			ms -= (1000*sec);
			if(ms > 0) sec++;
			if(sec >= 60) {min++; sec = 0;}
			if(min >= 60) {hour++; min = 0;}
			
			var result:String = "";
			if(hour > 0) result = (result != "" ? result + " " : "") + hour + "h";
			if(min > 0 && (result.length < 4)) result = (result != "" ? result + " " : "") + min + "m";
			if(sec > 0 && (result.length < 4)) result = (result != "" ? result + " " : "") + sec + "s";
			//2h 33m
			return result;
		}
			
		static public function LazyRemoveFromParent(d:flash.display.DisplayObject):void {
			if(d == null) return ;
			if(d.parent != null) {d.parent.removeChild(d);}
		}
		
		static public function LazyRemoveFromParentAnimView(d:MovieClip):void {
			if(d == null) return ;
			if(d.parent != null) {d.parent.removeChild(d);}
		}
		
		static public function minMax(n:Number, min:Number, max:Number):Number {
			return (Math.max(Math.min(max, n), min));
		}
		
		static public function isBetweenOrEqual(n:Number, min:Number, max:Number):Boolean {
			return (n >= min && n <= max);
		}
		
		static public function RoundOn(n:Number, tolerance:Number):Number {
			var floor:Number = Math.ceil(n / tolerance)*tolerance;
			var ceil:Number = Math.floor(n / tolerance)*tolerance;
			var diff:Number = n-floor;
			var prct:Number = diff/(ceil-floor);
			
			return (prct <= 0.5 ? floor : ceil);
		}
		
		static public function IsInstanceOfClass(obj:Object, classes:Array):Boolean {
			for (var i:int = 0 ; i < classes.length ; i++) {
				if (obj is classes[i]) return true;
			}
			return false;
		}
		 
		static public function GetHomingAngle(angle:Number, x1:Number, y1:Number, x2:Number, y2:Number, precision:Number):Number {
			var realAngle:Number = GetRotation(x2, x1, y2, y1);
			var nDiff:Number = (realAngle - angle);
			while (nDiff >180) nDiff -= 360;
			while (nDiff <-180) nDiff += 360;
			while (angle >180) angle -= 360;
			while (angle <-180) angle += 360;
			angle += nDiff*precision ;

			return angle; 	
		}
		
		static public function GetRotation(x1:Number,x2:Number,y1:Number,y2:Number):Number {
			var dx:Number = x1-x2;
			var dy:Number = y1-y2;
			var rot:Number = Math.atan2(dy,dx);
			
			return (rot/Math.PI)*180;
		}
		
		static public function IsActorInRange(actor1:Actor, actor2:Actor, rayon:Number):Boolean {
			var dx:Number = actor2.px - actor1.px;
			var dy:Number = actor2.py - actor1.py;
			return (dx*dx+dy*dy)<rayon*rayon;
		}
				
		static public function PutVirgules(n:int):String {
			var result:String = n+"";
			var tempA:Array = new Array();
			for (var i:int = result.length-1 ; i >= 0 ; i-=3) {
				var index:int = Math.max(0,i-2);
				var len:int = (i - index)+1;
				if(len > 0) {
					tempA.unshift(result.substr(index,len));
				}
			}
			return tempA.join(",");
		}
				
		static public function CropIn(value:int, rangeStart:int, rangeEnd:int):int {
			var result:int = value;
			var diff : int = (rangeEnd - rangeStart)+1;
			if(diff <= 0) return -1;
			while(result < rangeStart) result += diff;
			while(result > rangeEnd) result -= diff;
			return result;
		}
		
		static public function RecurStop(mc:flash.display.MovieClip):void {
			for (var i:int = 0 ; i < mc.numChildren ; i++)	 {
				var d:flash.display.DisplayObject = mc.getChildAt(i);
				if(d is flash.display.MovieClip) {
					var m:flash.display.MovieClip = flash.display.MovieClip(d);
					RecurStop(m);
					m.gotoAndStop(1);
				}	
			}
		}
		
		static public function SetMaxSizeOfTxtField(tf:flash.text.TextField, maxSize:int):void {
			if(tf == null) return ;
			var textFormat : TextFormat = tf.getTextFormat();
			var size:int = Math.max(maxSize, 8) ;			
			textFormat.size = size;			
			tf.setTextFormat(textFormat);
	
			while((tf.maxScrollV > 1 || tf.maxScrollH > 1) && size > 8) {
				size--;
				textFormat.size = size;	
				tf.setTextFormat(textFormat);
			}
		}
		
		static public function SetMaxSizeOfTxtFieldAnim(tf:com.berzerkstudio.flash.display.TextField, maxSize:int):void {
			if(tf == null) return ;
			
		}
		
		static public function navigateToURLAndRecord(url:String, window:String = null):void {
			navigateToURL(new URLRequest(url), window);
			ExternalAPIManager.trackerAPI.trackEvent("Link", url);
		}
		
		static public function lerp(start:Number, end:Number, prct:Number):Number {
			var diff:Number = end - start;
			return Math.min(end, Math.max(start, start + prct*diff));
		}
		
		static public function pickRandomInInt(array:Array):int {
			return array[Math.floor(Math.random()*array.length)];
		}
		
		static public function pickRandomInArray(array:Array):Object {
			return array[Math.floor(Math.random()*array.length)];
		}
		
		static public function getSquaredDistance(x1:Number,y1:Number,x2:Number,y2:Number):Number {
			var dx:Number = x1-x2;
			var dy:Number = y1-y2;
			return (dx*dx)+(dy*dy);
		}
		
		static public function myIsInstanceOfClass(obj:Object, theClass:Class):Boolean {
			return (obj as theClass);
		}
		
		static public function myIsInstanceOfClassDisplayObject(d:flash.display.DisplayObject, theClass:Class):Boolean {
			return (d as theClass);
		}
		
		static public function myIsInstanceOfClassDisplayObjectList(d:flash.display.DisplayObject, classList:Array):Boolean {
			for (var i : int = 0; i < classList.length; i++) {
				var theClass:Class = classList[i];
				if(myIsInstanceOfClassDisplayObject(d, theClass)) return true;
			}
			return false;
		}
		
		static public function prctToText(n:Number):String {
			return Math.floor(n*100)+"";
		}
		
		static public function pickNumberBetween(min:Number, max:Number):Number {
			var delta:Number = max-min;
			return min+Math.random()*delta;
		}
		
		static public function pickIntBetween(min:Number, max:Number):int {
			var delta:int = max-min;
			return min+Math.random()*(delta+1);
		}
		
		static public function randomizeArray(a:Array):void {
			a.sort(randomizeArrayOrder);
		}
		
		static private function randomizeArrayOrder(a:Object, b:Object):int {
			return (Math.random() < 0.5 ? -1 : 1);
		}
		
		
		static public function pickRandomFrame(m:flash.display.MovieClip):int {
			return (Math.floor(Math.random()*(m.totalFrames-1))+1);			
		}
		
		static public function pickRandomFrameAnimView(m:MovieClip):int {
			return (Math.floor(Math.random()*(m.totalFrames-1))+1);			
		}
		
		static public function to2DigitAfterCommaIfNecessary(n:Number):String {
			var str:String = n.toFixed(2);
			if(str.indexOf(".00") != -1) return n+"";
			if(str.charAt(str.length-1) == '0') return str.substr(0, str.length-1);
			return str;
		}
		
		static public function clamp(i:Number, min:Number, max:Number):Number{
			if(i < min) return min;
			if(i > max) return max;
			return i;
		}
		
		static public function recurStop(mc:MovieClip):void {
			for (var i:int = 0 ; i < mc.numChildren ; i++)	 {
				var m:MovieClip = mc.getChildAt(i) as MovieClip;
				if(m) {
					recurStop(m);
					m.stop();
				}	
			}
		}
		
		static public function recurGotoStop1(mc:MovieClip):void {
			for (var i:int = 0 ; i < mc.numChildren ; i++)	 {
				var m:MovieClip = mc.getChildAt(i) as MovieClip;
				if(m) {
					recurGotoStop1(m);
					m.gotoAndStop(1);
				}	
			}
		}

		static public function recurGotoPlay1(mc:MovieClip):void {
			for (var i:int = 0 ; i < mc.numChildren ; i++)	 {
				var m:MovieClip = mc.getChildAt(i) as MovieClip;
				if(m) {
					recurGotoPlay1(m);
					m.gotoAndPlay(1);
				}	
			}
		}
		
		static public function randomizeChildrenFirstFrame(mc:MovieClip) : void {
			for (var i : int = 0; i < mc.numChildren; i++) {
				var d:MovieClip =  mc.getChildAt(i) as MovieClip;
				if(!d) continue;
				d.gotoAndPlay(Math.floor(Math.random()*d.totalFrames));
			}
		}
	}
}
