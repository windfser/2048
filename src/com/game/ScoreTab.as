package com.game
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ScoreTab extends Sprite
	{
		private var _scoreText:TextField;
		private var _scoreValueText:TextField;
		public function ScoreTab(tabName:String = "", score:int = 0)
		{
			_scoreValueText = new TextField();
			_scoreValueText.selectable = false;
			_scoreValueText.antiAliasType = flash.text.AntiAliasType.NORMAL;
			_scoreValueText.autoSize =  TextFieldAutoSize.LEFT;
			var tf:TextFormat = _scoreValueText.getTextFormat();
			tf = _scoreValueText.getTextFormat();
			tf.color = 0xffffff;
			tf.size = 25;
			tf.font = Setting.FONTTYPE;
			_scoreValueText.defaultTextFormat = tf;
			_scoreValueText.setTextFormat(tf);
			
			
			_scoreText = new TextField();
			_scoreText.selectable = false;
			_scoreText.antiAliasType = flash.text.AntiAliasType.NORMAL;
			_scoreText.autoSize =  TextFieldAutoSize.LEFT;
			tf = _scoreText.getTextFormat();
			tf.color = 0xEEE4DA;
			tf.size = 13;
			tf.font = Setting.FONTTYPE;
			_scoreText.defaultTextFormat = tf;
			_scoreText.setTextFormat(tf);
			addChild(_scoreText);
			addChild(_scoreValueText);
			setTabName(tabName);
			setValue(score);
		}
		
		public function setTabName(name:String):void{
			_scoreText.text = name;
		}
		
		public function setValue(value:int):void{
			var cwidth:Number = 0;
			var cgap:Number = 25;
			_scoreValueText.text = value.toString();
			cwidth = _scoreValueText.textWidth + cgap*2;
			_scoreValueText.y = 21;
			_scoreValueText.x = (cwidth - _scoreValueText.textWidth)/2;
			graphics.clear();
			graphics.beginFill(0xBDACA2,1);
			graphics.drawRoundRect(0,0,cwidth,55,10,10);
			graphics.endFill();
			_scoreText.y = 6;
			_scoreText.x = (cwidth - _scoreText.textWidth)/2;
		}
	}
}