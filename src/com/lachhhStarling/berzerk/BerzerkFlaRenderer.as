package com.lachhhStarling.berzerk {
	import com.berzerkstudio.ModelFla;
	import com.lachhhStarling.ModelFlaEnum;
	import com.lachhhStarling.ShaderQuadBatch;
	/**
	 * @author LachhhSSD
	 */
	public class BerzerkFlaRenderer {
		static public var NULL:BerzerkFlaRenderer = new BerzerkFlaRenderer(ModelFlaEnum.NULL);
		public var modelFla : ModelFla;
		public var quadBatchs:Vector.<ShaderQuadBatch> = new Vector.<ShaderQuadBatch>();
		private var index:int = 0;
		
		public function BerzerkFlaRenderer(pModelFla:ModelFla) {
			modelFla = pModelFla;
			quadBatchs = new Vector.<ShaderQuadBatch>();
			index = -1;
		}

		public function reset() : void {
			index = -1;
			for (var i : int = 0; i < quadBatchs.length; i++) {
				var qb:ShaderQuadBatch = quadBatchs[i];
				qb.reset();
			}
		}
		
		public function setNewBatch():ShaderQuadBatch {
			index++;
			if(index >= quadBatchs.length) {
				quadBatchs.push(new ShaderQuadBatch());
			}

			return quadBatchs[index];
		}
		
		public function getQuadBatch():ShaderQuadBatch {
			return quadBatchs[index];
		}
	}
}
