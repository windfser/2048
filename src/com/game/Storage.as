package com.game
{
	import flash.net.SharedObject;

	public class Storage
	{
		private var _data:Object;
		private var _cookie:SharedObject;
		public function Storage()
		{
			_data = {};
			_cookie = SharedObject.getLocal(StorageManager.GAMEKEY);
			_data[StorageManager.bestScoreKey] = _cookie.data[StorageManager.bestScoreKey];
			//_data = _cookie.data;
		}
		
		public function setItem(id:String,val:String):void{
			_data[id] = String(val);
		}
		
		public function getItem(id:String):*{
			return _data.hasOwnProperty(id) ? _data[id] : undefined;
		}
		
		public function removeItem(id:String):void{
			delete _data[id];
		}
		
		public function flush():void{
			_cookie.data[StorageManager.bestScoreKey] = _data[StorageManager.bestScoreKey];
			_cookie.flush();
		}
		
		public function clear():void{
			_data = {};
		}
	}
}