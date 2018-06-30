package com.lachhh.flash {
	//import com.lachhh.flash.debug.DebugScreen;
	import com.lachhh.io.Callback;

	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;

	// import com.lachhh.flash.debug.DebugScreen;
	/**
	 * @author LachhhSSD
	 */
	public class RightClickMenuWeb {
		//static private var _ciDebug:ContextMenuItemWithCallbackWeb ;
		static private var _ciBerzerkStudio:ContextMenuItemWithCallbackWeb ;
		//static private var _ciVersionInfo:ContextMenuItemWithCallbackWeb ;
		static private var _contextMenuItems:Array = new Array() ;
		//private static var _debugScreen : DebugScreen;
		private static var _sprite: Sprite;
		private static var _added:Boolean = false;
		
		private static var _menusShown:ContextMenu ;
		private static var _menusHidden:ContextMenu ;
		
		
		
		
		static public function addRightClickMenu(sprite:Sprite):void {
			_ciBerzerkStudio = new ContextMenuItemWithCallbackWeb("Developed by Berzerk Studio", new Callback(onBerzerkStudio, RightClickMenuWeb, null));
			//_ciDebug = new ContextMenuItemWithCallbackWeb("Show Lachhh debug",   new Callback(OnDebug, RightClickMenuWeb, null));
			//_ciVersionInfo = new ContextMenuItemWithCallbackWeb("Version 0.1", new Callback(OnDebug, RightClickMenuWeb, null));
			
			_menusHidden = new ContextMenu();
			_menusHidden.hideBuiltInItems();

			_menusShown = new ContextMenu();
			_menusShown.hideBuiltInItems();
			_menusShown.customItems.push(_ciBerzerkStudio.contextMenuItem);
			/*_menusShown.customItems.push(_ciDebug.contextMenuItem);
			_menusShown.customItems.push(_ciVersionInfo.contextMenuItem);*/
			/*my_menu.builtInItems.forwardAndBack = false;
			my_menu.builtInItems.loop = false;
			my_menu.builtInItems.play = false;
			my_menu.builtInItems.print = false;
			my_menu.builtInItems.quality = false;
			my_menu.builtInItems.rewind = false;
			my_menu.builtInItems.save = false;
			my_menu.builtInItems.zoom = false;*/
			
			_sprite = sprite;
			_sprite.contextMenu = _menusHidden;
		}
		
		static public function addAllContextMenuItem():void {
			if(_added) return ;
			_sprite.contextMenu = _menusShown;
			_added = true;
		}
		
		static public function removeContextMenuItem():void {
			_sprite.contextMenu = _menusHidden;
			_added = false;
			_contextMenuItems = new Array() ;
		}
		
		//static private function OnDebug():void {
			/*if(_debugScreen == null) {
				_debugScreen = new DebugScreen();
				
				_ciDebug.contextMenuItem.caption = "Hide Lachhh debug";
			} else {
				if(!_debugScreen.destroyed) _debugScreen.destroy();
				_debugScreen = null;
				_ciDebug.contextMenuItem.caption = "Show Lachhh debug";
			}*/
		//}
		
		static private function onBerzerkStudio():void {
			navigateToURL(new URLRequest("http://www.berzerkstudio.com"), "_blank");
		}
		
	}
}

import com.lachhh.io.Callback;

import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.ui.ContextMenuItem;
class ContextMenuItemWithCallbackWeb {
	private var _contextMenuItem:ContextMenuItem ;
	private var _callback:Callback ;

	public function ContextMenuItemWithCallbackWeb(caption:String, callback:Callback) {
		_contextMenuItem = new ContextMenuItem(caption);
		
		//_contextMenuItem.
		_callback = callback;
		if(_callback != null) {
			_contextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onClick, false, 0, true);
		}
	}
	
	private function onClick(e:Event):void {
		_callback.call();
	}
	
	public function get contextMenuItem():ContextMenuItem {
		return _contextMenuItem;
	}
}