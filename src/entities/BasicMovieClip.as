package entities
{
	import starling.display.MovieClip;
	import starling.textures.Texture;

	public class BasicMovieClip extends MovieClip
	{
		private var _object:*

		public function BasicMovieClip(textures:Vector.<Texture>, fps:Number=12)
		{
			super(textures, fps);
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
