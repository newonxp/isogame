package objects
{
	import as3isolib.display.scene.IsoScene;

	import entities.BasicObject;
	import entities.Bounds;
	import entities.Cell;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import sprites.SpritesPack;

	import windows.Game;

	public class Cannon extends BasicObject
	{
		private var _timer:Timer

		public function Cannon(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null, rotate:Number=0, delay:Number=0)
		{

			_timer=new Timer(delay, 0)
			_timer.addEventListener(TimerEvent.TIMER, onTimerComplete)
			_timer.start()
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 60)
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, 0, rotate, bounds, cell, scene, spritesPack, false, true);
			type=Config.cannon
		}

		private function onTimerComplete(e:TimerEvent):void
		{
			fire()
		}

		private function fire():void
		{
			var shiftX:Number
			var shiftY:Number
			if (rotation == 0)
			{
				shiftX=1
				shiftY=0
			}
			else if (rotation == 90)
			{
				shiftX=0
				shiftY=1
			}
			else if (rotation == 180)
			{
				shiftX=-1
				shiftY=0
			}
			else

			{
				shiftX=0
				shiftY=-1
			}
			Game.windowsManager.gameInstance.scene.addFireball(Game.windowsManager.gameInstance.scene.getCellAt(cell.x + shiftX, cell.y + shiftY), shiftX, shiftY)
		}

		override public function remove():void
		{
			_timer.stop()
			_timer.removeEventListener(TimerEvent.TIMER, onTimerComplete)
			_timer=null
			super.remove()
		}

	}
}


