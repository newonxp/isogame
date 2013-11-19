package utils
{
	import entities.BasicObject;

	import starling.display.Sprite;
	import starling.events.Event;

	import windows.Game;

	public class ShotsManager extends Sprite
	{
		private var _shots:Vector.<Object>

		public function ShotsManager()
		{
			_shots=new Vector.<Object>
			Game.windowsManager.gameInstance.scene.addEventListener(Event.ENTER_FRAME, onEnterFrame)
		}

		public function addShot(obj:BasicObject, directionX:Number, directionY:Number):void
		{
			var shot:Object=new Object()
			shot.obj=obj
			shot.dirX=directionX
			shot.dirY=directionY

			_shots.push(shot)
			return
		}

		public function removeShot(obj:BasicObject):void
		{
			for (var i:int=0; i < _shots.length; i++)
			{
				if (_shots[i].obj == obj)
				{
					_shots.splice(i, 1)
					break
				}
			}
		}

		private function onEnterFrame(e:Event):void
		{
			for (var i:int=0; i < _shots.length; i++)
			{
				_shots[i].obj.x+=_shots[i].dirX * 2
				_shots[i].obj.y+=_shots[i].dirY * 2
				_shots[i].obj.tick()
			}
		}

		private function refreshShots():void
		{

		}

		public function remove():void
		{
			Game.windowsManager.gameInstance.scene.removeEventListener(Event.ENTER_FRAME, onEnterFrame)
		}

	}
}


