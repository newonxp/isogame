package entities

{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.renderers.SimpleSceneLayoutRenderer;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import objects.Block;
	import objects.Cannon;
	import objects.Coin;
	import objects.Enemy;
	import objects.EscapeZone;
	import objects.Fireball;
	import objects.Floor;
	import objects.Player;
	import objects.Wall;

	import sprites.SpritesManager;
	import sprites.SpritesPack;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	import utils.CollisionDetector;
	import utils.Pathfinder;
	import utils.ShotsManager;

	import windows.Game;

	public class BasicScene extends Sprite
	{

		public var _levelName:String

		private var _sceneBottom:IsoScene
		private var _sceneMain:IsoScene
		private var _sceneTop:IsoScene
		private var _view:IsoView

		private var _mapWidth:int
		private var _mapHeight:int

		private var _bg:Quad

		private var _panPoint:Point
		private var _zoom:Number=1
		public var _player:Player
		private var _mouseOverElement:BasicObject
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
		private var _startPoint:Cell
		private var _endPoint:Cell
		private var _block:BasicObject

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
			_objects=new Vector.<BasicObject>
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
			_sceneBottom=new IsoScene();
			_sceneMain=new IsoScene();
			_sceneTop=new IsoScene();
			_view=new IsoView();
			_view.setSize(1024, 768);
			_view.addScene(_sceneBottom);
			_view.addScene(_sceneMain);
			_view.addScene(_sceneTop);
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
		private function getOptimalScene(cell:Cell):IsoScene{
			var scene:IsoScene 
			if(cell.x==0||cell.y==0){
				scene=_sceneBottom
			}else if(cell.x==_mapWidth||cell.y==_mapHeight){
				scene=_sceneTop
			}else{
				scene=_sceneMain
			}
			return scene
		}

		public function addFloor(cell:Cell=null):void
		{
			var spritesPack:SpritesPack=_spritesManager.getPack("floor")
			var floor:Floor=new Floor(_sceneBottom, spritesPack, cell)
			addObject(floor, cell)
		}


		public function addWall(cell:Cell=null):void
		{
			var spritesPack:SpritesPack=_spritesManager.getPack("wall")

			var wall:Wall=new Wall(getOptimalScene(cell), spritesPack, cell)
			addObject(wall, cell)
		}

		public function addCannon(cell:Cell=null, rotate:Number=0, delay:Number=0):void
		{
			var spritesPack:SpritesPack=_spritesManager.getPack("cannon")
			var cannon:Cannon=new Cannon(getOptimalScene(cell), spritesPack, cell, rotate, delay)
			addObject(cannon, cell)
		}


		public function addBlock(cell:Cell=null):void
		{
			if (cell.blocked == false)
			{
				if (_block != null)
				{
					_block.remove()
				}
				var spritesPack:SpritesPack=_spritesManager.getPack("block")
				var block:Block=new Block(_sceneMain, spritesPack, cell)
				_block=block
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

		public function addCoin(cell:Cell):void
		{
			var spritesPack:SpritesPack=_spritesManager.getPack("coin")
			var coin:Coin=new Coin(_sceneMain, spritesPack, cell)
		}

		public function addEscape(cell:Cell):void
		{
			var spritesPack:SpritesPack=_spritesManager.getPack("escape")
			var escapeZone:EscapeZone=new EscapeZone(_sceneMain, spritesPack, cell)
		}


		public function removeObject(object:*):void
		{
			if (_mouseOverElement == object)
			{
				_mouseOverElement=null
			}
			for (var i:int=0; i < _objects.length; i++)
			{
				if (object == _objects[i])
				{
					_objects.splice(i, 1)
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
			var layersLength:int=xml.layer.length()

			for (var i:int=0; i < (_mapHeight * _mapWidth); i++)
			{
				var cell:Cell=new Cell(xShift, yShift, 0)
				row.push(cell)
				if (xShift == 0)
				{
					_map.push(row)
				}
				for (var b:int=0; b < layersLength; b++)
				{
					if (xml.layer[b].data.tile[i].@gid != 0)
					{
						//	trace(xml.layer[b].@name + " " + xml.layer[b].data.tile[i].@gid)
						initObject(xml.layer[b].@name, cell)
					}
				}
				xShift++
				if (xShift == _mapWidth)
				{

					row=new Vector.<Cell>
					xShift=0
					yShift++
				}
			}
			for (var a:int=0; a < xml.objectgroup.object.length(); a++)
			{
				if (xml.objectgroup.object[a].@type == Config.startPosition)
				{
					_startPoint=getCellAtCoords(xml.objectgroup.object[a].@x, xml.objectgroup.object[a].@y)
				}
				else if (xml.objectgroup.object[a].@type == Config.endPosition)
				{
					_endPoint=getCellAtCoords(xml.objectgroup.object[a].@x, xml.objectgroup.object[a].@y)
				}
				else if (xml.objectgroup.object[a].@type == Config.cannon)
				{
					var rotation:Number=0
					var delay:Number=0
					for (var c:int=0; c < xml.objectgroup.object[a].properties.property.length(); c++)
					{
						if (xml.objectgroup.object[a].properties.property[c].@name == "rotation")
						{
							rotation=xml.objectgroup.object[a].properties.property[c].@value
						}
						if (xml.objectgroup.object[a].properties.property[c].@name == "delay")
						{
							delay=xml.objectgroup.object[a].properties.property[c].@value
						}
					}
					addCannon(getCellAtCoords(xml.objectgroup.object[a].@x, xml.objectgroup.object[a].@y), rotation, delay)
				}
				else if (xml.objectgroup.object[a].@type == Config.coin)
				{
					addCoin(getCellAtCoords(xml.objectgroup.object[a].@x, xml.objectgroup.object[a].@y))

				}
				else if (xml.objectgroup.object[a].@type == Config.enemy)
				{
					var destCell:Cell
					for (var d:int=0; d < xml.objectgroup.object[a].properties.property.length(); d++)
					{
						if (xml.objectgroup.object[a].properties.property[d].@name == "destName"){
							var obj:XML =getObjectByType(xml,xml.objectgroup.object[a].properties.property[d].@value)
							destCell=getCellAtCoords(obj.@x,obj.@y)
						}
					}
					addEnemy(getCellAtCoords(xml.objectgroup.object[a].@x, xml.objectgroup.object[a].@y),destCell,1000)

				}
			}
			/*		xShift=0
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
					updateCollisionMap()*/
			/*			addPlayer(getCellAt(_startCell.x, _startCell.y))
						addEnemy(getCellAt(6, 7), getCellAt(6, 3), 1000)*/
			//addEnemy(getCellAt(2, 2), getCellAt(10, 2), 1000)
			/*	addCoin(getCellAt(10, 11))
				addCoin(getCellAt(10, 12))
				addCoin(getCellAt(10, 13))
				_winCell=getCellAt(10, 10)
				addEscape(_winCell)
				addCannon(getCellAt(6, 10), 1000)*/
			//addEnemy(getCellAt(3, 10), getCellAt(3, 5), 1000)
			addPlayer(_startPoint)
			addEscape(_endPoint)
			updateCollisionMap()
		}
		private function getObjectByType(xml:XML,type:String):XML{
			for (var i:int=0; i < xml.objectgroup.object.length(); i++)
			{
				if(xml.objectgroup.object[i].@type == type){
					return xml.objectgroup.object[i]
				}
			}
			return null
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
				case "floor":
				{
					addFloor(cell)
					break;
				}
				case "wall":
				{
					addWall(cell)
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

		public function pan(x:Number, y:Number):void
		{
			var pt:Pt=new Pt(x, y, 0)
			pt=IsoMath.isoToScreen(pt)
		}

		public function isNearPlayer(cell:Cell):Boolean
		{
			if (Math.abs(cell.x - _player.cell.x) <= 1 && Math.abs(cell.y - _player.cell.y) <= 1)
			{
				return true
			}
			return false
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

		public function get endPoint():Cell
		{
			return _endPoint
		}

		public function get startPoint():Cell
		{
			return _startPoint
		}

		public function get mapWidth():int
		{
			return _mapWidth
		}

		public function get mapHeight():int
		{
			return _mapHeight
		}

		public function remove():void
		{
			for (var i:int=_objects.length - 1; i >= 0; i--)
			{
				_objects[i].remove()
			}
			_collisionDetector.remove()
			_shotsManager.remove()
		}

	}
}

