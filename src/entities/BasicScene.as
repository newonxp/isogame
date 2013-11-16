package entities

{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
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

		private var _mapWidth:int
		private var _mapHeight:int




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
			_tilemap=new XML(Game.resources.get_xml(Config.level_specs + _levelName + ".tmx").data)
			_spritesheet=new Bitmap()
			_spritesheet=Game.resources.get_img(_spritesheet_src).data
			var texture:Texture=Texture.fromBitmap(_spritesheet)
			var xml:XML=Game.resources.get_xml(_spritesheetXml_src).data
			_atlas=new TextureAtlas(texture, xml)

			var grid:IsoGrid=new IsoGrid();
			grid.showOrigin=true;
			grid.setGridSize(30, 30, 0);
			grid.cellSize=30;
			_scene=new IsoScene();
			_scene.addChild(grid);

			var view:IsoView=new IsoView();
			view.setSize(1024, 768);
			view.addScene(_scene);
			view.autoUpdate=true
			addChild(view)

			view.clipContent=false;
			Game.windowsManager.addEventListener(flash.events.Event.ENTER_FRAME, function(e:Event):void
			{
				//_scene.render();
			});
			fillLevel(_tilemap)
			_scene.render();
		}

		private function addFloor(textureName:String="", x:Number=0, y:Number=0):void
		{
			var img:Image=new Image(_atlas.getTexture("grass00"));
			var floorSegment:Floor=new Floor(_scene, img)
			floorSegment.moveTo(30 * x, 30 * y, 0)
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
					addFloor("grass00", x, y)
					break;
				}
				case "2":
				{
					addFloor("grass01", x, y)
					break;
				}
				case "3":
				{
					addFloor("grass02", x, y)
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

		private function onMouseClick(e:MouseEvent):void
		{

		}
	}
}

