package utils
{


	import entities.Cell;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import pathfinding.Grid;
	import pathfinding.Path;
	import pathfinding.Pathfinder;

	import windows.Game;

	public class Pathfinder
	{
		private var _grid:Grid;
		private var _pathfinder:pathfinding.Pathfinder;
		private var _algorithm:String;
		private var _target:Point;

		public function Pathfinder()
		{

		}

		public function findPath(collisionMap:Array, start:Point, end:Point):Object
		{
			_grid=new Grid(new Rectangle(0, 0, collisionMap[0].length, collisionMap.length));
			_grid.loadFromArray(collisionMap);
			_pathfinder=new pathfinding.Pathfinder(_grid);
			var path:Path=_pathfinder.findPath(start, end, pathfinding.Pathfinder.ALGORITHM_JUMP_POINT_SEARCH);
			if (path != null)
			{
				return convertPath(path.points, path.pathLength)
			}
			else
			{
				return null
			}
		}

		private function convertPath(points:Vector.<Point>, length:Number=0):Object
		{
			var obj:Object=new Object()
			var arr:Array=new Array()
			for (var i:int=0; i < points.length; i++)
			{
				points[i].x=Math.floor(points[i].x) * Config.cell_size
				points[i].y=Math.floor(points[i].y) * Config.cell_size
				arr.push(points[i])
			}
			obj.path=arr
			obj.length=length
			return obj
		}

		public function convertVectorPathToCells(path:Array):Array{
			var newPath:Array = convertPathToCells(path)
			var xArray:Array
			var yArray:Array
			//trace(newPath)
			var newPathPerPoint:Array = new Array()
			for(var i:int=0;i<newPath.length-1;i++){
				xArray = getArrayFromKeyPoints(newPath[i].x,newPath[i+1].x,i)
				yArray	= getArrayFromKeyPoints(newPath[i].y,newPath[i+1].y,i)
				if(xArray.length==yArray.length){
					newPathPerPoint=newPathPerPoint.concat(createCellArray(xArray,yArray,true))
				}
				else if(xArray.length>yArray.length){
					newPathPerPoint=newPathPerPoint.concat(createCellArray(xArray,yArray))
				}
				else if(yArray.length>xArray.length){
					newPathPerPoint=newPathPerPoint.concat(createCellArray(yArray,xArray,false,true))
				}
			}
			return newPathPerPoint
		}
		private function convertPathToCells(path:Array):Array{
			var newPath:Array = new Array()
			for(var i:int = 0;i<path.length;i++){
				newPath.push(Game.windowsManager.gameInstance.scene.getCellAtCoords(path[i].x,path[i].y))
			}
			return newPath
		}	
		private function getArrayFromKeyPoints(first:int,second:int,stepNo:int=0):Array{
			var delta:int= second-first
			var myArray:Array = new Array()
			if(stepNo==0){
				myArray.push(first)
			}
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
		private function createCellArray(long:Array,short:Array,similar:Boolean = false,reverse:Boolean=false):Array{
			var myArray:Array = new Array()
			for(var i:int=0;i<long.length;i++)
			{
				if(!similar){
					if(!reverse){
						myArray.push(Game.windowsManager.gameInstance.scene.getCellAt(long[i],short[0]))
					}else{
						myArray.push(Game.windowsManager.gameInstance.scene.getCellAt(short[0],long[i]))
					}
				}else{
					myArray.push(Game.windowsManager.gameInstance.scene.getCellAt(long[i],short[i]))
				}
			}
			return myArray
		}

	}
}


