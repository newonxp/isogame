package entities
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.scene.IsoScene;

	import sprites.SpritesPack;

	import starling.core.Starling;
	import starling.events.Event;

	import utils.AngleUtils;

	public class BasicEffect
	{
		private var _scene:IsoScene
		private var _spritesPack:SpritesPack
		private var _bounds:Bounds

		private var _cell:Cell
		private var _sprite:IsoSprite
		public var _converter:AngleUtils
		private var _spritesArray:Array
		private var _blocking:Boolean
		private var _movable:Boolean
		private var _collidable:Boolean

		private var _x:Number
		private var _y:Number
		private var _z:Number
		private var _rotation:Number

		private var _oldX:Number
		private var _oldY:Number


		private var _type:String
		private var _touchable:Boolean

		public function BasicEffect(x:Number=0, y:Number=0, z:Number=0, bounds:Bounds=null, scene:IsoScene=null, spritesPack:SpritesPack=null)
		{
			_scene=scene
			_spritesPack=spritesPack
			_x=x
			_y=y
			_z=z
			_bounds=bounds
			init()
		}

		private function init():void
		{
			_spritesArray=new Array()
			_converter=new AngleUtils()
			_sprite=new IsoSprite();
			_sprite.isAnimated=true
			_sprite.autoUpdate=true
			_sprite.setSize(_bounds.x, _bounds.y, _bounds.z);
			addSprite(_spritesPack.effect)
			_scene.addChild(_sprite);
			moveTo(_x, _y, _z)
		}

		private function addSprite(img:BasicMovieClip):void
		{
			img.addEventListener(Event.COMPLETE, onComplete)
			img.x=((_sprite.width / 2) - (img.width / 2)) - (_sprite.length / 2);
			img.y=((_sprite.length / 2) + (_sprite.width / 2)) - img.height;
			_spritesArray=new Array()
			_spritesArray.push(img)
			_sprite.sprites=_spritesArray
			Starling.juggler.add(img)
		}

		private function onComplete():void
		{
			remove()
		}

		public function moveTo(x:Number=0, y:Number=0, z:Number=0):void
		{
			_sprite.moveTo(x, y, z);
		}

		public function remove():void
		{
			_scene.removeChild(_sprite)
			var scene:Level=Starling.current.root as Level
			scene.removeObject(this)
		}
	}
}
