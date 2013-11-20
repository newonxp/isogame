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
			_timer.start()
		}

		private function onTimerComplete(e:TimerEvent):void
		{
			walkTo(new Point(_startPoint.x, _startPoint.y), new Point(_endPoint.x, _endPoint.y))
		}

		override public function walkFinished():void
		{
			cell=_endPoint
			_endPoint=_startPoint
			_startPoint=cell
			_pathStage=0
			startWait()
		}

		override public function walkTo(start:Point, end:Point):void{


			var path:Object=Game.windowsManager.gameInstance.scene.getPath(start, end, false)
			if (path != null)
			{
				var newPath:Array = convertPathToCells(path.path)
				var xArray:Array
				var yArray:Array
				//trace(newPath)
				//var newPath:Array = new Array()
				for(var i:int=0;i<newPath.length-1;i++){
					xArray = getArrayFromKeyPoints(newPath[i].x,newPath[i+1].x)
					yArray	= getArrayFromKeyPoints(newPath[i].y,newPath[i+1].y)
					if(xArray.length==yArray.length){
						trace("Orient both")
						createCellArray(xArray,yArray,true)
					}
					else if(xArray.length>yArray.length){
						trace("Orient x")
						createCellArray(xArray,yArray)
					}
					else if(yArray.length>xArray.length){
						trace("Orient y")
						createCellArray(yArray,xArray,false,true)
					}
				}
			}
		}
		private function createCellArray(long:Array,short:Array,similar:Boolean = false,reverse:Boolean=false){
			var myArray:Array = new Array()
			for(var i:int=0;i<long.length;i++)
			{
				if(!similar){
					if(!reverse){
						myArray.push([long[i],short[0]])
					}else{
						myArray.push([short[0],long[i]])
					}
				}else{
					myArray.push([long[i],short[i]])
				}
			}
			trace(myArray)
		}
		private function getArrayFromKeyPoints(first:int,second:int):Array{
			var delta:int= second-first
			var myArray:Array = new Array()
			myArray.push(first)
			for(var i:int=0;i<Math.abs(delta)-1;i++)
			{
				if(delta<0){
					myArray.push(first-=1)
				}else{
					myArray.push(first+=1)
				}
			}
			myArray.push(second)
			return myArray
		}
		private function convertPathToCells(path:Array):Array{
			var newPath:Array = new Array()
			for(var i:int = 0;i<path.length;i++){
				newPath.push(Game.windowsManager.gameInstance.scene.getCellAtCoords(path[i].x,path[i].y))
			}
			return newPath
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


