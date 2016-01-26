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
	
	public class MessageView extends Sprite
	{
		public static const MESSAGE_TYPE_START:String = "MESSAGE_TYPE_START";
		public static const MESSAGE_TYPE_OVER:String = "MESSAGE_TYPE_OVER";
		private var _bg:Sprite;
		private var _btnTab:Tab;
		private var _type:String = MESSAGE_TYPE_OVER;
		private var _gameOver:TextField;
		private var _msgTxt:TextField;
		public function MessageView()
		{
			super();
			addChild(_bg = new Sprite());
			_bg.alpha = 0.8;
			_btnTab = new Tab("提交",0xF9F6F2,0x8F7A66,18,20,10);
			_btnTab.buttonMode = true;
			_btnTab.addEventListener(MouseEvent.CLICK,onBtnClick);
			
			_gameOver = new TextField();
			_gameOver.selectable = false;
			_gameOver.antiAliasType = flash.text.AntiAliasType.NORMAL;
			_gameOver.text = "GameOver";
			_gameOver.autoSize =  TextFieldAutoSize.LEFT;
			var tf:TextFormat = _gameOver.getTextFormat();
			tf.color = 0x8F7A66;
			tf.align = TextFormatAlign.CENTER;
			tf.size = 80;
			tf.font = Setting.FONTTYPE;
			_gameOver.defaultTextFormat = tf;
			_gameOver.setTextFormat(tf);
			
			_msgTxt = new TextField();
			_msgTxt.selectable = false;
			_msgTxt.antiAliasType = flash.text.AntiAliasType.NORMAL;
			_msgTxt.text = "";
			_msgTxt.wordWrap = true;
			tf = _msgTxt.getTextFormat();
			tf.color = 0x8F7A66;
			tf.align = TextFormatAlign.CENTER;
			tf.size = 30;
			tf.bold = true;
			tf.font = Setting.FONTTYPE;
			_msgTxt.defaultTextFormat = tf;
			_msgTxt.setTextFormat(tf);
		}
		
		protected function onBtnClick(event:MouseEvent):void
		{
			DispatcherHandler.instance.dispatcheEvent(_type);
		}
		
		public function setMsg(msg:String):void{
			_msgTxt.htmlText = msg;
			resize();
		}
		
		public function resize():void{
			with(_bg){
				graphics.clear();
				graphics.beginFill(0xFBF8EF,1);
				graphics.drawRoundRect(0,0,500,500,10,10);
				graphics.endFill();
			}
			_msgTxt.x = 0;
			_msgTxt.width = 500;
			
			addChild(_gameOver);
			addChild(_msgTxt);
			addChild(_btnTab);
			_gameOver.x = (this.width - _gameOver.textWidth)/2;
			_gameOver.y = 45;
			_msgTxt.y = _gameOver.y + _gameOver.textHeight + 30;
			_btnTab.x = (this.width - _btnTab.width)/2;
			_btnTab.y = _msgTxt.y + _msgTxt.textHeight + 30;
		}
		
		
	}
}