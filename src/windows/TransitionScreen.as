package windows
{
	import com.greensock.TweenMax;

	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class TransitionScreen extends BasicWindow
	{
		private var _callback:Function
		private var _container:Sprite
		public function TransitionScreen(callback:Function)
		{
			_callback = callback
			super();
		}
		override public function init():void{
			trace("Добавлен")
			_container = new Sprite()
			var rectangle:Shape = new Shape; // initializing the variable named rectangle
			rectangle.graphics.beginFill(0x000000); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect(0, 0, 1024,768); // (x spacing, y spacing, width, height)
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			_container.addChild(rectangle);
			addChild(_container)
			TweenMax.from(_container,0.6,{alpha:0,onComplete:runCallback})
		}
		private function runCallback():void{
			_callback()
		}
		override public function remove():void{
			trace("Удаляют")
			TweenMax.to(_container,0.6,{alpha:0,onComplete:function():void{animatedOut()}})
		}
		private function animatedOut():void{
			super.remove()
		}

	}
}

