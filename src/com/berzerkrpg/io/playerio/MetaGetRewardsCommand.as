package com.berzerkrpg.io.playerio {
	import playerio.Message;

	import com.berzerkrpg.io.MetaServerProgress;
	import com.lachhh.io.Callback;

	/**
	 * @author Eel
	 */
	public class MetaGetRewardsCommand extends MetaPlayerIOCommand {
		
		public static const SUCCESS:String = "successLoadingRewardsFromAlias";
		public static const ERROR:String = "errorLoadingRewardsFromAlias";
		
		public var callbackOnSuccess:Callback;
		public var callbackOnError:Callback;
		
		public function MetaGetRewardsCommand(pCommand : String, pArg1 : String) {
			super(pCommand, pArg1, [SUCCESS, ERROR], null);
		}
		
		public override function onResponse(m:Message):void{
			super.onResponse(m);
			if(m.type == SUCCESS){
				var keys:Array = new Array();
				for(var i:int = 0; i < m.length; i++){
					keys.push(m.getString(i));
				}
				MetaServerProgress.loadRewardsWithAliasKeys(keys, callbackOnSuccess, callbackOnError);
			} else if(m.type == ERROR){
				if(callbackOnError) callbackOnError.call();
			}
		}
	}
}