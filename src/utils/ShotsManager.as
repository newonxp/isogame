package utils
{
	import entities.BasicObject;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import starling.display.Sprite;
	import starling.events.Event;

	import windows.Game;

	public class ShotsManager extends Sprite
	{
		private var _shots:Vector.<Object>
		private var _timer:Timer
		public function ShotsManager()
		{
			_shots=new Vector.<Object>
			_timer = new Timer(50,0)
			_timer.addEventListener(TimerEvent.TIMER,onTick)
			_timer.start()
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

		private function onTick(e:TimerEvent):void
		{
			for (var i:int=0; i < _shots.length; i++)
			{
				_shots[i].obj.x+=_shots[i].dirX * 4
				_shots[i].obj.y+=_shots[i].dirY * 4
				_shots[i].obj.tick()
			}
		}

		private function refreshShots():void
		{

		}

		public function remove():void
		{
			_timer.stop()
			_timer.removeEventListener(TimerEvent.TIMER,onTick)
			_timer = null
		}

	}
}


