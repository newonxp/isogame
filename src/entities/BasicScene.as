package entities

{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;

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

	import windows.Game;

	public class BasicScene extends Sprite
	{
		private var _spritesheet_src:String="img/spritesheet.png"
		private var _spritesheetXml_src:String="xml/spritesheet.xml"

		private var _spritesheet:Bitmap
		private var _spritesheetXml:XML
		private var _atlas:TextureAtlas
		private var _tilemap:XML
		public var _levelName:String

		private var _scene:IsoScene
		private var _view:IsoView

		private var _mapWidth:int
		private var _mapHeight:int

		private var _bg:Quad

		private var _panPoint:Point
		private var _zoom:Number=1

		private var _mouseOverElement:*


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
			Starling.current.root.addEventListener(TouchEvent.TOUCH, _onTouch);

			Game.windowsManager.stage.addEventListener(MouseEvent.MOUSE_DOWN, viewMouseDown);
			Game.windowsManager.stage.addEventListener(MouseEvent.MOUSE_WHEEL, viewZoom);

			_tilemap=new XML(Game.resources.get_xml(Config.level_specs + _levelName + ".tmx").data)
			_spritesheet=new Bitmap()
			_spritesheet=Game.resources.get_img(_spritesheet_src).data
			var texture:Texture=Texture.fromBitmap(_spritesheet)
			var xml:XML=Game.resources.get_xml(_spritesheetXml_src).data
			_atlas=new TextureAtlas(texture, xml)

			var grid:IsoGrid=new IsoGrid();
			grid.showOrigin=true;
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

			fillLevel(_tilemap)
			_scene.render();
		}

		private function _onTouch(e:TouchEvent):void
		{
			//trace(e.getTouch(this, TouchPhase.HOVER) ? "Yay" : "Nay");
			var img:BasicImage=e.target as BasicImage
			if (img != null && img.object != null)
			{
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

		private function addFloor(textureName:String="", x:Number=0, y:Number=0):void
		{
			var img:BasicImage=new BasicImage(_atlas.getTexture(textureName));
			var imgOver:BasicImage=new BasicImage(_atlas.getTexture(textureName + "_over"));
			var floorSegment:Floor=new Floor(_scene, img, imgOver)
			floorSegment.moveTo(Config.cell_size * x, Config.cell_size * y, 0)
		}

		private function fillLevel(xml:XML=null):void
		{
			_mapWidth=int(xml.@width)
			_mapHeight=int(xml.@height)
			var yShift:int=0
			var xShift:int=0
			for (var i:int=0; i < (_mapHeight * _mapWidth); i++)
			{
				addObject(xml.layer[0].data.tile[i].@gid, xShift, yShift)
				if (xShift == _mapWidth)
				{
					xShift=0
					yShift++
				}
				xShift++
			}
		}

		private function addObject(id:String="", x:int=0, y:int=0):void
		{
			switch (id)
			{
				case "1":
				{
					addFloor("wall", x, y)
					break;
				}
				case "2":
				{
					addFloor("floor", x, y)
					break;
				}
				case "3":
				{
					addFloor("floor", x, y)
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


	}
}

