package entities
{
	import as3isolib.display.scene.IsoScene;

	import sprites.SpritesPack;

	public class Explosion extends BasicEffect
	{
		public function Explosion(x:Number=0, y:Number=0, z:Number=0, scene:IsoScene=null, spritesPack:SpritesPack=null)
		{
			var bounds:Bounds=new Bounds(Config.cell_size * 0.1, Config.cell_size * 0.1, 10)
			super(x, y, z, bounds, scene, spritesPack);
		}
	}
}
