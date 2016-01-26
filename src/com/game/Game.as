package com.game
{
	import com.common.Direction;
	import com.common.DispatcherHandler;
	import com.common.KeyUtil;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Game
	{
		private var _stage:Stage;
		private var _size:int;
		private var _startTiles:int;
		private var _grid:Grid
		private var _score:int;
		private var _bestGrid:int;
		private var _over:Boolean;
		private var _won:Boolean;
		private var _keepPlaying:Boolean;
		private var _actuator:Actuator;
		private var _mouseDownPoint:Point;

		public function Game(stage:Stage)
		{
			_stage = stage;
			setting();
			setUp();
		}
		
		// Set up the game
		private function setUp():void
		{
			var previousState:Object = StorageManager.instance.getGameState();
			// Reload the game from a previous game if present
			if(previousState){
				_grid = new Grid(previousState.grid.size,previousState.grid.cells);
				_score       = previousState.score;
				_over        = previousState.over;
				_won         = previousState.won;
				_keepPlaying = previousState.keepPlaying;
			}else{
				_grid        = new Grid(_size);
				_score       = 0;
				_bestGrid    = 0;
				_over        = false;
				_won         = false;
				_keepPlaying = false;
				
				// Add the initial tiles
				this.addStartTiles();
			}
			// Update the actuator
			this.actuate();
			KeyUtil.instance.enable = true;
		}
		
		private function restart(event:String = "",evnetData:Object = null):void{
			StorageManager.instance.clearGameState();
			_actuator.continueGame(); // Clear the game won/lost message
			setUp();
		}
		
		// Sends the updated grid to the actuator
		private function actuate():void
		{
			if (int(StorageManager.instance.getBestScore()) < _score) {
				StorageManager.instance.setBestScore(_score);
			}
			
			// Clear the state when the game is over (game over only, not win)
			if (_over) {
				StorageManager.instance.clearGameState();
				StorageManager.instance.save();
			} else {
				StorageManager.instance.setGameState(this.serialize());
			}
			
			_actuator.actuate(_grid, {
				score:      _score,
				over:       _over,
				won:        _won,
				bestScore:  StorageManager.instance.getBestScore(),
				bestGrid:   _bestGrid,
				terminated: isGameTerminated()
			}
			);
			
		}
		
		// Check for available matches between tiles (more expensive check)
		public function prepareTiles():void{
			_grid.eachCell(function (x:int, y:int, tile:Tile):void {
				if (tile) {
					tile.mergedFrom = null;
					tile.savePosition();
				}
			});
		}
		
		// Return true if the game is lost, or has won and the user hasn't kept playing
		public function isGameTerminated():Boolean{
			return _over || (_won && !_keepPlaying);
		}
		
		// Represent the current game as an object
		private function serialize():Object
		{
			return {
				grid:        _grid.serialize(),
				score:       _score,
				over:        _over,
				won:         _won,
				keepPlaying: _keepPlaying
			};
		}
		
		// Set up the initial tiles to start the game 
		private function addStartTiles():void{
			for (var i:int = 0; i < _startTiles; i++) {
				addRandomTile();
			}
		}
		
		// Adds a tile in a random position
		private function addRandomTile():void{
			if (_grid.cellsAvailable()) {
				var value:int = Math.random() < 0.9 ? 2 : 4;
				var tile:Tile = new Tile(_grid.randomAvailableCell(), value);
				
				_grid.insertTile(tile);
			}
		}
		
		
		private function setting():void{
			_size = 4;// Size of the grid
			_startTiles = 2;
			_actuator = new Actuator(this);
			KeyUtil.instance.injectStage(_stage);
			KeyUtil.instance.openKey(KeyUtil.UP);
			KeyUtil.instance.openKey(KeyUtil.LEFT);
			KeyUtil.instance.openKey(KeyUtil.RIGHT);
			KeyUtil.instance.openKey(KeyUtil.DOWN);
			KeyUtil.instance.addKeyListener(move,[KeyUtil.UP]);
			KeyUtil.instance.addKeyListener(move,[KeyUtil.DOWN]);
			KeyUtil.instance.addKeyListener(move,[KeyUtil.LEFT]);
			KeyUtil.instance.addKeyListener(move,[KeyUtil.RIGHT]);
			DispatcherHandler.instance.addEventListener(View.EVENT_NEWGAME,restart);
			CONFIG::PLA4399{
				DispatcherHandler.instance.removeEventListener(View.EVENT_NEWGAME,restart);
				DispatcherHandler.instance.addEventListener(View.EVENT_NEWGAME,onLookRank);
			}
			DispatcherHandler.instance.addEventListener(MessageView.MESSAGE_TYPE_OVER,onSubmitScore);
			
			_mouseDownPoint = new Point();
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
	
		
		private function onLookRank(event:String,data:Object):void
		{
			CONFIG::PLA4399{
				if(Main.serviceHold){
					Main.serviceHold.showSort();
				}
			}
		}
		
		private function onSubmitScore(event:String,data:Object):void
		{
			CONFIG::PLA3366{
				if(Main.open3366Service){
					Main.open3366Service.submitScore(_score);  
				}
			}
			CONFIG::PLA4399{
				if(Main.serviceHold){
					Main.serviceHold.showRefer(_score);
				}
			}
			restart();
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			var mouseX:Number = event.stageX;
			var mouseY:Number = event.stageY;
			var dY:Number = mouseY - _mouseDownPoint.y;
			var dX:Number = mouseX - _mouseDownPoint.x;
			var kbEvent:KeyboardEvent;
			kbEvent = new KeyboardEvent(KeyboardEvent.KEY_UP);
			if(Math.abs(dX)>=Math.abs(dY)){
				if(dX>20){
					kbEvent.keyCode = KeyUtil.RIGHT;
					move(kbEvent);
				}else if(dX<-20){
					kbEvent.keyCode = KeyUtil.LEFT;
					move(kbEvent);
				}
			}else{
				if(dY>20){
					kbEvent.keyCode = KeyUtil.DOWN;
					move(kbEvent);
				}else if(dY<-20){
					kbEvent.keyCode = KeyUtil.UP;
					move(kbEvent);
				}
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			_mouseDownPoint.x = event.stageX;
			_mouseDownPoint.y = event.stageY;
		}
		
		// Build a list of positions to traverse in the right order
		private function buildTraversals(vector:Point):Object{
			var traversals:Object = { x: [], y: [] };
			for (var pos:int = 0; pos < _size; pos++) {
				traversals.x.push(pos);
				traversals.y.push(pos);
			}
			// Always traverse from the farthest cell in the chosen direction
			if (vector.x === 1) traversals.x = traversals.x.reverse();
			if (vector.y === 1) traversals.y = traversals.y.reverse();
			return traversals;
		}
		
		public function move(event:KeyboardEvent):void{
			var direction:int;
			switch(event.keyCode){
				case KeyUtil.UP:
					direction = Direction.UP;
					break;
				case KeyUtil.DOWN:
					direction = Direction.DOWN;
					break;
				case KeyUtil.LEFT:
					direction = Direction.LEFT;
					break;
				case KeyUtil.RIGHT:
					direction = Direction.RIGHT;
					break;
				default:
					return;
			}
			
			var vector:Point = getVector(direction);
			var traversals:Object = this.buildTraversals(vector);
			var moved:Boolean = false;
			var cell:Point, tile:Tile;
			this.prepareTiles();
			traversals.x.forEach(
				function (x:int,a1:*,a2:*):void {traversals.y.forEach(function (y:int,a1:*,a2:*):void {
					cell = new Point(x,y);
					tile = _grid.cellContent(cell);
					if (tile) {
						var positions:Object = findFarthestPosition(cell, vector);
						var next:Tile = _grid.cellContent(positions.next);
						// Only one merger per row traversal?
						if (next && next.value === tile.value && !next.mergedFrom) {
							var mergedValue:int = tile.value * 2;
							if(mergedValue > _bestGrid){
								_bestGrid = mergedValue;
							}
							var merged:Tile = new Tile(positions.next, mergedValue);
							merged.mergedFrom = [tile, next];
							_grid.insertTile(merged);
							_grid.removeTile(tile);
							// Converge the two tiles' positions
							tile.updatePosition(positions.next);
							// Update the score
							_score += merged.value;
							// The mighty 2048 tile 
							//in my game you will not win forever
//							if (merged.value == 64){
//								_won = true;
//							}
						} else {
							moveTile(tile, positions.farthest);
						}
						
						if (!positionsEqual(cell, tile.position)) {
							moved = true; // The tile moved from its original cell!
						}
					}
				}
					)}
			);
			if (moved) {
				this.addRandomTile();
				
				if (!this.movesAvailable()) {
					_over = true; // Game over!
				}
			}
				
			this.actuate();
		}
		
		public function movesAvailable():Boolean{
			return _grid.cellsAvailable() || this.tileMatchesAvailable();
		}
		
		private function tileMatchesAvailable():Boolean{
			var tile:Tile;
			for (var x:int = 0; x < _size; x++) {
				for (var y:int = 0; y < _size; y++) {
					tile = _grid.cellContent(new Point(x,y));
					if (tile) {
						var directions:Array = [Direction.DOWN,Direction.LEFT,Direction.RIGHT,Direction.UP];
						for each (var direction:int in directions) {
							var vector:Point = getVector(direction);
							var cell:Point  = new Point(x + vector.x,y + vector.y);
							var otherTile:Tile  = _grid.cellContent(cell);
							if (otherTile && otherTile.value === tile.value) {
								return true; // These two tiles can be merged
							}
						}
					}
				}
			}
			
			return false;
		}
				
		
		public function findFarthestPosition(cell:Point, vector:Point):Object{
			var previous:Point;
			// Progress towards the vector direction until an obstacle is found
			do {
				previous = cell.clone();
				cell     = cell.add(vector);
			} while (_grid.withinBounds(cell) && _grid.cellAvailable(cell));
			
			return {
				farthest: previous,
				next: cell // Used to check if a merge is required
			};
		}
		
		public function moveTile(tile:Tile, cell:Point):void{
			_grid.removeTile(tile);
			tile.updatePosition(cell);
			_grid.insertTile(tile);
			
		}
		
		public function getVector(direction:int):Point{
			switch(direction){
				case Direction.UP:
					return new Point(0,-1);
				case Direction.LEFT:
					return new Point(-1,0);
				case Direction.DOWN:
					return new Point(0,1);
				case Direction.RIGHT:
					return new Point(1,0);
			}
			return new Point(0,0);
		}
		
		public function positionsEqual(first:Point, second:Point):Boolean{
			return first.x === second.x && first.y === second.y;
		}

		public function get stage():Stage
		{
			return _stage;
		}

		public function get size():int
		{
			return _size;
		}



	}
}