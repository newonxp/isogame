package entities
{

	import flash.display.Bitmap;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import windows.Game;

	public class GameUi
	{
		private var _container:Level 
		private var _spritesheet_src:String="img/spritesheet.png"
		private var _spritesheetXml_src:String="xml/spritesheet.xml"
		private var _spritesheet:Bitmap
		private var _atlas:TextureAtlas
		private var _heartTexture:Texture
		private var _heartImage:Image 
		private var _heartContainer:Sprite
		public function GameUi(container:Level)
		{
			_container = container
			_spritesheet=new Bitmap()
			_spritesheet=Game.resources.get_img(_spritesheet_src).data
			_heartContainer = new Sprite()
			init()

		}
		private function init():void{
			var texture:Texture=Texture.fromBitmap(_spritesheet)
			var xml:XML=Game.resources.get_xml(_spritesheetXml_src).data
			_atlas=new TextureAtlas(texture, xml)
			_heartTexture= _atlas.getTexture("wall_n")
			var uiContainer:Sprite = new Sprite()

			var tf:TextField = new TextField(200,80,"test")
			tf.alignPivot("left","top")
			tf.x=0
			tf.y=0	
			_container.addChild(_heartContainer)
			renderHearts()
		}
		private function renderHearts():void{
			for(var i:int = 0;i<_container.lives;i++){
				trace("Сердечки = "+i)
				_heartImage = new Image(_heartTexture)
				_heartImage.x=i*100
				_heartContainer.addChild(_heartImage)
			}
		}
		public function redrawHearts():void{
			trace("перерисовываем")
			_container.removeChild(_heartContainer)
			_heartContainer = new Sprite()
			_container.addChild(_heartContainer)
			renderHearts()
		}
	}
}

