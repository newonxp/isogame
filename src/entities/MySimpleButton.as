package entities
{
	import com.greensock.TweenMax;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class MySimpleButton extends Sprite
	{
		public var _body:MovieClip
		public var _name:String
		public var _enabled:Boolean = true
		public function MySimpleButton(obj:DisplayObjectContainer)
		{
			this.cacheAsBitmap= true
			_body=obj as MovieClip
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)	
		}
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)	
			init()
		}
		public  function init():void
		{
			this.buttonMode=true
			addChild(_body)
			_body.gotoAndStop(1)
			_body.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler)
			_body.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler)
		}

		protected function mouseDownHandler(event:MouseEvent):void
		{
			_body.gotoAndStop(3)
			_body.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler)
			_body.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler)
		}

		protected function mouseUpHandler(event:MouseEvent):void
		{
			_body.gotoAndStop(2)
			_body.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler)
			_body.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler)
		}

		protected function mouseOverHandler(event:MouseEvent):void
		{
			_body.gotoAndStop(2)
			_body.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler)
			_body.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler)
		}


		protected function mouseOutHandler(event:MouseEvent):void
		{
			_body.gotoAndStop(1)
			_body.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler)
			_body.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler)
		}
		public function over():void{
			_body.gotoAndStop(2)
		}
		public function out():void{
			_body.gotoAndStop(1)
		}
		public function click():void{
			_body.gotoAndStop(3)
		}
		public function disable(grey:Boolean = true):void{
			_enabled = false
			this.mouseChildren=false
			this.mouseEnabled=false
			if(grey){
				TweenMax.to(_body, 0, {colorMatrixFilter:{saturation:0}});
			}
		}
		public function enable():void{
			_enabled = true
			this.mouseChildren=true
			this.mouseEnabled=true
			TweenMax.to(_body, 0, {colorMatrixFilter:{saturation:1}});
		}
	}
}

