package pathfinding
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.utils.Color;

	public class Grid
	{
		private var _cellsPerPoint:int;
		private var _cellsX:int;
		private var _cellsY:int;
		private var _cells:Vector.<int>;

		private var _worldBounds:Rectangle;

		public function Grid(worldBounds:Rectangle, cellsPerPoint:int=1)
		{
			_cellsPerPoint=cellsPerPoint;

			_worldBounds=worldBounds.clone();

			_cellsX=Math.ceil(_worldBounds.width / _cellsPerPoint);
			_cellsY=Math.ceil(_worldBounds.height / _cellsPerPoint);
			_cells=new Vector.<int>(_cellsX * _cellsY, true);
		}

		public function gridToWorldSpace(x:int, y:int):Point
		{
			return new Point(_worldBounds.x + (x + 0.5) * _cellsPerPoint, _worldBounds.y + (y + 0.5) * _cellsPerPoint);
		}

		public function worldToGridSpace(x:Number, y:Number, result:Point=null):Point
		{
			if (!result)
			{
				result=new Point();
			}

			result.x=Math.floor((x - _worldBounds.x) / _cellsPerPoint);
			result.y=Math.floor((y - _worldBounds.y) / _cellsPerPoint);
			return result;
		}

		public function isValid(x:int, y:int):Boolean
		{
			return x >= 0 && x < _cellsX && y >= 0 && y < _cellsY;
		}

		public function isBlocked(x:int, y:int):Boolean
		{
			// Considering invalid cell as blocked
			var invalid:Boolean=x < 0 || x >= _cellsX || y < 0 || y >= _cellsY;
			if (invalid)
				return true;
			else
				return _cells[y * _cellsX + x] > 0;
		}

		public function get cellsX():int
		{
			return _cellsX;
		}

		public function get cellsY():int
		{
			return _cellsY;
		}

		public function get worldBounds():Rectangle
		{
			return _worldBounds.clone();
		}

		public function get cellsPerPoint():int
		{
			return _cellsPerPoint;
		}

		public function markCircleAsBlocked(centerX:Number, centerY:Number, radius:Number):void
		{
			var minimum:Point=this.worldToGridSpace(centerX - radius, centerY - radius);
			var maximum:Point=this.worldToGridSpace(centerX + radius, centerY + radius);

			var radiusSquared:Number=radius * radius;

			for (var y:int=minimum.y; y <= maximum.y; y++)
			{
				for (var x:int=minimum.x; x <= maximum.x; x++)
				{
					if (!this.isValid(x, y))
						continue;

					var world:Point=this.gridToWorldSpace(x, y);

					var distanceSquared:Number=(centerX - world.x) * (centerX - world.x) + (centerY - world.y) * (centerY - world.y);

					if (distanceSquared < radiusSquared)
						_cells[y * _cellsX + x]++;
				}
			}
		}

		public function markPointAsBlocked(x:Number, y:Number):void
		{
			var gridSpace:Point=this.worldToGridSpace(x, y);
			if (this.isValid(gridSpace.x, gridSpace.y))
				_cells[gridSpace.y * _cellsX + gridSpace.x]++;
		}

		public function unmarkPointAsBlocked(x:Number, y:Number):void
		{
			var gridSpace:Point=this.worldToGridSpace(x, y);
			if (this.isValid(gridSpace.x, gridSpace.y))
				_cells[gridSpace.y * _cellsX + gridSpace.x]--;
		}

		public function loadFromArray(ar:Array):void
		{
			for (var i:int=0; i < ar[0].length; ++i)
			{
				for (var j:int=0; j < ar.length; ++j)
				{
					if (!isValid(i, j))
						continue;
					if (ar[j][i] == 1)
					{
						_cells[j * _cellsX + i]++;
					}
				}
			}
		}

		public function loadFromBitmapData(bitmapData:BitmapData):void
		{
			for (var i:int=0; i < bitmapData.width; ++i)
			{
				for (var j:int=0; j < bitmapData.height; ++j)
				{
					if (!isValid(i, j))
						continue;
					if (Color.getRed(bitmapData.getPixel(i, j)) > 3)
						_cells[j * _cellsX + i]++;
				}
			}
		}
	}
}
