package entities

{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.events.IsoEvent;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import sprites.SpritesManager;
	import sprites.SpritesPack;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import utils.CollisionDetector;
	import utils.Pathfinder;

	import windows.Game;

	public class BasicScene extends Sprite
	{

		public var _levelName:String

		private var _scene:IsoScene
		private var _view:IsoView

		private var _mapWidth:int
		private var _mapHeight:int

		private var _bg:Quad

		private var _panPoint:Point
		private var _zoom:Number=1

		public var _player:Player

		private var _mouseOverElement:*

		private var _spritesManager:SpritesManager
		private var _tilemap:XML
		private var _map:Array
		private var _collisionMap:Array
		private var _pathfinder:utils.Pathfinder
		private var _render:Boolean=false

		private var _collisionDetector:CollisionDetector

		public function BasicScene()
		{
		}

		public function setLevel(name:String=""):void
		{
			_levelName=name
			init()
		}

		private function init():void
		{
			_collisionDetector=new CollisionDetector()
			_pathfinder=new utils.Pathfinder
			_map=new Array()
			_collisionMap=new Array()
			_tilemap=new XML(Game.resources.get_xml(Config.level_specs + _levelName + ".tmx").data)
			_spritesManager=new SpritesManager()
			Starling.current.root.addEventListener(TouchEvent.TOUCH, onTouch);

			Game.windowsManager.stage.addEventListener(MouseEvent.MOUSE_DOWN, viewMouseDown);
			Game.windowsManager.stage.addEventListener(MouseEvent.MOUSE_WHEEL, viewZoom);

			var grid:IsoGrid=new IsoGrid();
			grid.showOrigin=false;
			grid.setGridSize(20, 20, 0);
			grid.cellSize=Config.cell_size
			_scene=new IsoScene();
			_scene.addChild(grid);
			_view=new IsoView();
			_view.setSize(1024, 768);
			_view.addScene(_scene);
			_view.clipContent=false;
			_view.autoUpdate=true
			addChild(_view)
			renderScene()
			_view.render(new RenderSupport, 100)
			_view.addEventListener(IsoEvent.RENDER_COMPLETE, function():void
			{
				trace("complete")
			})
			fillLevel(_tilemap)
		}

		public function renderScene():void
		{
			if (_render == false)
			{
				_render=true
				_scene.render()
			}
		}

		public function sceneRendered():void
		{
			_render=false
		}

		public function rightClick(e:MouseEvent):void
		{
			if (_mouseOverElement != null)
			{
				_mouseOverElement.onRightClick()
			}
		}

		private function onTouch(e:TouchEvent):void
		{
			var img:*
			img=e.target as BasicImage
			if (img == null)
			{
				img=e.target as BasicMovieClip
			}
			if (img != null && img.object != null)
			{
				if (e.getTouch(this, TouchPhase.ENDED))
				{
					img.object.onLeftClick()
				}
				if (e.getTouch(this, TouchPhase.HOVER))
				{
					if (_mouseOverElement != img.object)
					{
						if (_mouseOverElement != null)
						{
							_mouseOverElement.onMouseOut()
						}
						_mouseOverElement=img.object
					}
					img.object.onMouseOver()
				}
				else
				{
					img.object.onMouseOut()
				}
			}
			else
			{
				if (_mouseOverElement != null)
				{
					_mouseOverElement.onMouseOut()
				}
			}
		}

		private function addObject(object:BasicObject, cell:Cell=null):void
		{
			//	object.moveTo(Config.cell_size * cell.x, Config.cell_size * cell.y, Config.cell_size * cell.z)
		}

		public function getCellAt(x:Number, y:Number):Cell
		{
			return _map[y - 1][x - 1]
		}

		public function addFloor(cell:Cell=null):void
		{
			var spritesPack:SpritesPack=_spritesManager.getPack("floor")
			var floor:Floor=new Floor(_scene, spritesPack, cell)
			addObject(floor, cell)
		}

		public function addWall(cell:Cell=null):void
		{
			var spritesPack:SpritesPack=_spritesManager.getPack("wall")
			var wall:Wall=new Wall(_scene, spritesPack, cell)
			addObject(wall, cell)
		}

		public function addBlock(cell:Cell=null):void
		{
			var spritesPack:SpritesPack=_spritesManager.getPack("block")
			var block:Block=new Block(_scene, spritesPack, cell)
			addObject(block, cell)
		}

		public function addPlayer(cell:Cell):void
		{
			var spritesPack:SpritesPack=_spritesManager.getPack("player")
			_player=new Player(_scene, spritesPack, cell)
			addObject(_player, cell)
		}

		public function addEnemy(cell:Cell=null, endPoint:Cell=null, delay:Number=0):void
		{

			var spritesPack:SpritesPack=_spritesManager.getPack("enemy")
			var enemy:Enemy=new Enemy(_scene, spritesPack, cell, endPoint, delay)
			addObject(enemy, cell)
		}

		public function removeObject(object:BasicObject):void
		{
			if (_mouseOverElement == object)
			{
				_mouseOverElement=null
			}
			object=null
		}

		private function fillLevel(xml:XML=null):void
		{
			_mapWidth=int(xml.@width)
			_mapHeight=int(xml.@height)
			var yShift:int=0
			var xShift:int=0
			var row:Vector.<Cell>=new Vector.<Cell>
			for (var i:int=0; i < (_mapHeight * _mapWidth); i++)
			{
				var cell:Cell=new Cell(xShift, yShift, 0)
				//cell.blocked=true
				initObject(xml.layer[0].data.tile[i].@gid, cell)
				row.push(cell)
				xShift++
				if (xShift == _mapWidth)
				{
					_map.push(row)
					row=new Vector.<Cell>
					xShift=0
					yShift++
				}
			}
			updateCollisionMap()
			addPlayer(getCellAt(3, 3))
			//addEnemy(getCellAt(6, 7), getCellAt(6, 3), 1000)
			addEnemy(getCellAt(2, 2), getCellAt(10, 2), 1000)
			//addEnemy(getCellAt(3, 10), getCellAt(3, 5), 1000)
		}


		public function updateCollisionMap():void
		{
			_collisionMap=new Array()
			for (var i:int=0; i < _map.length; i++)
			{
				var cVector:Vector.<Cell>=_map[i]
				var row:Array=new Array()
				for (var a:int=0; a < cVector.length; a++)
				{
					if (cVector[a].blocked == true)
					{
						row.push(1)
					}
					else
					{
						row.push(0)
					}
				}
				_collisionMap.push(row)
			}

		}

		public function getPath(start:Point, end:Point, diag:Boolean):Vector.<Point>
		{

			var path:Vector.<Point>=_pathfinder.findPath(_collisionMap, start, end)
			return path
		}


		private function initObject(id:String="", cell:Cell=null):void
		{
			switch (id)
			{
				case "1":
				{
					if (Math.round(1 * Math.random()) == 1)
					{
						addBlock(cell)
					}
					else
					{
						addWall(cell)
					}

					break;
				}
				case "2":
				{
					addFloor(cell)
					break;
				}
				case "3":
				{
					addWall(cell)
					break;
				}
				case "0":
				{

					break;
				}


				default:
				{
					break;
				}
			}
		}

		private function viewMouseDown(e:MouseEvent):void
		{
			_panPoint=new Point(Game.windowsManager.stage.mouseX, Game.windowsManager.stage.mouseY);
			Game.windowsManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, viewPan);
			Game.windowsManager.stage.addEventListener(MouseEvent.MOUSE_UP, viewMouseUp);
		}

		private function viewMouseUp(e:MouseEvent):void
		{
			Game.windowsManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, viewPan);
			Game.windowsManager.stage.removeEventListener(MouseEvent.MOUSE_UP, viewMouseUp);
		}

		private function viewPan(e:MouseEvent):void
		{
			_view.panBy(_panPoint.x - Game.windowsManager.stage.mouseX, _panPoint.y - Game.windowsManager.stage.mouseY);
			_panPoint.x=Game.windowsManager.stage.mouseX;
			_panPoint.y=Game.windowsManager.stage.mouseY;
		}

		private function viewZoom(e:MouseEvent):void
		{
			if (e.delta > 0)
			{
				_zoom+=0.50;
			}
			if (e.delta < 0)
			{
				_zoom-=0.50;
			}

			if (_zoom < 0.50)
				_zoom=0.50;
			_view.currentZoom=_zoom;
		}

		public function get collisionDetector():CollisionDetector
		{
			return _collisionDetector
		}


	}
}

