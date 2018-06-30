package com.berzerkrpg.physics {
	import com.lachhh.lachhhengine.MyMath;
	import com.lachhh.utils.Utils;

	import flash.geom.Point;
	import flash.utils.Dictionary;
	/**
	 * @author LachhhSSD
	 */
	public class Line {
		static public var lineTemp:Line = new Line(0, 0, 0, 0);
		public var x1:Number;
		public var y1:Number;
		public var x2:Number;
		public var y2 : Number;
		private var pCentre : Point;
		private var nRayon : Number;
		private var nRayonCarre : Number;
		private var p1 : Point = new Point();
		private var p2 : Point = new Point();
		private var m_normVx : Number;
		private var m_normVy : Number;
		private var nAngle : *;
		private var nA : Number;
		private var nB : Number;
		private var nC : Number;
		private var vx : Number;
		private var vy : Number;
		
		public var canDrop:Boolean = false;
		public var isWater:Boolean = false;
		private var saveData : Dictionary = new Dictionary();
		
		public function Line(pX1:Number, pY1:Number, pX2:Number, pY2:Number) {
			x1 = pX1;
			y1 = pY1;
			x2 = pX2;
			y2 = pY2;
			calculate();
		}
		
		private function calculate():void {
			if((p1.x == x1) && (p1.y == y1) && (p2.x == x2) && (p2.y == y2)) return ;
			pCentre = new flash.geom.Point((x2-x1)/2+x1, (y2-y1)/2+y1);
			nRayon = Math.sqrt(Math.pow((x2-x1),2)+Math.pow((y2-y1),2))/2;
			nRayonCarre = nRayon*nRayon;
			var sinaTemp:Number = (nRayon != 0 ? (y2-y1)/(nRayon*2) : 0);
			var cosaTemp:Number = (nRayon != 0 ? (x2-x1)/(nRayon*2) : 0);
	
			// equation of the line
			var Lox:Number = pCentre.x;
			var Loy:Number = pCentre.y;
			var Lvx:Number = cosaTemp;
			var Lvy:Number = sinaTemp;
			
			p1.x = x1;
			p1.y = y1;
			p2.x = x2;
			p2.y = y2;
			
			
			m_normVx = sinaTemp;
			m_normVy = -cosaTemp;
			nAngle = MyMath.GetRotation(x2,x1,y2,y1) ;
			// equation of the line in Ax+By+C=0 format
			nA = Lvy;
			nB = -Lvx;
			nC = Lvx*Loy-Lvy*Lox;
			vx = cosaTemp;
			vy = sinaTemp;
			
		}
				
		public function encode():Dictionary {
			saveData["x1"] = x1;
			saveData["x2"] = x2;
			saveData["y1"] = y1;
			saveData["y2"] = y2;
			saveData["canDrop"] = canDrop;
			saveData["isWater"] = isWater;
			return saveData; 
		}
		
		public function decode(loadData:Dictionary):void {
			if(loadData == null) return ;
			x1 = loadData["x1"];
			x2 = loadData["x2"];
			y1 = loadData["y1"];
			y2 = loadData["y2"];
			canDrop = loadData["canDrop"];
			isWater = loadData["isWater"];
		}
		
		public function A():Number {calculate(); return nA;}
		public function B():Number {calculate(); return nB;}
		public function C():Number {calculate(); return nC;}
		public function GetCenterPoint():Point {calculate(); return pCentre;}
		public function GetRayon():Number {calculate(); return nRayon;}
		
		public function intersectWithCircle(c:Circle):Boolean {
			return intersect(x1, y1, x2, y2, c.x, c.y, c.radius);
		}
		
		static public function toLineTemp(x1:Number, y1:Number, x2:Number, y2:Number):Line {
			lineTemp.x1 = x1;
			lineTemp.y1 = y1;
			lineTemp.x2 = x2;
			lineTemp.y2 = y2;
			return lineTemp;
		}
		
		static public function intersect(x1:Number, y1:Number, x2:Number, y2:Number, x:Number,y:Number,radius:Number):Boolean {
			var fx:Number = x1 - x;
			var fy:Number = y1 - y;
			
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			
			var a:Number = (dx * dx) + (dy * dy); // d.dot(d)
		    var b:Number = 2 * ((dx * fx) + (dy * fy)); // 2*f.dot(d)
		    var c:Number = (fx * fx) + (fy * fy) - (radius * radius); // f.dot(f)-r*r
		    var delta:Number = b*b - (4*a*c);     
			
			if(delta < 0) return false;
			
			var e : Number = Math.sqrt (delta);
			var u1 : Number = ( - b + e ) / (2 * a );
			var u2 : Number = ( - b - e ) / (2 * a );
			if ((u1 < 0 || u1 > 1) && (u2 < 0 || u2 > 1)) {
				if ((u1 < 0 && u2 < 0) || (u1 > 1 && u2 > 1)) {
					return false;
				} else {
					return true;
				}
			} else {
				return true;
			}
		}
		
		public function isHorizontal():Boolean {return y1 == y2;}
		public function isVertical():Boolean {return x1 == x2;}
		
		public function isLeftWall():Boolean {return isVertical() && (y1 < y2);}
		public function isRightWall():Boolean {return isVertical() && (y1 > y2);}
		public function isAFloor():Boolean {return isHorizontal() && (x1 < x2);}
		public function isACeiling():Boolean {return isHorizontal() && (x1 > x2);}
		public function length():Number{
			return Math.sqrt(Utils.getSquaredDistance(x1, y1, x2, y2));
		}
		
		public function clone():Line {
			var l:Line = new Line(x1, y1, x2, y2);
			l.canDrop = canDrop;
			l.isWater = isWater; 
			return l;
		}
		
		
		
	}
}
