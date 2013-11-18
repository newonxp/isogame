package pathfinding {
    import de.polygonal.ds.IntHashSet;
    import de.polygonal.ds.IntHashTable;
    import de.polygonal.ds.PriorityQueue;

    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;
    import flash.utils.setInterval;
	
    import pathfinding.Path;

    public class JumpPointSearch {
        private static const sides:Vector.<Point> = new <Point>[
            new Point( 1,  1),
            new Point( 1, -1),
            new Point(-1,  1),
            new Point(-1, -1),
            new Point( 0,  1),
            new Point( 0, -1),
            new Point( 1,  0),
            new Point(-1,  0)
        ];

        private var _world:Grid;
        private var _jumps:int;

        public function JumpPointSearch(grid:Grid) {
            _world = grid;
        }
		
        private function nodeHeuristic(start:Node, end:Node):int {
            // manhattanHeuristic
            return Math.abs(end.x - start.x) + Math.abs(end.y - start.y);
        }
		
        private function blocked(x:int, y:int):Boolean {
            if (_world.isBlocked(x, y)) {
                return true;
            }
			
            return false;
        }
		
        private function nodeNeighbours(current:Node, neighbours:Vector.<Node>):void {
            if (!current.parent) {
                for (var i:int = 0; i < 8; i++) {
					var potentialX:int = current.x + sides[i].x;
					var potentialY:int = current.y + sides[i].y;
                    if (!_world.isBlocked(potentialX, potentialY)) {
						neighbours.push(Node.pooledNode(potentialX, potentialY));
					}
                }
				return;
            }
			
            var directionX:int = Math.min(Math.max(-1, current.x - current.parent.x), 1);
			var directionY:int = Math.min(Math.max(-1, current.y - current.parent.y), 1);
			
            if (directionX != 0 && directionY != 0) {
                if (!_world.isBlocked(current.x, current.y + directionY)) {
                    neighbours.push(Node.pooledNode(current.x, current.y + directionY));
                }
                if (!_world.isBlocked(current.x + directionX, current.y)) {
                    neighbours.push(Node.pooledNode(current.x + directionX, current.y));
                }
                if (!_world.isBlocked(current.x, current.y + directionY) || 
                    !_world.isBlocked(current.x + directionX, current.y)) {
                    neighbours.push(Node.pooledNode(current.x + directionX, current.y + directionY));
                }
                if (_world.isBlocked(current.x - directionX, current.y) && 
                    !_world.isBlocked(current.x, current.y + directionY)) {
                    neighbours.push(Node.pooledNode(current.x - directionX, current.y + directionY));
                }
                if (_world.isBlocked(current.x, current.y - directionY) && !_world.isBlocked(current.x + directionX, current.y)) {
                    neighbours.push(Node.pooledNode(current.x + directionX, current.y - directionY));
                }
            }
            else
            {
                if(directionX == 0) {
                    if (!_world.isBlocked(current.x, current.y + directionY)) {
                        if (!_world.isBlocked(current.x, current.y + directionY)) {
                            neighbours.push(Node.pooledNode(current.x, current.y + directionY));
                        }
                        if (_world.isBlocked(current.x + 1, current.y)) {
                            neighbours.push(Node.pooledNode(current.x + 1, current.y + directionY));
                        }
                        if (_world.isBlocked(current.x - 1, current.y)) {
                            neighbours.push(Node.pooledNode(current.x - 1, current.y + directionY));
                        }
                    }
                }
                else {
                    if (!_world.isBlocked(current.x + directionX, current.y)) {
                        if (!_world.isBlocked(current.x + directionX, current.y)) {
                            neighbours.push(Node.pooledNode(current.x + directionX, current.y));
                        }
                        if (_world.isBlocked(current.x, current.y + 1)) {
                            neighbours.push(Node.pooledNode(current.x + directionX, current.y + 1));
                        }
                        if (_world.isBlocked(current.x, current.y - 1)) {
                            neighbours.push(Node.pooledNode(current.x + directionX, current.y - 1));
                        }
                    }
                }
            }
        }

        private function jump(currentX:int, currentY:int, directionX:int, directionY:int, start:Node, end:Node):Node
        {
            _jumps++;
			
            var nextX:int = currentX + directionX;
            var nextY:int = currentY + directionY;
			
            if (_world.isBlocked(nextX, nextY)) {
                return null;
            }
			
            if (nextX == end.x && nextY == end.y) {
                return Node.pooledNode(nextX, nextY);
            }
			
            var offsetX:int = nextX;
            var offsetY:int = nextY;
			
            if (directionX != 0 && directionY != 0) {
                while (true) {
                    if (!_world.isBlocked(offsetX - directionX, offsetY + directionY) && 
                         _world.isBlocked(offsetX - directionX, offsetY) ||
                        !_world.isBlocked(offsetX + directionX, offsetY - directionY) && 
                         _world.isBlocked(offsetX, offsetY - directionY))
                    {
                        return Node.pooledNode(offsetX, offsetY);
                    }
					
                    /// unrollat ovo, mozda ima vise smisla da zajedno steppaju - prije se moze dogodit da se otkaze!
                    if (jump(offsetX, offsetY, directionX, 0, start, end) != null ||
                        jump(offsetX, offsetY, 0, directionY, start, end) != null)
                    {
                        return Node.pooledNode(offsetX, offsetY);
                    }
					
                    offsetX += directionX;
                    offsetY += directionY;
					
                    if (_world.isBlocked(offsetX, offsetY)) {
                        return null;
                    }
					
                    if (offsetX == end.x && offsetY == end.y) {
                        return Node.pooledNode(offsetX, offsetY);
                    }
                }
            } else {
                /// TODO optimizirati viskove - stvari se ponavljau kroz petlje
                if (directionX != 0) {
                    while (true) {
                        if (!_world.isBlocked(offsetX + directionX, nextY + 1) && 
                             _world.isBlocked(offsetX, nextY + 1) ||
                            !_world.isBlocked(offsetX + directionX, nextY - 1) && 
                             _world.isBlocked(offsetX, nextY - 1))
                        {
                            return Node.pooledNode(offsetX, nextY);
                        }
						
                        offsetX += directionX;
						
                        if (_world.isBlocked(offsetX, nextY)) {
                            return null;
                        }
                        if (offsetX == end.x && nextY == end.y) {
                            return Node.pooledNode(offsetX, nextY);
                        }
                    }
                }
                else {
                    while (true) {
                        if (!_world.isBlocked(nextX + 1, offsetY + directionY) && 
                             _world.isBlocked(nextX + 1, offsetY) ||
                            !_world.isBlocked(nextX - 1, offsetY + directionY) && 
                             _world.isBlocked(nextX - 1, offsetY))
                        {
                            return Node.pooledNode(nextX, offsetY);
                        }
						
                        offsetY += directionY;
						
                        if (_world.isBlocked(nextX, offsetY)) {
                            return null;
                        }
                        if (nextX == end.x && offsetY == end.y) {
                            return Node.pooledNode(nextX, offsetY);
                        }
                    }
                }
            }
			
            return jump(nextX, nextY, directionX, directionY, start, end);
        }

        private function identifySuccessors(current:Node, start:Node, end:Node):Vector.<Node> {
            var successors:Vector.<Node> = new Vector.<Node>();
            var neighbours:Vector.<Node> = new Vector.<Node>();
            nodeNeighbours(current, neighbours);

            for each (var neighbour:Node in neighbours) {
                // Direction from current node to neighbor:
                var directionX:int = Math.min(Math.max(-1, neighbour.x - current.x), 1);
                var directionY:int = Math.min(Math.max(-1, neighbour.y - current.y), 1);

                // Try to find a node to jump to:
                var jumpPoint:Node = jump(current.x, current.y, directionX, directionY, start, end);

                // If found add it to the list:
                if (jumpPoint) successors.push(jumpPoint);
            }
			
            return successors;
        }

        private var closedSet:IntHashSet;
        private var openSet:PriorityQueue;

        public function findPath(start:Point, end:Point):Path {
            _jumps = 0;

            Node.dumpPool();
			
            var time:int = getTimer();
			
            var pathfindWorldStart:Point = _world.worldToGridSpace(start.x, start.y);
            var pathfindWorldEnd:Point = _world.worldToGridSpace(end.x, end.y);
			
            if (!closedSet) closedSet = new IntHashSet(512 * 4);
            else            closedSet.clear(false);
            
            if (!openSet) openSet = new PriorityQueue(true, 512 * 4);
            else          openSet.clear(false);

            var startNode:Node = Node.pooledNode(pathfindWorldStart.x, pathfindWorldStart.y);
            var endNode:Node = Node.pooledNode(pathfindWorldEnd.x, pathfindWorldEnd.y);
			
            /// it the end is blocked, no way of reaching it...
            if (_world.isBlocked(pathfindWorldEnd.x, pathfindWorldEnd.y)) {
                return null;
            }
			
            startNode.priority = startNode.f = nodeHeuristic(startNode, endNode);
            openSet.enqueue(startNode);
			
            var iterations:int = 0;

            var fastNext:Node = null;
			
            while (!openSet.isEmpty() || fastNext) {
                iterations++;
				
                var current:Node = fastNext ? fastNext : openSet.dequeue() as Node;
                fastNext = null;
				
                if (current.equals(endNode)) {
                    var foundPath:Path = new Path();
                    reconstructPath(current, foundPath);
                    return foundPath;
                }
				
                closedSet.set(current.uniqueLocation());
				
                var successors:Vector.<Node> = identifySuccessors(current, startNode, endNode);
                var count:int = successors.length;
				
                for (var i:int = 0; i < count; ++i) {
                    var jumpNode:Node = successors[i];

                    if (closedSet.contains(jumpNode.uniqueLocation())) {
                        continue;
                    }
					
                    var tentativeGScore:Number = current.g + current.distanceTo(jumpNode);
					
                    var openSetNeighbor:Boolean = openSet.contains(jumpNode);
					
                    if (!openSetNeighbor || tentativeGScore < jumpNode.g) {
                        jumpNode.parent = current;
                        jumpNode.g = tentativeGScore;
                        jumpNode.f = jumpNode.g + nodeHeuristic(jumpNode, endNode);
						
                        if (!openSetNeighbor) {
                            jumpNode.priority = jumpNode.f;
                            openSet.enqueue(jumpNode);
                        }
                        else {
                            openSet.reprioritize(jumpNode, jumpNode.f);
                        }
                    }
                }
            }
			
            return null;
        }
		
        private function reconstructPath(currentNode:Node, foundPath:Path):void {
            var node:Node = currentNode;
			
            while (node) {
                foundPath.addWaypoint(_world.gridToWorldSpace(node.x, node.y));
                node = node.parent;
            }
			
            foundPath.reverse();
        }

    }
}

