package com.game
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Tab extends Sprite
	{
		private var _tabNameText:TextField;
		private var _nameColor:uint;
		private var _bgColor:uint;
		private var _wgap:Number;
		private var _hgap:Number;
		public function Tab(tabName:String = "",nameColor:uint = 0xffffff, bgColor:uint = 0xBDACA2,fontSize:uint = 12,wgap:Number = 0, hgap:Number = 0)
		{
			_nameColor = nameColor;
			_bgColor = bgColor;
			_wgap = wgap;
			_hgap = hgap;
			_tabNameText = new TextField();
			_tabNameText.selectable = false;
			_tabNameText.mouseEnabled = false;
			_tabNameText.antiAliasType = flash.text.AntiAliasType.NORMAL;
			_tabNameText.autoSize =  TextFieldAutoSize.LEFT;
			var tf:TextFormat = _tabNameText.getTextFormat();
			tf = _tabNameText.getTextFormat();
			tf.color = _nameColor;
			tf.size = fontSize;
			tf.font = "Leelawadee";
			_tabNameText.defaultTextFormat = tf;
			_tabNameText.setTextFormat(tf);
			addChild(_tabNameText);
			setTabName(tabName);
		}
		
		public function setTabName(name:String):void{
			_tabNameText.text = name;
			resize();
		}
		
		public function resize():void{
			var cwidth:Number = 0;
			var cheight:Number = 0;
			cwidth = _tabNameText.textWidth + _wgap*2;
			cheight = _tabNameText.textHeight + _hgap*2;
			_tabNameText.y = (cheight - _tabNameText.textHeight)/2 -2;
			_tabNameText.x = (cwidth - _tabNameText.textWidth)/2;
			graphics.clear();
			graphics.beginFill(_bgColor,1);
			graphics.drawRoundRect(0,0,cwidth,cheight,10,10);
			graphics.endFill();

		}
	}
}