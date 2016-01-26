package com.game
{
	import com.common.DispatcherHandler;
	import com.common.KeyUtil;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;

	public class Actuator
	{
		private var _tileContainer:TileContainer;
		
		
		private var _stage:Stage;
		private var _game:Game;
		private var _gridUnitSize:uint;
		private var _view:View;
		public function Actuator(game:Game)
		{
			_game = game;
			_stage = game.stage;
			_view = new View();
			_gridUnitSize = 108;
			_view.create(game.size,_gridUnitSize);
			_tileContainer = _view.tileContainer;
			_stage.addChild(_view);
			DispatcherHandler.instance.addEventListener(KeyUtil.DISAVTIVITY,onPass);
			DispatcherHandler.instance.addEventListener(KeyUtil.AVTIVITY,onActivity);
			_game.stage.addEventListener(Event.ENTER_FRAME,onFrame);
			
		}	
		
		protected function onFrame(event:Event):void
		{
			if(_game.stage.focus != null){
				_game.stage.focus = null;
			}
//			if(_game.stage){
//				_view.updateNewTarget(_game.stage.focus != null? _game.stage.focus.toString():""); 
//			}else{
//				_view.updateNewTarget("");
//			}
		}
		
		private function onActivity(event:String,data:Object):void
		{
			_view.hidePass();
		}
		
		private function onPass(event:String,data:Object):void
		{
			_view.showPass();
		}
		
		public function actuate(grid:Grid, metadata:Object):void{
			//clearContainer(_tileContainer);
			//TweenMax.killAll();
//			KeyUtil.instance.enable = false;
//			TweenMax.delayedCall(0.3,function():void{
//				KeyUtil.instance.enable = true;
//			});
			_tileContainer.clearGrids();
			grid.cells.forEach(function(...args):void {
				var column:Vector.<Tile> = args[0];
				column.forEach(function (...args):void {
					var cell:Tile = args[0];
					if (cell) {
						addTile(cell);
					}
				});
			});
			updateBestScore(metadata.bestScore);
			updateScore(metadata.score);
			updateTabsPos();
			alertAddScore();
			updateNewTarget(metadata.bestGrid);
			if (metadata.terminated) {
				if (metadata.over || metadata.own) {
					message(metadata.score);
				}
			}
		}
		
		private function updateNewTarget(score:int):void
		{
			var msg:String = "";
			switch(score){
				case 0:
					msg = "使用鼠标或键盘方向键合并相同的文字"
					break;
				case 4:
					msg = "干得漂亮！试试去挑战方块8吧！";
					break;
				case 1024:
					msg = "还差一点，你就到达2048了！加油！";
					break;
				case 2048:
					msg = "2048仅仅只是开始，去迎接新的挑战吧！(4096)";
					break;
				default:
					msg = "您的新挑战是获得方块"+score*2;
					break;
			}
			_view.updateNewTarget(msg);
			
		}
		
		public function addTile(tile:Tile):void{
			var tileSkin:TileSkin = _tileContainer.getTile();
			var position:Point  = tile.previousPosition || tile.position;
			var styleCfg:Array = getTileSkin(tile.value);
			tileSkin.setData(tile.value);
			tileSkin.setSkin(styleCfg[0],styleCfg[1],styleCfg[2],styleCfg[3]);
			if (tile.previousPosition) {
				tileSkin.x = _tileContainer.positionMap[tile.previousPosition.x][tile.previousPosition.y].x;
				tileSkin.y = _tileContainer.positionMap[tile.previousPosition.x][tile.previousPosition.y].y;
				TweenMax.to(tileSkin,0.1,{x:_tileContainer.positionMap[tile.x][tile.y].x,y:_tileContainer.positionMap[tile.x][tile.y].y,ease:Linear.easeNone});
			} else if (tile.mergedFrom) {
				tileSkin.x = _tileContainer.positionMap[tile.x][tile.y].x;
				tileSkin.y = _tileContainer.positionMap[tile.x][tile.y].y;
				tileSkin.scaleX = 0;
				tileSkin.scaleY = 0;
				TweenMax.to(tileSkin,0.15,{scaleX:1,scaleY:1,ease:Back.easeOut,delay:0.1});
				tile.mergedFrom.forEach(function (merged:Tile,a1:*,a2:*):void {
					addTile(merged);
				});
			} else {
				tileSkin.x = _tileContainer.positionMap[tile.x][tile.y].x;
				tileSkin.y = _tileContainer.positionMap[tile.x][tile.y].y;
				tileSkin.scaleX = 0;
				tileSkin.scaleY = 0;
				TweenMax.to(tileSkin,0.25,{scaleX:1,scaleY:1,ease:Linear.easeNone});
			}
			_tileContainer.addTile(tileSkin);
		}
		
		public function getTileSkin(value:int):Array{
			var tileStyle_2:Object = {color:0x776e65,background:0xEEE4DA};
			var tileStyle_4:Object = {color:0x776e65,background:0xede0c8};
			var tileStyle_8:Object = {color:0xf9f6f2,background:0xf2b179};
			var tileStyle_16:Object = {color:0xf9f6f2,background:0xf59563};
			var tileStyle_32:Object = {color:0xf9f6f2,background:0xf67c5f};
			var tileStyle_64:Object = {color:0xf9f6f2,background:0xf65e3b};
			var tileStyle_128:Object = {color:0xf9f6f2,background:0xedcf72};
			var tileStyle_256:Object = {color:0xf9f6f2,background:0xedcc61};
			var tileStyle_512:Object = {color:0xf9f6f2,background:0xedc850};
			var tileStyle_1024:Object = {color:0xf9f6f2,background:0xedc53f};
			var tileStyle_2048:Object = {color:0xf9f6f2,background:0xedc22e};
			var styleCfgArr:Array = [tileStyle_2,tileStyle_4,tileStyle_8,tileStyle_16,tileStyle_32,tileStyle_64,tileStyle_128,tileStyle_256,tileStyle_512,tileStyle_1024,tileStyle_2048];
			var typeEnumArr:Array = [2,4,8,16,32,64,128,256,512,1024,2048];
			var fontSize:int = 55;
			if(value>100){
				fontSize = 45;
			}
			if(value >1000){
				fontSize = 35;
			}
			if(value >2000){
				fontSize = 30;
			}
			if(value >10000){
				fontSize = 20;
			}
			while(value>2048){
				value = value/2048;
			}
			var textColor:int;
			var backgroundColor:int;
			var idx:int = typeEnumArr.indexOf(value);
			var styleCfg:Object = styleCfgArr[idx];
			textColor = styleCfg.color;
			backgroundColor = styleCfg.background;
			
			return [textColor,backgroundColor,_gridUnitSize,fontSize];
		}
		
		public function updateScore(score:int):void{
			_view.setCurScore(score);
		}
		
		public function updateBestScore(bestScore:int):void{
			_view.setBestScore(bestScore);
		}
		
		public function updateTabsPos():void{
			_view.updateTabsPos();
		}
		
		public function alertAddScore():void{
			_view.alertAddScore();
		}
		
		public function message(score:uint):void{
			_view.showMessage(score);
		}
		
		public function continueGame():void{
			clearMessage();
		}
		
		private function clearMessage():void
		{
			_view.hideMessage();
		}
		
		private function clearContainer(container:DisplayObjectContainer):void{
			if(container.numChildren>0){
				container.removeChildren(0,container.numChildren-1);
			}
		}
	}
}