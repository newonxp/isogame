package entities
{
	import as3isolib.display.scene.IsoScene;

	import starling.display.Image;
	import sprites.SpritesPack;

	public class StaticObject extends BasicObject
	{
		public function StaticObject(scene:IsoScene=null, animated:Boolean=false, sprites:SpritesPack=null, cell:Cell=null)
		{
			super(scene, animated, sprites, cell)
		}

	}
}