import de.polygonal.ds.Prioritizable;

internal class Node implements Prioritizable {
    public var x:int;
    public var y:int;

    public var g:Number;
    public var f:Number;

    public var parent:Node;

    // Used by Prioritizable, don't remove.
    public var priority:Number;
    public var position:int;

    public function Node(x:int, y:int) {
        this.x = x;
        this.y = y;
        g = 0;
        f = 0;
    }

    public function distanceTo(other:Node):Number {
        return Math.sqrt((other.x - x) * (other.x - x) +
                         (other.y - y) * (other.y - y));
    }

    public function uniqueLocation():int {
        return calculateUniqueLocation(x, y);
    }

    public function equals(other:Node):Boolean {
        return other.x == this.x && other.y == this.y;
    }

    public static function calculateUniqueLocation(x:int, y:int):int {
        /// yeah, this will bite me one day...
        return x + y * 46340;
    }

    private static var _pool:Vector.<Node>;
    private static var _poolAvailable:Vector.<Node>;
    
    public static function pooledNode(x:int, y:int):Node {
        if (!_poolAvailable || _poolAvailable.length == 0) {
            var newNode:Node = new Node(x, y);
            _pool.push(newNode);
            return newNode;
        }
        else {
            var oldNode:Node = _poolAvailable.pop();
            oldNode.x = x;
            oldNode.y = y;
            oldNode.f = oldNode.g = 0;
            oldNode.parent = null;
            return oldNode;
        }
    }

    public static function dumpPool():void {
        _poolAvailable = _pool;
        _pool = new Vector.<Node>();
    }
}

