package com.berzerkrpg.io.playerio {
	import com.lachhh.lachhhengine.meta.ModelBase;

	/**
	 * @author Lachhh
	 */
	public class ModelExternalPremiumAPI extends ModelBase {
		private var _prefixId:String;
		private var _nameOfSystem:String;
		private var _frame : int;
		private var _isBloodstoneOnly:Boolean;

		public function ModelExternalPremiumAPI(pIndex:int, id : String, prefixId : String, nameOfSystem : String, frame : int) {
			super(pIndex, id);
			_prefixId = prefixId;
			_nameOfSystem = nameOfSystem;
			_frame = frame;
			_isBloodstoneOnly = false;
		}
		
		public function get isBloodstoneOnly():Boolean {
			return _isBloodstoneOnly;
		}
		
		public function get prefixId() : String {
			return _prefixId;
		}

		public function get nameOfSystem() : String {
			return _nameOfSystem;
		}

		public function get frame() : int {
			return _frame;
		}
		
		public function get isSteam():Boolean{
			return id == ModelExternalPremiumAPIEnum.STEAM.id;
		}
		
		public function get isBerzerk():Boolean{
			return id == ModelExternalPremiumAPIEnum.BERZERK.id;
		}
		
		public function get isGamersafe():Boolean{
			return id == ModelExternalPremiumAPIEnum.GAMERSAFE.id;
		}
		
		public function get isAllowedToConnectSavesToBerzerkpals():Boolean{
			return true;
		}
	}
}
