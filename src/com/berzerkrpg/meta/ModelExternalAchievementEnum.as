package com.berzerkrpg.meta {

	/**
	 * @author LachhhSSD
	 */
	public class ModelExternalAchievementEnum {
		static public var ALL:Array = new Array();
				
		static public var NULL:ModelExternalAchievement = new ModelExternalAchievement("");
				
		static public var ACH_1_GET_SELFONE:ModelExternalAchievement = create("ACH_1");
		static public var ACH_2_GET_BOAT:ModelExternalAchievement = create("ACH_2");
		static public var ACH_3_GET_3D_PRINTER:ModelExternalAchievement = create("ACH_3");
		static public var ACH_4_GET_VACUUM:ModelExternalAchievement = create("ACH_4");
		static public var ACH_5_25_CODE_HOTMAIL:ModelExternalAchievement = create("ACH_5");
		static public var ACH_6_UNLOCK_MONSTER_2:ModelExternalAchievement = create("ACH_6");
		static public var ACH_7_UNLOCK_MONSTER_3:ModelExternalAchievement = create("ACH_7");
		static public var ACH_8_UNLOCK_MONSTER_4:ModelExternalAchievement = create("ACH_8");
		static public var ACH_9_UNLOCK_MONSTER_5:ModelExternalAchievement = create("ACH_9");
		static public var ACH_10_UNLOCK_MONSTER_6:ModelExternalAchievement = create("ACH_10");
		static public var ACH_11_UNLOCK_MONSTER_7:ModelExternalAchievement = create("ACH_11");
		static public var ACH_12_UNLOCK_MONSTER_8:ModelExternalAchievement = create("ACH_12");
		static public var ACH_13_UNLOCK_MONSTER_9:ModelExternalAchievement = create("ACH_13");
		static public var ACH_14_UNLOCK_MONSTER_10:ModelExternalAchievement = create("ACH_14");
		static public var ACH_15_UNLOCK_MONSTER_11:ModelExternalAchievement = create("ACH_15");
		static public var ACH_16_LACHHH_EASTER_EGG:ModelExternalAchievement = create("ACH_16");
		static public var ACH_17_HELL_BANK_LVL_1:ModelExternalAchievement = create("ACH_17");
		static public var ACH_18_HELL_ARMORY_LVL_1:ModelExternalAchievement = create("ACH_18");
		static public var ACH_19_HELL_SHOWER_LVL_1:ModelExternalAchievement = create("ACH_19");
		static public var ACH_20_BEAT_WIZARD_1:ModelExternalAchievement = create("ACH_20");
		static public var ACH_21_BEAT_WIZARD_2:ModelExternalAchievement = create("ACH_21");
		static public var ACH_22_BEAT_WIZARD_3:ModelExternalAchievement = create("ACH_22");
		static public var ACH_23_BEAT_WIZARD_4:ModelExternalAchievement = create("ACH_23");
		static public var ACH_24_BEAT_WIZARD_5:ModelExternalAchievement = create("ACH_24");
		static public var ACH_25_USE_PORTAL:ModelExternalAchievement = create("ACH_25");
		static public var ACH_26_CRAFT_ONE_ITEM:ModelExternalAchievement = create("ACH_26");
		static public var ACH_27_CARL_HIGHER_LICH:ModelExternalAchievement = create("ACH_27");
		static public var ACH_28_CRAFT_RUBBISH_DUMP:ModelExternalAchievement = create("ACH_28");
		static public var ACH_29_TAKE_SELFIE:ModelExternalAchievement = create("ACH_29");
		static public var ACH_30_CRAFT_ECTOPLASM_PRISM:ModelExternalAchievement = create("ACH_30");
		static public var ACH_31_OBTAIN_5_HATS:ModelExternalAchievement = create("ACH_31");
		static public var ACH_32_EARN_LACHHH_SCROLL:ModelExternalAchievement = create("ACH_32");
		static public var ACH_33_GET_BOB_LVL_666:ModelExternalAchievement = create("ACH_33");
		static public var ACH_34_DELETE_ONE_SPAM_MAIL:ModelExternalAchievement = create("ACH_34");
		static public var ACH_35_SPEND_49_PRCT_ORB:ModelExternalAchievement = create("ACH_35");
		
		
		static public function create(id:String):ModelExternalAchievement {
			var m:ModelExternalAchievement = new ModelExternalAchievement(id);
			if(!getFromId(id).isNull) throw new Error("Duplicate ID!");
			ALL.push(m);
			return m;
		}
		
		static public function getFromId(id:String):ModelExternalAchievement {
			for (var i : int = 0; i < ALL.length; i++) {
				var g:ModelExternalAchievement = ALL[i] as ModelExternalAchievement;
				if(id == g.id) return g;
			}
			return NULL;
		} 
		
		static public function getFromIndex(index:int):ModelExternalAchievement {
			if(index >= ALL.length) return NULL;
			if(index < 0) return NULL;
			return ALL[index] as ModelExternalAchievement;
		}  
				
		static public function getNum():int {
			return ALL.length;
		}
	}
}
