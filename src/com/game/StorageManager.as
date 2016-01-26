package com.game
{
	public class StorageManager
	{
		public static const bestScoreKey:String = "bestScore";
		public static const gameStateKey:String = "gameState";
		public static const GAMEKEY:String = "FSER2048";
		public var storage:Storage;
		private static var _instance:StorageManager = null;
		private static var _singlen:Boolean = false;
		public function StorageManager()
		{
			if(_singlen == false || _instance!=null){
				throw new Error("单例模式，非法创建");
			}
			storage = localStorageSupported();
		}
		
		public static function get instance():StorageManager{
			if(_instance == null){
				_singlen = true;
				_instance = new StorageManager();
				_singlen = false;
			}
			return _instance;
		}
		
		private function localStorageSupported():Storage{
			//todo share object
			return new Storage();
		}
		
		public function getBestScore():String{
			return storage.getItem(bestScoreKey) || String(0);
		}
		
		public function setBestScore(score:int):void{
			storage.setItem(bestScoreKey,String(score));
		}
		
		public function setGameState(gameState:Object):void{
			storage.setItem(gameStateKey, JSON.stringify(gameState));
		}
		
		public function getGameState():Object{
			var stateJSON:String = storage.getItem(gameStateKey);
			return stateJSON?JSON.parse(stateJSON) : null;
		}
		
		public function clearGameState():void{
			storage.removeItem(gameStateKey);
		}
		
		public function save():void{
			storage.flush();
		}
	}
}