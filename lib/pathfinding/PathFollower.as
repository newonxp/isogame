package pathfinding
{
	import flash.geom.Point;

    public class PathFollower
	{
		private var _path:Path;
		private var _distance:Number;
		private var _dirty:Boolean;
		private var _cachePoint:Point;

		public function PathFollower(path:Path) {
			_distance = 0;
			_path = path;

            _dirty = true;
		}
		
		public function advance(distance:Number):void {
			_distance += distance;
            _dirty = true;
		}
		
		public function get currentLocation():Point {
			// Computation is expansive, try to cache
			if (!_dirty) {
				return _cachePoint;
			}

			var waypointCount:int = _path.waypointCount;
			var distance:Number = _distance;
			
			var location:Point;

			if (waypointCount >= 1) {
				location = _path.waypointAtIndex(0);
			}
			
			if (waypointCount >= 2) {
				var last:Point = _path.waypointAtIndex(0);
				for (var i:int = 1; i < waypointCount; i++) {
					var current:Point = _path.waypointAtIndex(i);
					var currentDistance:Number = Point.distance(last, current);
					distance -= currentDistance;
					
					if (distance < 0) {
						var ratio:Number = -distance / currentDistance;
						location = new Point();
						location.x = last.x * (ratio) + current.x * (1 - ratio);
						location.y = last.y * (ratio) + current.y * (1 - ratio);
						break;
					}
					
					last = current;
				}
				
				if (distance > 0) {
					location = _path.waypointAtIndex(waypointCount - 1);
				}
			}
			
			_dirty = false;
			_cachePoint = location;

			return location;
		}

        public function get arrived():Boolean {
			return _distance >= _path.pathLength;
		}

        public function get distance():Number {
            return _distance;
        }

        public function get path():Path {
            return _path;
        }
    }

}