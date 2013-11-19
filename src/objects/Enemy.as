package objects
{
	import as3isolib.display.scene.IsoScene;

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.motionPaths.LinePath2D;

	import entities.BasicObject;
	import entities.Bounds;
	import entities.Cell;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	import sprites.SpritesPack;

	import windows.Game;

	public class Enemy extends BasicObject
	{
		private var _timer:Timer
		private var _startPoint:Cell
		private var _endPoint:Cell
		private var _there:Boolean=true
		private var _pathStage:int=0
		private var _path:LinePath2D

		public function Enemy(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null, endPoint:Cell=null, delay:Number=0)
		{
			_timer=new Timer(delay, 1)
			_timer.addEventListener(TimerEvent.TIMER, onTimerComplete)
			_startPoint=cell
			_endPoint=endPoint
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 10)
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, 0, 0, bounds, cell, scene, spritesPack, false, true, true, true);
			startWait()
			type=Config.enemy
		}

		private function startWait():void
		{
			trace("startWait")
			_timer.start()
		}

		private function onTimerComplete(e:TimerEvent):void
		{
			walkTo(new Point(_startPoint.x, _startPoint.y), new Point(_endPoint.x, _endPoint.y))
		}

		override public function walkFinished():void
		{
			trace("walkFinished")
			cell.blocked=false
			cell=_endPoint
			_endPoint=_startPoint
			_startPoint=cell
			_pathStage=0
			startWait()
		}

		override public function collide(target:BasicObject):void
		{
			if (target.type == Config.fireball)
			{
				trace("Столкнулись с файрболлом")
				remove()
			}
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


