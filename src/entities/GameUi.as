package entities
{

	import flash.display.Bitmap;

	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import windows.Game;

	public class GameUi
	{
		private var _container:Sprite 
		private var _spritesheet_src:String="img/spritesheet.png"
		private var _spritesheetXml_src:String="xml/spritesheet.xml"
		private var _spritesheet:Bitmap
		private var _atlas:TextureAtlas
		public function GameUi(container:Sprite)
		{
			_container = container
			_spritesheet=new Bitmap()
			_spritesheet=Game.resources.get_img(_spritesheet_src).data
			var texture:Texture=Texture.fromBitmap(_spritesheet)
			var xml:XML=Game.resources.get_xml(_spritesheetXml_src).data
			_atlas=new TextureAtlas(texture, xml)
			init()

		}
		private function init():void{
			//var spriteTexture:Texture= _atlas.getTexture("wall_n")

		}
	}
}

