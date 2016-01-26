package com.game
{
	import com.common.DispatcherHandler;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class PassView extends Sprite
	{

		private var _bg:Sprite;
		private var _gameOver:TextField;
		public function PassView()
		{
			super();
			addChild(_bg = new Sprite());
			_bg.alpha = 0.8;
			
			_gameOver = new TextField();
			_gameOver.selectable = false;
			_gameOver.antiAliasType = flash.text.AntiAliasType.NORMAL;
			_gameOver.autoSize =  TextFieldAutoSize.LEFT;
			var tf:TextFormat = _gameOver.getTextFormat();
			tf.color = 0x8F7A66;
			tf.align = TextFormatAlign.CENTER;
			tf.size = 50;
			tf.font = Setting.FONTTYPE;
			_gameOver.defaultTextFormat = tf;
			_gameOver.setTextFormat(tf);
			
			setMsg("鼠标点击继续游戏");
		}
		
		
		public function setMsg(msg:String):void{
			_gameOver.text = msg;
			resize();
		}
		
		public function resize():void{
			with(_bg){
				graphics.clear();
				graphics.beginFill(0xFBF8EF,1);
				graphics.drawRoundRect(0,0,500,500,10,10);
				graphics.endFill();
			}
			
			addChild(_gameOver);
			_gameOver.x = (this.width - _gameOver.textWidth)/2;
			_gameOver.y = (this.height - _gameOver.textHeight)/2;
		}
		
		
	}
}