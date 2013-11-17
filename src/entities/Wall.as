package entities
{
	import as3isolib.display.scene.IsoScene;

	import sprites.SpritesPack;

	public class Wall extends BasicObject
	{
		public function Wall(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null)
		{
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 40)
			cell.blocked=true
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, 0, bounds, cell, scene, spritesPack);
			type=Config.wall
		}
	}
}
