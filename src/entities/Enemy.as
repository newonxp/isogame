package entities
{
	import as3isolib.display.scene.IsoScene;

	import com.greensock.TweenLite;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	import org.osmf.events.TimeEvent;

	import sprites.SpritesPack;

	import windows.Game;

	public class Enemy extends BasicObject
	{
		private var _timer:Timer
		private var _startPoint:Cell
		private var _endPoint:Cell
		private var _there:Boolean=true
		private var _pathStage:int=0
		private var _path:Vector.<Point>

		public function Enemy(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null, endPoint:Cell=null, delay:Number=0)
		{
			_timer=new Timer(delay, 1)
			_timer.addEventListener(TimerEvent.TIMER, onTimerComplete)
			_startPoint=cell
			_endPoint=endPoint
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 10)
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, 10, bounds, cell, scene, spritesPack);
			startWait()
			Game.windowsManager.gameInstance.scene.collisionDetector.registerRect(new Rectangle(x, y, Config.cell_size, Config.cell_size), this)
			type=Config.enemy
		}

		private function startWait():void
		{
			_timer.start()
		}

		private function onTimerComplete(e:TimerEvent):void
		{
			walkTo()
		}

		public function walkTo():void
		{
			_path=Game.windowsManager.gameInstance.scene.getPath(new Point(_startPoint.x, _startPoint.y), new Point(_endPoint.x, _endPoint.y), false)
			checkPath()
		}

		private function gotoToNextStep(x:Number, y:Number):void
		{
			TweenLite.to(this, 0.5, {x: x, y: y, z: this.z, onComplete: checkPath})
		}

		private function checkPath():void
		{
			if (_pathStage < _path.length)
			{
				gotoToNextStep(_path[_pathStage].x * Config.cell_size, _path[_pathStage].y * Config.cell_size)
				_pathStage++
			}
			else
			{
				cell=_endPoint
				_endPoint=_startPoint
				_startPoint=cell
				_pathStage=0
				startWait()
			}
		}

		override public function moveTo(x:Number=0, y:Number=0, z:Number=0):void
		{
			Game.windowsManager.gameInstance.scene.collisionDetector.updateRect(new Rectangle(x, y, Config.cell_size, Config.cell_size), this)
			super.moveTo(x, y, z)
		}
	}
}
