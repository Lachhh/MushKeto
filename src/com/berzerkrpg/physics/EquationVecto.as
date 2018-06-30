package com.berzerkrpg.physics {
	import com.lachhh.flash.FlashUtils;

	import flash.geom.Point;
	/**
	 * @author LachhhSSD
	 */
	public class EquationVecto {
		
		
		static public function GetCollisionPointWithLine(crntLine:Line, ball:CircleWithV):Point {
			// Best line to check
			var line:Line = null;
			// dist of first col (to check which line is nearer)
			var distFirstCol:Number = 0;
			// Vector of last collision and center of the line 
			var vCx:Number = 0;
			var vCy:Number = 0;
			// Equation of the current line in Ax+By+C=0 format
			var lA:Number = 0;
			var lB:Number = 0;
			var lC:Number = 0;
			// Point of the current first collision
			var lCx:Number = 0;
			var lCy:Number = 0;
			// Position want to go
			var nvx:Number = ball.x+ball.vx;
			var nvy:Number = ball.y+ball.vy;
			
			// Equation of the ball
			var Oox:Number = nvx;
			var Ooy:Number = nvy;
			var Ovx:Number = ball.vx;
			var Ovy:Number = ball.vy;
			//Equation de la trajectoire de la balle (Ax+By+C=0 format)
			var Ab:Number = Ovy;
			var Bb:Number = -Ovx;
			var Cb:Number = Ovx*Ooy-Ovy*Oox;
			// rayon of the ball
			var rayon:Number = ball.radius;
			var sens:Number = 0;
			// distance entre la balle "arrivée" et la ligne
			var dist:Number = 0;
			var sensBallInit:Number = 0;
			
			//trace("Start")
			//Boucle qui regarde avec quelle ligne la balle doit collisionner (la plus proche)
			
			
							
				// equation of the line in Ax+By+C=0 format
				lA = crntLine.A();
				lB = crntLine.B();
				lC = crntLine.C()-rayon;
				if ((Ab*lB-lA*Bb) == 0 && (lA*Bb-Ab*lB) == 0) {
					return null;
				}
				// intersection entre trajectoire ball et ligne collision   
				if (lA != 0) {
					lCy = (lA*Cb-Ab*lC)/(Ab*lB-lA*Bb);
					lCx = (-lB*lCy-lC)/lA;
				} else {
					lCx = (lB*Cb-lC*Bb)/(lA*Bb-Ab*lB);
					lCy = (-lA*lCx-lC)/lB;
				}
				if (FlashUtils.myIsNan(lCx) || !FlashUtils.myIsFinite(lCx)) {
					/*Debug.Log("ERROR:EQUATIONVECTO_c::GetNearestCollisionWithLine");
					Debug.Log("lA : "+lA);
					Debug.Log("lB : "+lB);
					Debug.Log("lC : "+lC);
					Debug.Log("Ab : "+Ab);
					Debug.Log("Bb : "+Bb);
					Debug.Log("Cb : "+Cb);
					Debug.Log("(Ab*lB - lA*Bb) : "+(lA*Bb-Ab*lB));*/
					return null;
				}
				// Distance entre la ball de départ et la première collision   
				var vectFirstColx:Number = (lCx-ball.x);
				var vectFirstColy:Number = (lCy-ball.y);
				distFirstCol = (vectFirstColx*vectFirstColx+vectFirstColy*vectFirstColy);
				//Vecteur entre la première collision et le centre de la ligne
				vCx = crntLine.GetCenterPoint().x-lCx;
				vCy = crntLine.GetCenterPoint().y-lCy;
				// distance entre la balle d'arrivée et la ligne
				sens = (lA*Oox+lB*Ooy+lC);
				dist = ((sens*sens)/(lA*lA+lB*lB));
				// distance entre la balle de départ et la ligne
				sensBallInit = (lA*ball.x+lB*ball.y+lC);
				//Si la balle n'est pas à l'extérieur de la limite 		
				//TODO : Regarder ici
				if (vCx*vCx+vCy*vCy>=Math.pow(crntLine.GetRayon()+rayon, 2)) {
					return null ;
				} else {
					// COLLISION AVEC LIGNE
					// Si la balle est du bon sens de la collision => sensBallInit >=0
					//Nb, la ligne détecte les collision d'un seul sens ce qui allège le code et offre plus de possibilité
					if (sensBallInit>=0) {
						// Si la balle a traverser la ligne 
						if (sens<0 || dist<0) {
							// Si la distance est la plus petite rencontrée jusqu'à maintenant
							return new Point(lCx, lCy);
						}
					}
				}
			
			return null;
		};
		
		
		static public function GetObjCollision(line:Line, pFirstCol:Point, ball:CircleWithV):Collision2DFlash {
			if (line == null) {
				return null;
			}
			var colObj:Collision2DFlash = new Collision2DFlash();
			// Position want to go  
			var nvx:Number = ball.x+ball.vx;
			var nvy:Number = ball.y+ball.vy;
			// Equation of the ball
			var Oox:Number = nvx;
			var Ooy:Number = nvy;
			var Ovx:Number = ball.vx;
			var Ovy:Number = ball.vy;
			//Equation de la trajectoire de la balle (Ax+By+C=0 format)
			var Ab:Number = Ovy;
			var Bb:Number = -Ovx;
			var Cb:Number = Ovx*Ooy-Ovy*Oox;
			// sens par rapport à la ligne (si négatif, la balle est dans l'autre sens de la ligne)
			colObj.sens = 0;
			//Point Np (Voir figure)
			var Np:Point = null;
			//Return object
			var pFinalX:Number = 0;
			var pFinalY:Number = 0;
	
			//Si collision avec Ligne
			var cx:Number = pFirstCol.x;
			var cy:Number = pFirstCol.y;
			var p1:Point = new Point(line.x1,line.y1);
			var p2:Point = new Point(line.x2,line.y2);
	
			//V1 = Début à first collision
			//V2 = first collision à Fin
			//distV1 + distV2 = distTotale (début à fin)
			colObj.distV1 = Math.sqrt((ball.x-cx)*(ball.x-cx)+(ball.y-cy)*(ball.y-cy));
			colObj.distV2 = Math.sqrt((nvx-cx)*(nvx-cx)+(nvy-cy)*(nvy-cy));
			//Variation minime pour régler la perte de précision et éviter qu'une balle passe au travers des murs
			//La variation se faite dans le sens de la normale du mur
			var vecVarMinime:Point = new Point((p2.y-p1.y), (p1.x-p2.x));
			vecVarMinime = MultiplyVec(NormalizeVec(vecVarMinime), 1/2000);
			Np = GetNpPoint(line, ball);
			// Follow
			colObj.vecFollow = new Point((Np.x-cx), (Np.y-cy));
			//On ajoute la différence causée par la variation minime
			colObj.vecFollow = MultiplyVec(NormalizeVec(colObj.vecFollow), ((GetNorm(colObj.vecFollow)+GetNorm(vecVarMinime))));
			// Avec perte d'énergie (Wall Sliding)
			colObj.vecFollowSansPerte = MultiplyVec(NormalizeVec(colObj.vecFollow), colObj.distV2);
			// Sans perte d'énergie
			//REbound
			//colObj.vecRebound = new Point((Np.x-nvx), (Np.y-nvy));
			//colObj.vecRebound = MultiplyVec(colObj.vecRebound, (ball.nBounce*nPrctBounce));
			//colObj.vecFinal = new Point(0, 0);
			colObj.vecFinal = colObj.vecFollow;//.add(colObj.vecRebound);
	
			//Point final (avec la variation minime)
			//colObj.vecFinal = colObj.vecFinal.add(colObj.vecAng);
			
			colObj.pFinal = new Point(0,0);
			colObj.pFinal.x = cx+colObj.vecFinal.x+vecVarMinime.x ;//ATTENTION ICI
			colObj.pFinal.y = cy+colObj.vecFinal.y+vecVarMinime.y ;
			
	
			//Pour calculer le vecteur causée par la vitesse angulaire
			colObj.sens = Ab*pFinalX+Bb*pFinalY+Cb;
			colObj.vecAng = colObj.vecFollow.clone();
			
			//trace("energieAngulaire : " + energieAngulaire)
			//colObj.pFinal.x += colObj.vecAng.x;
			//colObj.pFinal.y += colObj.vecAng.y;
			//colObj.vecFinal = colObj.vecFinal.add(colObj.vecAng);
			colObj.line = line;
			colObj.pFirstCollision = new Point(cx+vecVarMinime.x, cy+vecVarMinime.y);
			//trace("colObj.pFinal : " + colObj.pFinal)
			//trace("colObj.vecRebound : " + colObj.vecFinal)
			//trace("vecFinal : " + vecFinal)
			//objReturn = {distV1:distV1, distV2:distV2, pFirstCollision:new flash.geom.Point(cx+vecVarMinime.x, cy+vecVarMinime.y), pFinal:new flash.geom.Point(pFinalX, pFinalY), vecFinal:vecFinal, vecRebound:vecCompY, vecAng:vecAng, vecFollow:vecCompX, vecFollowSansPerte:vecCompXSansPerte, line:line, sens:sens};
			//trace("colObj : " + colObj);
			return colObj;
		};
		
		static public function GetNorm(p:Point):Number {
			return Math.sqrt(p.x*p.x+p.y*p.y);
		};
		
		static public function GetNpPoint(line:Line, ball:CircleWithV):Point {
			var A:Number = line.A();
			var B:Number = line.B();
			var C:Number = line.C()-(ball.radius);
			var nvx:Number = ball.x+ball.vx;
			var nvy:Number = ball.y+ball.vy;
			var Npx:Number = 0;
			var Npy:Number = 0;
			//Equation de la normale de la ligne avec comme point d'origine la position de la balle d'arrivée
			var Ac:Number = B;
			var Bc:Number = -A;
			var Cc:Number = A*nvy-B*nvx;
			//Trouver le point d'intersection entre la normale au point d'origine Pc et l'équation de la ligne
			if (A != 0) {
				Npy = (A*Cc-Ac*C)/(Ac*B-A*Bc);
				Npx = (-B*Npy-C)/A;
			} else {
				Npx = (B*Cc-C*Bc)/(A*Bc-Ac*B);
				Npy = (-A*Npx-C)/B;
			}
			return new Point(Npx, Npy);
		};
		
		static public function MultiplyVec(p:Point, mul:Number):Point {
			return new Point(p.x*mul, p.y*mul);
		};
		
		static public function NormalizeVec(p:Point):Point {
			var dist:Number = Math.sqrt(p.x*p.x+p.y*p.y);
			if (dist<0.0000000000001) {
				return new Point(0, 0);
			}
			var X:Number = p.x/dist;
			var Y:Number = p.y/dist;
			//trace("dist : " + dist + "/" + p.x + ":" + p.y)
			return new Point(X, Y);
		};
	}
}
