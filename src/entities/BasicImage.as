package entities
{
	import starling.display.Image;
	import starling.textures.Texture;

	public class BasicImage extends Image
	{
		private var _object:*

		public function BasicImage(texture:Texture)
		{
			super(texture);
		}

		public function setAs3IsoObject(object:*):void
		{
			_object=object
		}

		public function get object():*
		{
			return _object
		}
	}
}

