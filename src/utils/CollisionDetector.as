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
			_objects=new Vector.<Object>
			Game.windowsManager.addEventListener(Event.ENTER_FRAME, checkCollisions)
		}

		public function registerRect(rect:Rectangle, object:BasicObject):void
		{
			var obj:Object=new Object()
			obj.rect=rect
			obj.target=object
			_objects.push(obj)
		}

		public function removeRect(object:BasicObject):void
		{
			for (var i:int=0; i < _objects.length; i++)
			{
				if (_objects[i].target == object)
				{
					_objects.splice(i, 1)
					break
				}
			}
		}

		public function updateRect(x:Number, y:Number, object:BasicObject):void
		{
			for (var i:int=0; i < _objects.length; i++)
			{
				if (_objects[i].target == object)
				{
					_objects[i].rect.x=x
					_objects[i].rect.y=y
					break
				}
			}
		}

		private function checkCollisions(e:Event):void
		{
			for (var i:int=0; i < _objects.length; i++)
			{
				var collideObjects:Vector.<Object>=new Vector.<Object>
				var cObj:Object=_objects[i]
				var cRect:Rectangle=_objects[i].rect
				for (var a:int=0; a < _objects.length; a++)
				{
					if (_objects[a] != cObj)
					{
						if (cRect.intersects(_objects[a].rect))
						{
							var obj:Object=new Object()
							obj.target1=_objects[i].target
							obj.target2=_objects[a].target
							collideObjects.push(obj)
						}
					}
				}
				for (var b:int=0; b < collideObjects.length; b++)
				{
					collideObjects[b].target1.collide(collideObjects[b].target2)
					collideObjects[b].target2.collide(collideObjects[b].target1)
				}
			}
		}

		public function remove():void
		{
			Game.windowsManager.removeEventListener(Event.ENTER_FRAME, checkCollisions)
		}

	}
}


