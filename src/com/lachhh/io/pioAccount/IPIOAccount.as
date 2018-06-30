package com.lachhh.io.pioAccount {
	import com.lachhh.io.IExternalAPI;
	/**
	 * @author LachhhSSD
	 */
	public interface IPIOAccount extends IExternalAPI {
		function getUserUDID():String;
		function getPioId():String;
		function getAuthToken():String;
		function getUserName():String;
	}
}
