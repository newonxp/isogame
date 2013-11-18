package entities
{
	import as3isolib.display.scene.IsoScene;

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.motionPaths.LinePath2D;

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
		private var _path:Object

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
			_timer.start()
		}

		private function onTimerComplete(e:TimerEvent):void
		{
			walkTo()
		}

		public function walkTo():void
		{
			_path=Game.windowsManager.gameInstance.scene.getPath(new Point(_startPoint.x, _startPoint.y), new Point(_endPoint.x, _endPoint.y), false)
			if (_path != null)
			{
				cell.blocked=false
				var path:LinePath2D=new LinePath2D(_path.path);
				path.addFollower(this);
				TweenMax.to(path, _path.length * Config.playerSpeed, {progress: 1, ease: com.greensock.easing.Linear.easeNone, onComplete: checkPath});
			}
		}

		override public function collide(target:BasicObject):void
		{
			if (target.type == Config.fireball)
			{
				remove()
			}
		}

		private function checkPath():void
		{
			cell.blocked=false
			cell=_endPoint
			_endPoint=_startPoint
			_startPoint=cell
			_pathStage=0
			startWait()

		}
	}
}
