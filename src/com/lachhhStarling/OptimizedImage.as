package com.lachhhStarling
{
    import flash.utils.ByteArray;
    import starling.core.RenderSupport;
    import starling.textures.Texture;
    import starling.textures.TextureSmoothing;
    import starling.utils.VertexData;

    import com.berzerkstudio.flash.display.ShapeObject;

    import flash.display.Bitmap;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class OptimizedImage
    {
        public var mTexture:Texture;
        public var mSmoothing:String;
        
        private var mVertexDataCacheInvalid:Boolean;
		
		private var mVertexData:OptimizedVertexData;
		
		public var touchable:Boolean = true;
		public var blendMode:String = "normal";
		public var visible:Boolean = true;
		public var transformationMatrix:Matrix ;
		public var shapeObject:ShapeObject;
		
		public const premultipliedAlpha : Boolean = false;
		public const tinted : Boolean = false;
		
		public var mNumVertices : int = 0;
		public var mRawData : ByteArray ;
		
		public const alpha:Number = 1.0;

		/** Creates a quad with a texture mapped onto it. */
        public function OptimizedImage(texture:Texture)
        {
            if (texture)
            {
                var frame:Rectangle = texture.frame;
                var width:Number  = frame ? frame.width  : texture.width;
                var height:Number = frame ? frame.height : texture.height;
                
				//var pma:Boolean = texture.premultipliedAlpha;
				var pma:Boolean = false; // just no pma
                
                buildBaseQuadData(width, height, pma);
                
                resetTextureCoords();
                
                mTexture = texture;
                mSmoothing = TextureSmoothing.BILINEAR;
                mVertexDataCacheInvalid = true;
            }
            else
            {
                throw new ArgumentError("Texture cannot be null");
            }
        }
		
		private function resetTextureCoords():void{
			mVertexData.setTexCoords(0, 0.0, 0.0);
            mVertexData.setTexCoords(1, 1.0, 0.0);
            mVertexData.setTexCoords(2, 0.0, 1.0);
            mVertexData.setTexCoords(3, 1.0, 1.0);
		}
		
		private function buildBaseQuadData(width:Number, height:Number, preMultAlpha:Boolean = false):void{
			if (width == 0.0 || height == 0.0)
            	throw new ArgumentError("Invalid size: width and height must not be zero");
            
            mVertexData = new OptimizedVertexData(4, preMultAlpha);
            mVertexData.setPosition(0, 0.0, 0.0);
            mVertexData.setPosition(1, width, 0.0);
            mVertexData.setPosition(2, 0.0, height);
            mVertexData.setPosition(3, width, height);

            onVertexDataChanged();
		}
        
        /** Creates an Image with a texture that is created from a bitmap object. */
        public static function fromBitmap(bitmap:Bitmap, generateMipMaps:Boolean=true, 
                                          scale:Number=1):OptimizedImage
        {
            return new OptimizedImage(Texture.fromBitmap(bitmap, generateMipMaps, false, scale));
        }
        
        /** @inheritDoc */
        protected function onVertexDataChanged():void
        {
            mVertexDataCacheInvalid = true;
        }
        
        /** Readjusts the dimensions of the image according to its current texture. Call this method 
         *  to synchronize image and texture size after assigning a texture with a different size.*/
        public function readjustSize():void
        {
            var frame:Rectangle = texture.frame;
            var width:Number  = frame ? frame.width  : texture.width;
            var height:Number = frame ? frame.height : texture.height;
            
            mVertexData.setPosition(0, 0.0, 0.0);
            mVertexData.setPosition(1, width, 0.0);
            mVertexData.setPosition(2, 0.0, height);
            mVertexData.setPosition(3, width, height);
            
            onVertexDataChanged();
        }
		
		private static var helperPoint:Point = new Point(0,0);
		private static var helperVector:Vector.<Number> = new Vector.<Number>();
		public function syncTexture():void{
			var p:Point = helperPoint;
			p.setTo(0,0);
			var vec:Vector.<Number> = helperVector;
			vec.length = 0;
			
			vec.push(0, 0);
			vec.push(1, 0);
			vec.push(0, 1);
			vec.push(1, 1);
			mTexture.adjustTexCoords(vec, 0, 0, 4);
			var i:int = 0;
			
			mVertexData.setTexCoords(0, vec[i++], vec[i++]);
			mVertexData.setTexCoords(1, vec[i++], vec[i++]);
			mVertexData.setTexCoords(2, vec[i++], vec[i++]);
			mVertexData.setTexCoords(3, vec[i++], vec[i++]);
			
			var mFrame:Rectangle = mTexture.frame;
			
			if (mFrame)
            {
                var deltaRight:Number  = mFrame.width  + mFrame.x - mTexture.width;
                var deltaBottom:Number = mFrame.height + mFrame.y - mTexture.height;
                
                mVertexData.translateVertex(0,     -mFrame.x, -mFrame.y);
                mVertexData.translateVertex(1, -deltaRight, -mFrame.y);
                mVertexData.translateVertex(2, -mFrame.x, -deltaBottom);
                mVertexData.translateVertex(3, -deltaRight, -deltaBottom);
            }
		}
        
        /** Sets the texture coordinates of a vertex. Coordinates are in the range [0, 1]. */
        public function setTexCoords(vertexID:int, coords:Point):void
        {
            mVertexData.setTexCoords(vertexID, coords.x, coords.y);
            onVertexDataChanged();
        }
        
        /** Sets the texture coordinates of a vertex. Coordinates are in the range [0, 1]. */
        public function setTexCoordsTo(vertexID:int, u:Number, v:Number):void
        {
            mVertexData.setTexCoords(vertexID, u, v);
            onVertexDataChanged();
        }
        
        /** Gets the texture coordinates of a vertex. Coordinates are in the range [0, 1]. 
         *  If you pass a 'resultPoint', the result will be stored in this point instead of 
         *  creating a new object.*/
        public function getTexCoords(vertexID:int, resultPoint:Point=null):Point
        {
            if (resultPoint == null) resultPoint = new Point();
            mVertexData.getTexCoords(vertexID, resultPoint);
            return resultPoint;
        }
        
        /** Copies the raw vertex data to a VertexData instance.
         *  The texture coordinates are already in the format required for rendering. */ 
        public function copyVertexDataTo(targetData:OptimizedVertexData, targetVertexID:int=0):void
        {
            copyVertexDataTransformedTo(targetData, targetVertexID, null);
        }
        
        /** Transforms the vertex positions of the raw vertex data by a certain matrix
         *  and copies the result to another VertexData instance.
         *  The texture coordinates are already in the format required for rendering. */
        public function copyVertexDataTransformedTo(targetData:OptimizedVertexData,
                                                             targetVertexID:int=0,
                                                             matrix:Matrix=null):void
        {
            if (mVertexDataCacheInvalid)
            {
                mVertexDataCacheInvalid = false;
                resetTextureCoords();
				//mTexture.adjustVertexData(mVertexData, 0, 4);
				syncTexture();
				
				mRawData = mVertexData.rawData;
				mNumVertices = mVertexData.numVertices;
            }
			
            optimizedCopyRawDataTo(targetData, targetVertexID, matrix, 0, 4);
        }
		
		private function optimizedCopyRawDataTo(targetData:OptimizedVertexData, targetVertexID:int=0,
                                          matrix:Matrix=null,
                                          vertexID:int=0, numVertices:int=-1):void
		{
			//var sourceData:VertexData = shapeObject.vertexData;
			//var sourceData:VertexData = mVertexData;
			
			if (numVertices < 0 || vertexID + numVertices > mNumVertices)
                numVertices = mNumVertices - vertexID;
            
            var x:Number, y:Number;
            var targetRawData:ByteArray = targetData.rawData;
            var targetIndex:int = targetVertexID * OptimizedVertexData.BYTES_PER_VERTEX;
            var sourceIndex:int = vertexID * OptimizedVertexData.BYTES_PER_VERTEX;
            var sourceEnd:int = (vertexID + numVertices) * OptimizedVertexData.BYTES_PER_VERTEX;
			
			//var mRawData:Vector.<Number> = sourceData.rawData;
			
			mRawData.position = sourceIndex;
			targetRawData.position = targetIndex;
			
			var colorOffsetSkip:int = 4 * OptimizedVertexData.ELEMENTS_SIZE;
            
            if (matrix)
            {
				
                while (sourceIndex < sourceEnd)
                {
                    x = mRawData.readFloat();
                    y = mRawData.readFloat();
                    targetRawData.writeFloat(matrix.a * x + matrix.c * y + matrix.tx);
                    targetRawData.writeFloat(matrix.d * y + matrix.b * x + matrix.ty);
					
					
					// all this color data! WE DONT NEED IT!
                    //targetRawData[int(targetIndex++)] = mRawData[int(sourceIndex++)];
                    //targetRawData[int(targetIndex++)] = mRawData[int(sourceIndex++)];
                    //targetRawData[int(targetIndex++)] = mRawData[int(sourceIndex++)];
                    //targetRawData[int(targetIndex++)] = mRawData[int(sourceIndex++)];
                    
					mRawData.position += colorOffsetSkip;
					targetRawData.position += colorOffsetSkip;
                    
                    targetRawData.writeFloat(mRawData.readFloat());
                    targetRawData.writeFloat(mRawData.readFloat());
					
					sourceIndex = mRawData.position;
                }
            }
            else
            {
				
                while (sourceIndex < sourceEnd) {
                    targetRawData.writeFloat(mRawData.readFloat());
					targetRawData.writeFloat(mRawData.readFloat());
					
					// ignore our color data!
					mRawData.position += colorOffsetSkip;
					targetRawData.position += colorOffsetSkip;
					
					targetRawData.writeFloat(mRawData.readFloat());
					targetRawData.writeFloat(mRawData.readFloat());
					
					sourceIndex = mRawData.position;
				}
            }
		}
        
        /** The texture that is displayed on the quad. */
        public function get texture():Texture { return mTexture; }
        public function set texture(value:Texture):void 
        { 
            if (value == null)
            {
                throw new ArgumentError("Texture cannot be null");
            }
            else if (value != mTexture)
            {
                mTexture = value;
                //mVertexData.setPremultipliedAlpha(mTexture.premultipliedAlpha, false);
				mVertexData.setPremultipliedAlpha(false, false);
                onVertexDataChanged();
            }
        }
        
        /** The smoothing filter that is used for the texture. 
        *   @default bilinear
        *   @see starling.textures.TextureSmoothing */ 
        public function get smoothing():String { return mSmoothing; }
        public function set smoothing(value:String):void 
        {
            if (TextureSmoothing.isValid(value))
                mSmoothing = value;
            else
                throw new ArgumentError("Invalid smoothing mode: " + value);
        }
    }
}