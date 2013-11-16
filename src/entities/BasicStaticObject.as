package entities
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoScene;

	import flash.events.MouseEvent;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;

	public class BasicStaticObject extends Sprite
	{
		private var _scene:IsoScene

		private var _spriteImg:BasicImage
		private var _spriteImgOver:BasicImage

		private var _sprite:IsoSprite
		private var _box:IsoBox

		private var spritesArray:Array=[]

		public function BasicStaticObject(scene:IsoScene=null, spriteImg:BasicImage=null, spriteImgOver:BasicImage=null)
		{
			_scene=scene
			_spriteImg=spriteImg
			_spriteImgOver=spriteImgOver
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
			_sprite=new IsoSprite();
			_sprite.isAnimated=true
			_sprite.autoUpdate=true
			_sprite.setSize(Config.cell_size, Config.cell_size, 0);
			//_spriteImg.x=((_sprite.width / 2) - (_spriteImg.width / 2)) - (_sprite.length / 2);
			//_spriteImg.y=((_sprite.length / 2) + (_sprite.width / 2)) - _spriteImg.height;
			//_sprite.sprites=[_spriteImg]
			addImage(_spriteImg)
			addImage(_spriteImgOver)

			_scene.addChild(_sprite);
			_scene.render();
			//_sprite.container.addEventListener(TouchEvent.TOUCH, _onTouch)
			onMouseOut()
		}

		private function addImage(img:BasicImage):void
		{
			img.setAs3IsoObject(this)
			img.x=((_sprite.width / 2) - (img.width / 2)) - (_sprite.length / 2);
			img.y=((_sprite.length / 2) + (_sprite.width / 2)) - img.height;
			spritesArray.push(img)
			_sprite.sprites=spritesArray
		}

		private function _onTouch(e:TouchEvent):void
		{
			//trace(_sprite.x + " " + _sprite.y)
			//trace(e.)
		}

		public function moveTo(x:Number=0, y:Number=0, z:Number=0):void
		{
			_sprite.moveTo(x, y, z);
			_scene.render();
		}

		public function onMouseOver():void
		{
			_sprite.actualSprites[1].visible=true
		}

		public function onMouseOut():void
		{
			_sprite.actualSprites[1].visible=false
		}
	}
}
