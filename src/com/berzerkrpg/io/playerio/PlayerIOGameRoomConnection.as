package com.berzerkrpg.io.playerio {
	import playerio.Client;
	import playerio.Connection;

	import com.berzerkrpg.io.MetaPlayerFromServer;
	import com.lachhh.io.Callback;

	/**
	 * @author LachhhSSD
	 */
	public class PlayerIOGameRoomConnection extends PlayerIORoomConnection {
		public var saveEquipComplete:PlayerIORoomCommand;
		public var saveEquipError:PlayerIORoomCommand;
		public var consumeRewardComplete:PlayerIORoomCommand;
		public var consumeRewardError:PlayerIORoomCommand;
		
		public var consumeDailyRewardComplete:PlayerIORoomCommand;
		public var consumeDailyRewardError:PlayerIORoomCommand;
		
		public var createRewardSuccess:PlayerIORoomCommand;
		public var createRewardError:PlayerIORoomCommand;
		
		public var refillDailyRewardSuccess:PlayerIORoomCommand;
		public var refillDailyRewardError:PlayerIORoomCommand;
		
		public var tpzGiveAdScrollsSuccess:PlayerIORoomCommand;
		public var tpzGiveAdScrollsError:PlayerIORoomCommand;
		
		public var tpzGiveSubScrollsSuccess:PlayerIORoomCommand;
		public var tpzGiveSubScrollsError:PlayerIORoomCommand;
		public function PlayerIOGameRoomConnection(pClient : Client, pDebug : Boolean) {
			super(pClient, pDebug);
		}

		override protected function onRoomGameConnected(con : Connection) : void {
			super.onRoomGameConnected(con);
			saveEquipComplete = new PlayerIORoomCommand(this, "saveComplete");
			saveEquipError = new PlayerIORoomCommand(this, "saveError");
			consumeRewardComplete = new PlayerIORoomCommand(this, "comsumeRewardComplete");
			consumeRewardError = new PlayerIORoomCommand(this, "consumeRewardError");
			createRewardSuccess = new PlayerIORoomCommand(this, "adminCreateRewardComplete");
			createRewardError = new PlayerIORoomCommand(this, "adminCreateRewardError");
			refillDailyRewardSuccess = new PlayerIORoomCommand(this, "adminRefillDailyRewardComplete");
			refillDailyRewardError = new PlayerIORoomCommand(this, "adminRefillDailyRewardError");
			
			consumeDailyRewardComplete = new PlayerIORoomCommand(this, "consumeDailyRewardComplete");
			consumeDailyRewardError = new PlayerIORoomCommand(this, "consumeDailyRewardError");
			
			tpzGiveAdScrollsSuccess = new PlayerIORoomCommand(this, "tpzGiveAdScrollsComplete");
			tpzGiveAdScrollsError = new PlayerIORoomCommand(this, "tpzGiveAdScrollsError");
			
			tpzGiveSubScrollsSuccess = new PlayerIORoomCommand(this, "tpzGiveSubScrollsComplete");
			tpzGiveSubScrollsError = new PlayerIORoomCommand(this, "tpzGiveSubScrollsError");
		}
		
		
		public function AskToSave(m:MetaPlayerFromServer, success:Callback, errorCallback:Callback):void {
			
			saveEquipComplete.onMsg = success;
			saveEquipError.onMsg = errorCallback;
			/*connection.send("saveEquipment", m.catchPhrase, 
				m.slotSword.metaItem.modelItem.id,
				m.slotShield.metaItem.modelItem.id,
				m.slotHelmet.metaItem.modelItem.id,
				m.slotBody.metaItem.modelItem.id,
				m.slotArm.metaItem.modelItem.id,
				m.slotRing.metaItem.modelItem.id
				);*/
		}


		/*public function AskToCreateReward(m:MetaRewardFromServer, success:Callback, errorCallback:Callback):void {
			
			createRewardSuccess.onMsg = success;
			createRewardError.onMsg = errorCallback;
			connection.send("adminCreateReward", m.target.toLowerCase(), 
				m.metaReward.encodeNOTOWKRINGFORCHESTITEM());
		}*/
	
		public function AskToRefillDailyReward(minutes:int, success:Callback, errorCallback:Callback):void {
			
			refillDailyRewardSuccess.onMsg = success;
			refillDailyRewardError.onMsg = errorCallback;
			connection.send("adminRefillDailyReward", minutes);
		}

		public function AskToConsume(m : MetaRewardFromServer, success : Callback, errorCallback : Callback) : void {
			consumeRewardComplete.onMsg = success;
			consumeRewardError.onMsg = errorCallback;
			connection.send("consumeReward", m.key);
		}
		
		public function AskToConsumeDailyChest(success:Callback, errorCallback:Callback):void {
			consumeDailyRewardComplete.onMsg = success;
			consumeDailyRewardError.onMsg = errorCallback;
			connection.send("consumeDailyReward");			
		}
		
		public function AskToGiveAdScrolls(names:Array, active:Array, success:Callback, errorCallback:Callback):void {
			tpzGiveAdScrollsSuccess.onMsg = success;
			tpzGiveAdScrollsError.onMsg = errorCallback;
			connection.send("tpzGiveAdScrolls", JSON.stringify(names), JSON.stringify(active));			
		}
		
		public function AskToGiveSubScrolls(names:Array, success:Callback, errorCallback:Callback):void {
			tpzGiveSubScrollsSuccess.onMsg = success;
			tpzGiveSubScrollsError.onMsg = errorCallback;
			connection.send("tpzGiveSubScrolls", JSON.stringify(names));			
		}
	}
}

