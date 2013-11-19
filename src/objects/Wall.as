package objects
{
	import as3isolib.display.scene.IsoScene;

	import sprites.SpritesPack;
	import entities.BasicObject;
	import entities.Bounds;
	import entities.Cell;

	public class Wall extends BasicObject
	{
		public function Wall(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null)
		{
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 40)
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, 0, 0, bounds, cell, scene, spritesPack, false, true, false, true);
			type=Config.wall
		}
	}
}
