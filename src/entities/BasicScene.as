package entities

{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.renderers.SimpleSceneLayoutRenderer;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.events.IsoEvent;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import objects.Block;
	import objects.Cannon;
	import objects.Enemy;
	import objects.Fireball;
	import objects.Floor;
	import objects.Player;
	import objects.Wall;

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
	import utils.ShotsManager;

	import windows.Game;

	public class BasicScene extends Sprite
	{

		public var _levelName:String

		private var _sceneStatic:IsoScene
		private var _sceneMain:IsoScene
		private var _view:IsoView

		private var _mapWidth:int
		private var _mapHeight:int

		private var _bg:Quad

		private var _panPoint:Point
		private var _zoom:Number=1

		public var _player:Player

		private var _mouseOverElement:*


		private var _objects:Vector.<BasicObject>
		private var _spritesManager:SpritesManager
		private var _tilemap:XML
		private var _map:Array
		private var _collisionMap:Array
		private var _pathfinder:utils.Pathfinder
		private var _render:Boolean=false
		private var _simpleRenderer:SimpleSceneLayoutRenderer

		private var _collisionDetector:CollisionDetector
		private var _shotsManager:ShotsManager

		public function BasicScene()
		{
		}

		public function setLevel(name:String=""):void
		{
			_levelName=name
			init()
		}

		public function init():void
		{
			_objects = new Vector.<BasicObject>
			_collisionDetector=new CollisionDetector()
			_shotsManager=new ShotsManager()
			_pathfinder=new utils.Pathfinder
			_map=new Array()
			_collisionMap=new Array()
			_tilemap=new XML(Game.resources.get_xml(Config.level_specs + _levelName + ".tmx").data)
			_spritesManager=new SpritesManager()
			Starling.current.root.addEventListener(TouchEvent.TOUCH, onTouch);
			Game.windowsManager.stage.addEventListener(MouseEvent.MOUSE_DOWN, viewMouseDown);
			Game.windowsManager.stage.addEventListener(MouseEvent.MOUSE_WHEEL, viewZoom);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame)
			_sceneStatic=new IsoScene();
			_sceneMain=new IsoScene();
			_view=new IsoView();
			_view.setSize(1024, 768);
			_view.addScene(_sceneStatic);
			_view.addScene(_sceneMain);
			_view.clipContent=false;
			_view.autoUpdate=true
			addChild(_view)
			_view.render(new RenderSupport, 100)
			fillLevel(_tilemap)
		}

		private function onEnterFrame(e:Event):void
		{
			_render=false
		}

		public function renderScene(scene:IsoScene):void
		{
			if (_render == false)
			{
				scene.render()
				_render=true
			}
		}

		public function updateNearestSprites(sprite:IsoSprite, scene:IsoScene):void
		{
			var nearest:Vector.<IsoSprite>=new Vector.<IsoSprite>
			var minDist:Number=3000
			var delta:Number=sprite.x + sprite.y
			for (var i:int=0; i < scene.children.length; i++)
			{
				if (scene.children[i] != sprite)
				{
					var tDelta:Number=scene.children[i].x + scene.children[i].y
					if (Math.abs(tDelta - delta) < minDist)
					{
						nearest.unshift(scene.children[i])
					}
				}
			}
			nearest=nearest.slice(0, 10)
			for (var a:int=0; a < nearest.length; a++)
			{
				nearest[a].render()
			}
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
			_objects.push(object)
			//	object.moveTo(Config.cell_size * cell.x, Config.cell_size * cell.y, Config.cell_size * cell.z)
		}

		public function getCellAt(x:Number, y:Number):Cell
		{
			return _map[y][x]
		}

		public function getCellAtCoords(x:Number, y:Number):Cell
		{
			var _x:int=Math.round(x / Config.cell_size)
			var _y:int=Math.round(y / Config.cell_size)
			if (_x >= _mapWidth)
			{
				return null
			}
			if (_y >= _mapHeight)
			{
				return null
			}
			return _map[_y][_x]
		}

		public function addFloor(cell:Cell=null):void
		{

			var spritesPack:SpritesPack=_spritesManager.getPack("floor")
			var floor:Floor=new Floor(_sceneStatic, spritesPack, cell)
			addObject(floor, cell)
		}

		public function addWall(cell:Cell=null):void
		{
			var spritesPack:SpritesPack=_spritesManager.getPack("wall")
			var wall:Wall=new Wall(_sceneMain, spritesPack, cell)
			addObject(wall, cell)
		}

		public function addCannon(cell:Cell=null, delay:Number=0):void
		{
			var spritesPack:SpritesPack=_spritesManager.getPack("cannon")
			var cannon:Cannon=new Cannon(_sceneMain, spritesPack, cell, delay)
			addObject(cannon, cell)
		}


		public function addBlock(cell:Cell=null):void
		{
			if (cell.blocked == false)
			{
				var spritesPack:SpritesPack=_spritesManager.getPack("block")
				var block:Block=new Block(_sceneMain, spritesPack, cell)
				addObject(block, cell)
			}
		}

		public function addPlayer(cell:Cell):void
		{
			var spritesPack:SpritesPack=_spritesManager.getPack("player")
			_player=new Player(_sceneMain, spritesPack, cell)
			addObject(_player, cell)
		}

		public function addEnemy(cell:Cell=null, endPoint:Cell=null, delay:Number=0):void
		{

			var spritesPack:SpritesPack=_spritesManager.getPack("enemy")
			var enemy:Enemy=new Enemy(_sceneMain, spritesPack, cell, endPoint, delay)
			addObject(enemy, cell)
		}

		public function addFireball(cell:Cell=null, shiftX:Number=0, shiftY:Number=0):void
		{
			var spritesPack:SpritesPack=_spritesManager.getPack("fireball")
			var fireball:Fireball=new Fireball(shiftX, shiftY, _sceneMain, spritesPack, cell)
			addObject(fireball, cell)
		}

		public function addExplosion(x:Number, y:Number):void
		{
			var spritesPack:SpritesPack=_spritesManager.getEffectPack("explosion")
			var explosion:Explosion=new Explosion(x, y, 0, _sceneMain, spritesPack)
		}

		public function removeObject(object:*):void
		{
			if (_mouseOverElement == object)
			{
				_mouseOverElement=null
			}
			for(var i:int = 0; i<_objects.length;i++){
				if(object==_objects[i]){
					_objects.splice(i,1)
				}
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
			xShift=0
			yShift=0
			for (var a:int=0; a < (_mapHeight * _mapWidth); a++)
			{
				initObject(xml.layer[0].data.tile[a].@gid, getCellAt(xShift, yShift))
				xShift++
				if (xShift == _mapWidth)
				{
					xShift=0
					yShift++
				}
			}
			updateCollisionMap()
			//	addWall(getCellAt(3, 3))
			//addBlock(getCellAt(4, 4))
			addPlayer(getCellAt(4, 4))
			addEnemy(getCellAt(6, 7), getCellAt(6, 3), 1000)
			addEnemy(getCellAt(2, 2), getCellAt(10, 2), 1000)
			//addFireball(getCellAt(4, 6))
			addCannon(getCellAt(6, 10), 1000)
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

		public function getPath(start:Point, end:Point, diag:Boolean):Object
		{
			return _pathfinder.findPath(_collisionMap, start, end)
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
					addFloor(cell)
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

		public function get shotsManager():ShotsManager
		{
			return _shotsManager
		}
		public function remove():void{
			for(var i:int = _objects.length-1; i>=0;i--){
				_objects[i].remove()
			}
			_collisionDetector.remove()
			_shotsManager.remove()
		}

	}
}

