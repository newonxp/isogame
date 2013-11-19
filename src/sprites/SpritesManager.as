package sprites
{
	import flash.display.Bitmap;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import windows.Game;
	import entities.BasicImage;
	import entities.BasicMovieClip;

	public class SpritesManager
	{
		private var _spritesheet_src:String="img/spritesheet.png"
		private var _spritesheetXml_src:String="xml/spritesheet.xml"
		private var _spritesheet:Bitmap
		private var _spritesheetXml:XML
		private var _atlas:TextureAtlas
		private var _sides:Vector.<String>=new <String>["n", "ne", "e", "se", "s", "sw", "w", "nw"]

		private var _packs:Vector.<SpritesPack>=new Vector.<SpritesPack>

		public function SpritesManager()
		{
			_spritesheet=new Bitmap()
			_spritesheet=Game.resources.get_img(_spritesheet_src).data
			var texture:Texture=Texture.fromBitmap(_spritesheet)
			var xml:XML=Game.resources.get_xml(_spritesheetXml_src).data
			_atlas=new TextureAtlas(texture, xml)
		}

		public function getPack(name:String=""):SpritesPack
		{
			var pack:SpritesPack=new SpritesPack(name)
			if (_atlas.getTexture(name + "_n") == null)
			{
				pack.animated=true
				createAnimatedPack(name, pack)
			}
			else
			{
				pack.animated=false
				createPack(name, pack)
			}
			return pack

		}

		public function getEffectPack(name:String=""):SpritesPack
		{
			var pack:SpritesPack=new SpritesPack(name)
			createEffectPack(name, pack)
			return pack

		}

		private function createPack(name:String, pack:SpritesPack):void
		{
			for (var i:int=0; i < _sides.length; i++)
			{

				var statesPack:StatesPack=new StatesPack()
				var normalTexture:Texture=_atlas.getTexture(name + "_" + _sides[i])
				if (normalTexture != null)
				{
					statesPack.normal=new BasicImage(normalTexture)
				}
				var movingTexture:Texture=_atlas.getTexture(name + "_" + _sides[i] + "_moving")
				if (movingTexture != null)
				{
					statesPack.moving=new BasicImage(movingTexture)
				}
				pack[_sides[i]]=statesPack
			}
		}

		private function createAnimatedPack(name:String, pack:SpritesPack):void
		{
			for (var i:int=0; i < _sides.length; i++)
			{
				var statesPack:StatesPack=new StatesPack()
				var normalTexture:Vector.<Texture>=_atlas.getTextures(name + "_" + _sides[i])
				if (normalTexture.length != 0)
				{
					statesPack.normal=new BasicMovieClip(normalTexture, 10)
				}
				var movingTexture:Vector.<Texture>=_atlas.getTextures(name + "_" + _sides[i] + "_moving")
				if (movingTexture.length != 0)
				{
					statesPack.moving=new BasicMovieClip(movingTexture, 10)
				}
				pack[_sides[i]]=statesPack
			}
		}

		private function createEffectPack(name:String, pack:SpritesPack):void
		{

			var normalTexture:Vector.<Texture>=_atlas.getTextures(name)
			if (normalTexture.length != 0)
			{
				pack.effect=new BasicMovieClip(normalTexture, 10)
			}



		}

	}
}
