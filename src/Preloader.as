package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Preloader extends Sprite
	{
		[Embed ( source = "../resources/glob/ui/loading_screen.swf", symbol="loading_screen" ) ] private var loading_screen:Class
		private var _loading_screen:DisplayObjectContainer 
		private var _preloader:DisplayObjectContainer
		private var _preloader_fill:DisplayObject
		private var _preloader_mask:DisplayObject
		private var _flag_eng:MovieClip
		private var _flag_ru:MovieClip

		public function Preloader()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,init)
		}
		private function init(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,init)
			_loading_screen  = new loading_screen()
			addChild(_loading_screen)
			_preloader = _loading_screen.getChildByName("preloader") as DisplayObjectContainer
			_preloader_fill = _preloader.getChildByName("preloader_fill")
			_preloader_mask = _preloader.getChildByName("preloader_mask")
			_preloader_fill.mask = _preloader_mask
			_preloader_mask.x= _preloader_fill.x-_preloader_mask.width+40
			_preloader.alpha=0

			_flag_eng = _loading_screen.getChildByName("flag_eng") as MovieClip
			_flag_ru = _loading_screen.getChildByName("flag_ru")as MovieClip
			_flag_eng.buttonMode = true
			_flag_ru.buttonMode = true
			_flag_eng.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver)
			_flag_eng.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut)
			_flag_eng.addEventListener(MouseEvent.CLICK,onMouseClickEng)

			_flag_ru.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver)
			_flag_ru.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut)
			_flag_ru.addEventListener(MouseEvent.CLICK,onMouseClickRu)
		}

		private function onMouseOver(e:MouseEvent):void{
			TweenLite.to(e.target,0.3,{scaleX:1.2,scaleY:1.2,ease:com.greensock.easing.Back.easeInOut})
		}
		private function onMouseOut(e:MouseEvent):void{
			TweenLite.to(e.target,0.2,{scaleX:1,scaleY:1,ease:com.greensock.easing.Back.easeOut})
		}
		private function onMouseClickEng(e:MouseEvent):void{
			removeFlags()
		}
		private function onMouseClickRu(e:MouseEvent):void{
			removeFlags()
		}
		private function removeFlags():void{
			_flag_eng.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver)
			_flag_eng.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut)
			_flag_eng.removeEventListener(MouseEvent.CLICK,onMouseClickEng)

			_flag_ru.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver)
			_flag_ru.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut)
			_flag_ru.removeEventListener(MouseEvent.CLICK,onMouseClickRu)
			TweenLite.to(_flag_eng,0.3,{alpha:0,y:_flag_eng.y+50,ease:com.greensock.easing.Back.easeIn})
			TweenLite.to(_flag_ru,0.3,{alpha:0,y:_flag_ru.y+50,delay:0.1,ease:com.greensock.easing.Back.easeIn})

			showPreloader()
		}
		private function showPreloader():void{
			var defY:Number = _preloader.y
			_preloader.y+=100
			TweenLite.to(_preloader,0.3,{alpha:1,y:defY,delay:0.4,ease:com.greensock.easing.Back.easeOut})
		}
		public function setPercents(perc:int = 0):void{
			trace(perc)
		}

	}
}

