package com.common
{
	import flash.utils.Dictionary;

	public class DispatcherHandler
	{
		private static var _instance:DispatcherHandler = null;
		private static var _singlen:Boolean = false;
		private var _handlerMap:Dictionary;
		public function DispatcherHandler()
		{
			if(_singlen == false || _instance!=null){
				throw new Error("单例模式，非法创建");
			}
			_handlerMap = new Dictionary();
		}
		
		public static function get instance():DispatcherHandler{
			if(_instance == null){
				_singlen = true;
				_instance = new DispatcherHandler();
				_singlen = false;
			}
			return _instance;
		}
		
		public function addEventListener(event:String,handler:Function):void {
			var listeners:Array;
			if(_handlerMap.hasOwnProperty(event)){
				listeners = _handlerMap[event];
			}else{
				_handlerMap[event] = listeners = [];
			}
			if(listeners.indexOf(handler) == -1){
				listeners.push(handler);
			}
		}
		
		public function removeEventListener(event:String,handler:Function):void {
			var listeners:Array;
			if(_handlerMap.hasOwnProperty(event)){
				listeners = _handlerMap[event];
			}else{
				return;
			}
			var idx:int = listeners.indexOf(handler);
			if(idx>-1){
				listeners.splice(idx,1);
			}
		}
		
		public function dispatcheEvent(event:String,data:Object = null):void {
			var listeners:Array;
			if(_handlerMap.hasOwnProperty(event)){
				listeners = _handlerMap[event];
			}else{
				return;
			}
			var listener:Function;
			for(var i:int=0;i<listeners.length; i++){
				listener = 	listeners[i];
				listener(event,data);
			}
		}
	}
}