package utils
{


	import flash.geom.Point;
	import flash.geom.Rectangle;

	import pathfinding.Grid;
	import pathfinding.Path;
	import pathfinding.Pathfinder;

	public class Pathfinder
	{
		private var _grid:Grid;
		private var _pathfinder:pathfinding.Pathfinder;
		private var _algorithm:String;
		private var _target:Point;

		public function Pathfinder()
		{

		}

		public function findPath(collisionMap:Array, start:Point, end:Point):Vector.<Point>
		{
			_grid=new Grid(new Rectangle(0, 0, collisionMap[0].length, collisionMap.length));
			_grid.loadFromArray(collisionMap);
			_pathfinder=new pathfinding.Pathfinder(_grid);
			var path:Path=_pathfinder.findPath(start, end, pathfinding.Pathfinder.ALGORITHM_JUMP_POINT_SEARCH);
			if (path != null)
			{
				convertPath(path.points)
				return path.points
			}
			else
			{
				return null
			}
		}

		private function convertPath(points:Vector.<Point>):void
		{
			for (var i:int=0; i < points.length; i++)
			{
				points[i].x=Math.floor(points[i].x)
				points[i].y=Math.floor(points[i].y)
			}
		}


	}
}
