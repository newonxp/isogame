package pathfinding
{
    import de.polygonal.ds.IntHashSet;
    import de.polygonal.ds.IntHashTable;
    import de.polygonal.ds.PriorityQueue;

    import flash.geom.Point;

    public class AStar
    {
        private static const sides:Vector.<Point> = new <Point>[
            new Point( 0,  1),
            new Point( 0, -1),
            new Point( 1,  0),
            new Point(-1,  0),
            new Point( 1,  1),
            new Point( 1, -1),
            new Point(-1,  1),
            new Point(-1, -1)
        ];

        private var _world:Grid;

        private var nodes:IntHashTable;

        private var closedSet:IntHashSet;
        private var openSet:PriorityQueue;

        public function AStar(grid:Grid) {
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

        public function findPath(start:Point, end:Point):Path {
            Node.dumpPool();

            var pathfindWorldStart:Point = _world.worldToGridSpace(start.x, start.y);
            var pathfindWorldEnd:Point = _world.worldToGridSpace(end.x, end.y);

            if (!closedSet) closedSet = new IntHashSet(512 * 4);
            else            closedSet.clear(false);
            
            if (!openSet) openSet = new PriorityQueue(true, 512 * 4);
            else          openSet.clear(false);

            if (!nodes) nodes = new IntHashTable(512 * 4);
            else        nodes.clear(false);
			
            var startNode:Node = Node.pooledNode(pathfindWorldStart.x, pathfindWorldStart.y);
            var endNode:Node = Node.pooledNode(pathfindWorldEnd.x,  pathfindWorldEnd.y);
			
            /// it the end is blocked, no way of reaching it...
            if (_world.isBlocked(pathfindWorldEnd.x,  pathfindWorldEnd.y)) {
                return null;
            }
			
            nodes.setIfAbsent(startNode.uniqueLocation(), startNode);
			
            startNode.priority = startNode.f = nodeHeuristic(startNode, endNode);
            openSet.enqueue(startNode);
			
            while (!openSet.isEmpty()) {
                var current:Node = openSet.dequeue() as Node;
                if (current.equals(endNode)) {
                    var foundPath:Path = new Path();
                    reconstructPath(current, foundPath);
                    return foundPath;
                }
				
                closedSet.set(current.uniqueLocation());
				
                for (var i:int = 0; i < 8; i++) {
                    var potentialX:int = current.x + sides[i].x;
                    var potentialY:int = current.y + sides[i].y;
					
                    if (blocked(potentialX, potentialY)) {
                        continue;
                    }
					
                    var uniqueLocation:int = Node.calculateUniqueLocation(potentialX, potentialY);
					
                    if (closedSet.contains(uniqueLocation)) {
                        continue;
                    }
					
                    // First four are straight
                    var distance:Number = (i < 4) ? 1 : Math.SQRT2;
					
                    var tentativeGScore:Number = current.g + distance;
					
                    var openSetNeighbor:Node = nodes.getFront(uniqueLocation) as Node;
					
                    var neighbor:Node = openSetNeighbor;
                    if (!neighbor) {
                        neighbor = Node.pooledNode(potentialX, potentialY);
                        nodes.setIfAbsent(neighbor.uniqueLocation(), neighbor);
                    }
					
                    if (!openSetNeighbor || tentativeGScore < neighbor.g) {
                        neighbor.parent = current;
                        neighbor.g = tentativeGScore;
                        neighbor.f = neighbor.g + nodeHeuristic(neighbor, endNode);
						
                        if (!openSetNeighbor) {
                            neighbor.priority = neighbor.f;
                            openSet.enqueue(neighbor);
                        }
                        else {
                            openSet.reprioritize(neighbor, neighbor.f);
                        }
                    }
                }
            }	
            return null;
        }
		
        private function reconstructPath(currentNode:Node, foundPath:Path):void
        {
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
            oldNode.position = 0;
            oldNode.priority = NaN;
            return oldNode;
        }
    }

    public static function dumpPool():void {
        _poolAvailable = _pool;
        _pool = new Vector.<Node>();
    }
}
