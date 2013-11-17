package utils
{
	import entities.BasicObject;

	import flash.events.Event;
	import flash.geom.Rectangle;

	import windows.Game;

	public class CollisionDetector
	{
		private var _objects:Vector.<Object>

		public function CollisionDetector()
		{
			var rect:Rectangle=new Rectangle(0, 0, 20, 20)
			var rect2:Rectangle=new Rectangle(10, 10, 20, 20)
			trace(rect.intersects(rect2))
			_objects=new Vector.<Object>
			Game.windowsManager.addEventListener(Event.ENTER_FRAME, checkCollisions)
		}

		public function registerRect(rect:Rectangle, object:BasicObject):void
		{
			var obj:Object=new Object()
			obj.rect=rect
			obj.target=object
			_objects.push(obj)
			trace(_objects.length)
		}

		public function updateRect(rect:Rectangle, object:BasicObject):void
		{

			for (var i:int=0; i < _objects.length; i++)
			{
				if (_objects[i].target == object)
				{
					_objects[i].rect=rect
					break
				}
			}
		}

		private function checkCollisions(e:Event):void
		{
			for (var i:int=0; i < _objects.length; i++)
			{
				var collideObjects:Vector.<BasicObject>=new Vector.<BasicObject>
				var cObj:Object=_objects[i]
				var cRect:Rectangle=_objects[i].rect
				for (var a:int=0; a < _objects.length; a++)
				{
					if (_objects[a] != cObj)
					{
						if (cRect.intersects(_objects[a].rect))
						{
							collideObjects.push(_objects[a].target)
						}
							//trace(cRect.intersects(_objects[a].rect))
					}
				}
				for (var b:int=0; b < collideObjects.length; b++)
				{
					collideObjects[b].collide(cObj.target)
				}

			}

		}

	}
}
