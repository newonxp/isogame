package pathfinding {
	import flash.geom.Point;

    public class Path {
		private var _waypoints:Vector.<Point>;
		private var _dirty:Boolean;
		private var _cacheLength:Number;
        private var _targetPoint:Point;
		
		public function Path(pathPoints:Vector.<Point> = null) {
			_dirty = true;
			_waypoints = pathPoints ? pathPoints : new Vector.<Point>();
		}
		
		public function addWaypoint(point:Point):void {
			_dirty = true;
			_waypoints.push(point);
		}	
		
		public function addWaypointAt(point:Point, index:int):void {
			_dirty = true;
            _waypoints.push(null);
            for (var i:int = _waypoints.length - 1; i > index; i--) {
                if (i == 0) continue;
                _waypoints[i] = _waypoints[i - 1];
            }
            _waypoints[index] = point;
		}
		
		public function removeWaypointAt(index:int):void {
			_waypoints.splice(index, 1);
		}
		
        public function reverse():void {
            _waypoints.reverse();
        }
		
        public function get points():Vector.<Point> {
            return _waypoints.concat();
        }
		
		public function get waypointCount():int {
			return _waypoints.length;
		}
		
		public function waypointAtIndex(index:int):Point {
			return _waypoints[index];
		}
		
		public function get pathLength():Number {
			if (!_dirty) {
				return _cacheLength;
			}
			
			var distance:Number = 0;
			
			if (_waypoints.length >= 2) {
				var last:Point = _waypoints[0];
				for (var i:int = 1; i < _waypoints.length; i++) {
					var current:Point = _waypoints[i];
					distance += Point.distance(last, current);
					last = current;
				}
			}
			
			_cacheLength = distance;
			_dirty = false;
			
			return distance;
		}

        public function evenlySpacedWaypoints(distance:Number):Vector.<Point> {
            if (_waypoints.length <= 1) {
                return _waypoints.concat();
            }
			
            var waypoints:Vector.<Point> = new Vector.<Point>();
            var length:Number = this.pathLength;
            var currentPosition:int = _waypoints.length - 1;
            var currentDistance:Number = Point.distance(_waypoints[_waypoints.length - 2], _waypoints[_waypoints.length - 1]);
            var distanceMax:Number = length - currentDistance;
			
            for (var n:Number = length; n > 0; n -= distance)
            {
                while (n < distanceMax)
                {
                    if (currentPosition == 1)
                    {
                        break;
                    }
					
                    currentPosition = Math.max(currentPosition - 1, 1);
					
                    currentDistance = Point.distance(_waypoints[currentPosition], _waypoints[currentPosition - 1]);
                    distanceMax -= currentDistance;
                }
				
                var newPoint:Point = new Point();
				
                var ratio:Number = (n - distanceMax) / currentDistance;
                ratio = Math.max(0, Math.min(ratio, 1));
                var reversedRatio:Number = 1 - ratio;
				
                newPoint.x = _waypoints[currentPosition].x * ratio + _waypoints[currentPosition - 1].x * reversedRatio;
                newPoint.y = _waypoints[currentPosition].y * ratio + _waypoints[currentPosition - 1].y * reversedRatio;
				
                waypoints.push(newPoint);
            }
            waypoints.reverse();
            return waypoints;
        }
		
        public function get origin():Point {
            if (_waypoints.length > 0) {
                return _waypoints[0];
            }
            return null;
        }
		
        public function get destination():Point {
            if (_waypoints.length > 0) {
                return _waypoints[_waypoints.length - 1];
            }
            return null;
        }
		
        public function get targetPoint():Point {
            return _targetPoint;
        }
		
        public function set targetPoint(value:Point):void {
            _targetPoint = value;
        }
    }
}