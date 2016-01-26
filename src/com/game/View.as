package com.game
{
	import com.common.DispatcherHandler;
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class View extends Sprite
	{
		public static const EVENT_NEWGAME:String= "EVENT_NEWGAME";
		public var tileContainer:TileContainer;
		private var _bestContainer:Sprite;
		private var _messageView:MessageView;
		private var _curScoreTab:ScoreTab;
		private var _bestScoreTab:ScoreTab;
		private var _newGameTab:Tab;
		private var _score:int;
		private var _addScore:int;
		private var _alertMsg:TextField;
		private var _newTargetTxt:TextField;
		private var _passView:PassView;
		public function View()
		{
			graphics.clear();
			graphics.beginFill(0xFBF8EF,1);
			graphics.drawRect(0,0,546,745);
			graphics.endFill();
		}
		
		public function create(size:uint,gridUnitSize:uint):void{
			var title:TextField = new TextField();
			title.selectable = false;
			title.antiAliasType = flash.text.AntiAliasType.NORMAL;
			title.text = "2048";
			title.autoSize =  TextFieldAutoSize.LEFT;
			var tf:TextFormat = title.getTextFormat();
			tf.color = 0x776E65;
			tf.align = TextFormatAlign.CENTER;
			tf.size = 80;
			tf.font = Setting.FONTTYPE;
			title.defaultTextFormat = tf;
			title.setTextFormat(tf);
			title.y = 42;
			title.x = 24;
			
			_newTargetTxt = new TextField();
			_newTargetTxt.selectable = false;
			_newTargetTxt.antiAliasType = flash.text.AntiAliasType.NORMAL;
			_newTargetTxt.text = "2048";
			_newTargetTxt.autoSize =  TextFieldAutoSize.LEFT;
			tf = _newTargetTxt.getTextFormat();
			tf.color = 0x776E65;
			tf.align = TextFormatAlign.CENTER;
			tf.size = 20;
			tf.font = Setting.FONTTYPE;
			_newTargetTxt.defaultTextFormat = tf;
			_newTargetTxt.setTextFormat(tf);
			
			_newTargetTxt.y = title.y + title.textHeight + 20;
			_newTargetTxt.x = title.x;
			
			_curScoreTab = new ScoreTab("Score",0);
			_curScoreTab.x = 358;
			_curScoreTab.y = 40;

			_bestScoreTab = new ScoreTab("Best",0);
			_bestScoreTab.y = 40;
			
			tileContainer = new TileContainer(size,gridUnitSize);
			tileContainer.y = 228;
			tileContainer.x = (546 - tileContainer.width)/2;
			_newGameTab = new Tab("新的游戏",0xF9F6F2,0x8F7A66,18,20,10);
			_newGameTab.x = 394;
			_newGameTab.y = 141;
			_newGameTab.buttonMode = true;
			_newGameTab.addEventListener(MouseEvent.CLICK,onNewGame);
			
			_bestContainer = new Sprite();
			_messageView = new MessageView();
			_messageView.x = tileContainer.x;
			_messageView.y = tileContainer.y;
			hideMessage();
			
			_passView = new PassView();
			_passView.x = tileContainer.x;
			_passView.y = tileContainer.y;
			hidePass();
			
			_alertMsg = new TextField();
			_alertMsg.selectable = false;
			_alertMsg.antiAliasType = flash.text.AntiAliasType.NORMAL;
			_alertMsg.text = "";
			_alertMsg.autoSize =  TextFieldAutoSize.LEFT;
			tf = _alertMsg.getTextFormat();
			tf.color = 0x8F7A66;
			tf.size = 24;
			tf.font = Setting.FONTTYPE;
			_alertMsg.defaultTextFormat = tf;
			_alertMsg.setTextFormat(tf);
			
			
			updateTabsPos();
			
			addChild(tileContainer);
			addChild(_messageView);
			addChild(title);
			addChild(_newTargetTxt);
			addChild(_curScoreTab);
			addChild(_bestScoreTab);
			addChild(_newGameTab);
			addChild(_alertMsg);
			addChild(_passView);
			CONFIG::PLA4399{
				_newGameTab.setTabName("查看排名");
			}
		}
		
		
		
		protected function onNewGame(event:MouseEvent):void
		{
			DispatcherHandler.instance.dispatcheEvent(View.EVENT_NEWGAME,null);
		}
		
		public function setCurScore(value:int):void{
			_addScore = value - _score;
			_score = value;
			_curScoreTab.setValue(value);
		}
		
		public function alertAddScore():void{
			if(_addScore>0){
				_alertMsg.text = "+"+_addScore.toString();
				_alertMsg.x = _curScoreTab.x + (_curScoreTab.width - _alertMsg.width)/2;
				_alertMsg.y = _curScoreTab.y + 6;
				_alertMsg.alpha = 1;
				TweenLite.killTweensOf(_alertMsg);
				TweenLite.to(_alertMsg,0.6,{y:_alertMsg.y - 20,alpha:0,ease:Linear.easeNone});
			}
		}
		
		public function setBestScore(value:int):void{
			_bestScoreTab.setValue(value);
		}
		
		public function updateTabsPos():void{
			_bestScoreTab.x = 522 - _bestScoreTab.width;
			_curScoreTab.x = _bestScoreTab.x - 4 - _curScoreTab.width;
		}
		
		public function showMessage(score:int):void{
			_messageView.setMsg("太厉害了！获得了"+score+"分");
			_messageView.visible = true;	
		}
		
		public function hideMessage():void{
			_messageView.visible = false;
		}
		
		public function showPass():void{
			_passView.visible = true;	
		}
		
		public function hidePass():void{
			_passView.visible = false;
		}
		
		
		public function updateNewTarget(msg:String):void{
			_newTargetTxt.text = msg;
		}
		
		
	}
}