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

	import utils.Pathfinder;

	import windows.Game;

	public class Enemy extends BasicObject
	{
		private var _pathfinder:Pathfinder
		private var _timer:Timer
		private var _startPoint:Cell
		private var _endPoint:Cell
		private var _there:Boolean=true
		private var _pathStage:int=0
		private var _path:LinePath2D
		private var _newPathPerPoint:Array
		private var _tween:TweenMax
		public function Enemy(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null, endPoint:Cell=null, delay:Number=0)
		{
			_pathfinder = new Pathfinder()
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
			if(_newPathPerPoint==null){
				convertPath(new Point(_startPoint.x, _startPoint.y), new Point(_endPoint.x, _endPoint.y))
				walk()
			}else{
				walk()
			}
		}

		override public function walkFinished():void
		{
			cell=_endPoint
			_endPoint=_startPoint
			_startPoint=cell
			_pathStage=0
			startWait()
		}

		private function walk():void{
			nextStage()
		}

		private function nextStage():void{
			_pathStage++
			if(_newPathPerPoint[_pathStage].blocked==true&&_newPathPerPoint[_pathStage]!=Game.windowsManager.gameInstance.scene._player.cell){
				reverse()
				_pathStage=_newPathPerPoint.length-_pathStage
				startWait()
			}else{
				_tween = TweenMax.to(this,0.5,{x:_newPathPerPoint[_pathStage].x*Config.cell_size,y:_newPathPerPoint[_pathStage].y*Config.cell_size,onComplete:stageCompleted})
			}

		}
		private function stageCompleted():void{
			if(_pathStage!=_newPathPerPoint.length-1){
				nextStage()
			}else{
				reverse()
				_pathStage=0
				startWait()
			}
		}
		private function reverse():void{
			_newPathPerPoint = _newPathPerPoint.reverse()
		}
		private function convertPath(start:Point, end:Point):void{
			var path:Object=Game.windowsManager.gameInstance.scene.getPath(start, end, false)
			if (path != null)
			{
				_newPathPerPoint= _pathfinder.convertVectorPathToCells(path.path)
			}
		}

		override public function collide(target:BasicObject):void
		{
			if (target.type == Config.fireball)
			{
				remove()
			}
		}

		override public function remove():void
		{
			_timer.stop()
			_timer.removeEventListener(TimerEvent.TIMER, onTimerComplete)
			_timer=null
			_tween.kill()
			super.remove()
		}
	}
}


