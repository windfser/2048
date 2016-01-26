package com.game
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class TileSkin extends Sprite
	{
		private var _textfiled:TextField;
		private var _textColor:uint;
		public function TileSkin()
		{
			super();
			_textfiled = new TextField();
			_textfiled.selectable = false;
			_textfiled.wordWrap = true;
			_textfiled.multiline = true;
			_textfiled.antiAliasType = flash.text.AntiAliasType.NORMAL;
			addChild(_textfiled);
		}
		
		public function setData(value:int):void{
			_textfiled.text = value.toString();
		}
		
		public function setSkin(textColor:uint,backgroundColor:uint,gridUnitSize:Number,fontSize:uint):void{
			graphics.clear();
			graphics.beginFill(backgroundColor,1);
			var startXY:Number = -gridUnitSize/2;
			graphics.drawRoundRect(startXY,startXY,gridUnitSize,gridUnitSize,10,10);
			graphics.endFill();
			var tf:TextFormat = _textfiled.getTextFormat();
			tf.color = textColor;
			tf.align = TextFormatAlign.CENTER;
			tf.size = fontSize;
			tf.font = Setting.FONTTYPE;
			_textfiled.defaultTextFormat = tf;
			_textfiled.setTextFormat(tf);
			_textfiled.x = - gridUnitSize/2;
			_textfiled.width = gridUnitSize;
			_textfiled.height = _textfiled.textHeight;
			_textfiled.y = (gridUnitSize - _textfiled.height)/2 - gridUnitSize/2;
			
		}
	}
}