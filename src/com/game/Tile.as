package com.game
{
	import flash.geom.Point;

	public class Tile
	{
		public var x:int;
		public var y:int;
		public var value:int;
		public var previousPosition:Point;
		public var mergedFrom:Array;
		public function Tile(position:Object,value:int)
		{
			x = position.x;
			y = position.y;
			this.value = value || 2;
			previousPosition = null;
			mergedFrom = null;
		}
		
		public function savePosition():void{
			this.previousPosition = new Point(x,y);
		}
		
		public function updatePosition(position:Point):void{
			this.x = position.x;
			this.y = position.y;
		}
		
		public function get position():Point{
			return new Point(x,y);
		}
		
		/**
		 * @return 
		 * {position:Point,value:int}
		 * **/
		public function serialize():Object{
			return {position:new Point(x,y),value:this.value};
		}
	}
}