package pathfinding
{
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class Pathfinder
	{
		public static const ALGORITHM_A_STAR:String="A*";
		public static const ALGORITHM_JUMP_POINT_SEARCH:String="Jump Point Search";
		public static const ALGORITHM_JUMP_POINT_SEARCH_WO_DIAGONALS:String="Jump Point Search";

		private var _jumpPointSearchWoDiagonals:JumpPointSearchWoDiagonals;
		private var _jumpPointSearch:JumpPointSearch;
		private var _aStar:AStar;

		public function Pathfinder(grid:Grid)
		{
			_aStar=new AStar(grid);
			_jumpPointSearch=new JumpPointSearch(grid);
			_jumpPointSearchWoDiagonals=new JumpPointSearchWoDiagonals(grid)
		}

		public function findPath(origin:Point, destination:Point, algorithm:String):Path
		{
			if (algorithm == ALGORITHM_A_STAR)
			{
				return _aStar.findPath(origin, destination);
			}
			else if (algorithm == ALGORITHM_JUMP_POINT_SEARCH)
			{
				return _jumpPointSearch.findPath(origin, destination);
			}
			else if (algorithm == ALGORITHM_JUMP_POINT_SEARCH_WO_DIAGONALS)
			{
				return _jumpPointSearchWoDiagonals.findPath(origin, destination);
			}
			return null;
		}
	}
}
