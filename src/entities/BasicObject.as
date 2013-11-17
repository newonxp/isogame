package entities
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoScene;

	import flash.events.MouseEvent;

	import sprites.SpritesPack;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FragmentFilter;

	import utils.DegreesToCompass;

	import windows.Game;

	public class BasicObject
	{
		private var _scene:IsoScene
		private var _spritesPack:SpritesPack
		private var _bounds:Bounds

		private var _cell:Cell
		private var _sprite:IsoSprite
		private var _box:IsoBox
		private var _converter:DegreesToCompass
		private var _spritesArray:Array

		private var _x:Number
		private var _y:Number
		private var _z:Number

		private var _type:String

		public function BasicObject(x:Number=0, y:Number=0, z:Number=0, bounds:Bounds=null, cell:Cell=null, scene:IsoScene=null, spritesPack:SpritesPack=null)
		{
			_scene=scene
			_spritesPack=spritesPack
			_x=x
			_y=y
			_z=z
			_bounds=bounds
			_cell=cell
			init()
		}

		private function init():void
		{
			_spritesArray=new Array()
			_converter=new DegreesToCompass()
			/*
			var mc:MovieClip=new MovieClip(atlas.getTextures("grass"), 3)
			Starling.juggler.add(mc)

			var img:Image=new Image(atlas.getTexture("grass00"));
			var img1:Image=new Image(atlas.getTexture("grass01"));
			var img2:Image=new Image(atlas.getTexture("grass02"));

			var s0:IsoSprite=new IsoSprite();
			s0.isAnimated=true
			s0.autoUpdate=true

			s0.setSize(100, 100, 100);
			s0.moveTo(0, 0, 0);
			s0.sprites=[mc];*/
			_sprite=new IsoSprite();
			_sprite.isAnimated=true
			_sprite.autoUpdate=true
			_sprite.setSize(_bounds.x, _bounds.y, _bounds.z);
			addSprite(_spritesPack.n.normal)
			_scene.addChild(_sprite);
			moveTo(_x, _y, _z)
			rotate(2)
			render()
		}

		public function render():void
		{
			Game.windowsManager.gameInstance.scene.renderScene()
			//_sprite.render();
		}

		private function addSprite(img:*):void
		{
			if (_spritesPack.animated == true)
			{
				addMovieClip(img)
			}
			else
			{
				addImage(_spritesPack.n.normal)
			}
		}

		public function rotate(degrees:Number=0):void
		{
			var side:String=_converter.convert(degrees)
			removeImage()
			if (_spritesPack[side].normal != null)
			{
				addSprite(_spritesPack[side].normal)
			}
			else
			{
				rotate(degrees + 45)
			}
		}

		private function addImage(img:BasicImage):void
		{
			img.setAs3IsoObject(this)
			img.x=((_sprite.width / 2) - (img.width / 2)) - (_sprite.length / 2);
			img.y=((_sprite.length / 2) + (_sprite.width / 2)) - img.height;
			_spritesArray=new Array()
			_spritesArray.push(img)
			_sprite.sprites=_spritesArray
		}

		private function addMovieClip(img:BasicMovieClip):void
		{
			img.setAs3IsoObject(this)
			img.x=((_sprite.width / 2) - (img.width / 2)) - (_sprite.length / 2);
			img.y=((_sprite.length / 2) + (_sprite.width / 2)) - img.height;
			_spritesArray=new Array()
			_spritesArray.push(img)
			_sprite.sprites=_spritesArray
			Starling.juggler.add(img)
		}

		public function removeImage():void
		{
			if (_spritesPack.animated == true)
			{
				Starling.juggler.remove(_sprite.sprites[0])
			}
			_sprite.sprites=[]
			render()
		}

		public function moveTo(x:Number=0, y:Number=0, z:Number=0):void
		{
			_sprite.moveTo(x, y, z);
			render()
		}

		public function onMouseOver():void
		{
			var colorMatrixFilter:ColorMatrixFilter=new ColorMatrixFilter()
			colorMatrixFilter.adjustBrightness(0.2);
			_sprite.actualSprites[0].filter=colorMatrixFilter;
		}

		public function onMouseOut():void
		{
			_sprite.actualSprites[0].filter=null;
		}

		public function onLeftClick():void
		{

		}

		public function onRightClick():void
		{

		}

		public function get x():Number
		{
			return _x
		}

		public function get y():Number
		{
			return _y
		}

		public function get z():Number
		{
			return _z
		}

		public function get cell():Cell
		{
			return _cell
		}

		public function get type():String
		{
			return _type
		}


		public function set x(val:Number):void
		{
			_x=val
			moveTo(_x, _y, _z)
		}

		public function set y(val:Number):void
		{
			_y=val
			moveTo(_x, _y, _z)
		}

		public function set z(val:Number):void
		{
			_z=val
			moveTo(_x, _y, _z)
		}

		public function set cell(val:Cell):void
		{
			_cell=val
		}

		public function set type(val:String):void
		{
			_type=val
		}

		public function collide(target:BasicObject):void
		{

		}


		public function remove():void
		{
			_scene.removeChild(_sprite)
			var scene:Level=Starling.current.root as Level
			scene.removeObject(this)
		}
	}
}
