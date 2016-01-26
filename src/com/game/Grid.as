package com.game
{
	import flash.geom.Point;

	public class Grid
	{
		private var _size:int;
		private var _cells:Vector.<Vector.<Tile>>;
		public function Grid(size:int,previousState:Array = null)
		{
			_size = size;
			_cells = previousState?fromState(previousState):empty();	
		}
		
		/**根据状态构建格阵**/
		private function fromState(state:Array):Vector.<Vector.<Tile>>{
			var cells:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>();
			for (var x:int = 0; x < _size; x++) {
				var row:Vector.<Tile> = cells[x] = new Vector.<Tile> ;
				for (var y:int = 0; y < this._size; y++) {
					var tileState:Object = state[x][y];
					row.push(tileState ? new Tile(tileState.position, tileState.value) : null);
				}
			}
			return cells;
		}
		
		/**构建空格阵**/
		private function empty():Vector.<Vector.<Tile>>{
			var cells:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>();
			for (var x:int = 0; x < _size; x++) {
				var row:Vector.<Tile> = cells[x] = new Vector.<Tile>();
				for (var y:int = 0; y < this._size; y++) {
					row.push(null);
				}
			}
			return cells;
		}
		
		/**获取随机空格位置**/
		public function randomAvailableCell():Point{
			var cells:Vector.<Point> = availableCells();
			if (cells.length>0) {
				return cells[Math.floor(Math.random() * cells.length)];
			}
			return null;
		}
		
		/**获取可用空格位置**/
		private function availableCells():Vector.<Point>{
			var cells:Vector.<Point> = new Vector.<Point>();
			this.eachCell(function (x:int, y:int, tile:Tile):void {
				if (!tile) {
					cells.push(new Point(x,y));
				}
			});
			return cells;
		}
		
		/**遍历每个单位并回调**/
		public function eachCell(callback:Function):void{
			for (var x:int = 0; x < _size; x++) {
				for (var y:int = 0; y < _size; y++) {
					callback(x, y, _cells[x][y]);
				}
			}
		}
		
		/**检测是否还有可用空格**/
		public function cellsAvailable():Boolean{
			return !!this.availableCells().length;
		}
		
		/**检测指定格是否可用**/
		public function cellAvailable(cell:Point):Boolean{
			return !this.cellOccupied(cell);
		}
		
		private function cellOccupied(cell:Point):Boolean{
			return !!this.cellContent(cell);
		}
		
		public function cellContent(cell:Point):Tile{
			if (this.withinBounds(cell)) {
				return this._cells[cell.x][cell.y];
			} else {
				return null;
			}
		}
		
		public function withinBounds(position:Point):Boolean{
			return position.x >= 0 && position.x < _size &&
				position.y >= 0 && position.y < _size;
		}
		
		public function serialize():Object{
			var cellState:Vector.<Vector.<Object>> = new  Vector.<Vector.<Object>>;
			for (var x:int = 0; x < _size; x++) {
				var row:Vector.<Object> = cellState[x] = new Vector.<Object>;
				for (var y:int = 0; y < _size; y++) {
					row.push(_cells[x][y] ? _cells[x][y].serialize() : null);
				}
			}
			return {size: _size,cells: cellState};
		}
		
		// Inserts a tile at its position
		public function insertTile(tile:Tile):void{
			_cells[tile.x][tile.y] = tile;
		}
		
		public function get cells():Vector.<Vector.<Tile>>{
			return _cells;
		}
		
		public function removeTile(tile:Tile):void{
			_cells[tile.x][tile.y] = null;
		}
		
		
	}
}