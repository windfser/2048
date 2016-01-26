package
{
	//by fengsser
	import com.game.Game;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.tool.UIEditor;
	
	[SWF(backgroundColor="#FBF8EF",frameRate="30",width="546",height="745")]
	public class Main extends Sprite
	{
		public function Main()
		{
			if(stage){
				init();
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			}
		}
		
		private function onAddToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			init();
		}
		
		private function init():void{
			var game:Game = new Game(this.stage);
		}
	}
}