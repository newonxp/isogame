package entities
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoScene;

	import flash.events.MouseEvent;

	import starling.display.Image;
	import starling.display.Sprite;

	public class BasicStaticObject extends Sprite
	{
		private var _scene:IsoScene
		private var _spriteImg:Image
		private var _sprite:IsoSprite
		private var _box:IsoBox

		public function BasicStaticObject(scene:IsoScene=null, spriteImg:Image=null)
		{
			_scene=scene
			_spriteImg=spriteImg

			init()
		}

		private function init():void
		{
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
			_box=new IsoBox();
			_box.moveTo(0, 0, 0);
			_box.setSize(30, 30, 2);
			_scene.addChild(_box);

			_sprite=new IsoSprite();
			_sprite.isAnimated=true
			_sprite.autoUpdate=true
			_sprite.setSize(30, 30, 0);
			_sprite.sprites=[_spriteImg]
			_scene.addChild(_sprite);
			_scene.render();
		}

		public function moveTo(x:Number=0, y:Number=0, z:Number=0):void
		{
			_box.moveTo(x, y, z);
			_sprite.moveTo(x, y, z);
			_scene.render();
		}
	}
}
