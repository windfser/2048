package com.game
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class TileContainer extends Sprite
	{
		public var positionMap:Array;
		private var _backgroundLayer:Sprite;
		private var _gridLayer:Sprite;
		private var _tileArr:Vector.<TileSkin>;
		private var _freeTileArr:Vector.<TileSkin>;
		public function TileContainer(size:uint,gridUnitSize:uint)
		{
			super();
			_tileArr = new Vector.<TileSkin>();
			_freeTileArr = new Vector.<TileSkin>();
			graphics.beginFill(0xBBADA0,1);
			graphics.drawRoundRect(0,0,500,500,10,10);
			graphics.endFill();
			addChild(_backgroundLayer = new Sprite());
			addChild(_gridLayer = new Sprite());
			setting(size,gridUnitSize);
		}
		
		private function setting(size:int,gridUnitSize:uint):void
		{
			positionMap = [];
			var gap:int = 15;
			var startXY:int = 13;
			var gridSize:int = gridUnitSize;
			var gridHalf:Number = gridSize/2;
			var gStartXY:Number = -gridHalf;
			for(var x:int=0; x<size; x++){
				positionMap[x] = [];
				for(var y:int=0; y<size; y++){
					positionMap[x][y] = new Point(startXY+x*gap + x*gridSize + gridHalf,startXY+y*gap + y*gridSize + gridHalf);
					var backgroundTile:Sprite = new Sprite();
					backgroundTile.x = positionMap[x][y].x;
					backgroundTile.y = positionMap[x][y].y;
					with(backgroundTile){
						graphics.beginFill(0xCDC1B3,1);
						graphics.drawRoundRect(gStartXY,gStartXY,gridSize,gridSize,10,10);
						graphics.endFill();
					}
					_backgroundLayer.addChild(backgroundTile);
				}
			}
		}
		
		public function addTile(tile:TileSkin):void{
			_tileArr.push(tile);
			_gridLayer.addChild(tile);
		}
		
		public function getTile():TileSkin{
			return _freeTileArr.length>0?_freeTileArr.pop():new TileSkin();
		}
		
		public function clearGrids():void{
			TweenMax.killChildTweensOf(_gridLayer);
			for(var i:int=0; i<_tileArr.length; i++){
				var tile:TileSkin = _tileArr[i];
				if(tile.parent){
					tile.parent.removeChild(tile);
					_freeTileArr.push(tile);
					tile.scaleX = 1;
					tile.scaleY = 1;
				}
			}
			_tileArr.length = 0;
		}
	}
}