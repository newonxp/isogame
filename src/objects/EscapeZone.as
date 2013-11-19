package objects
{
	import as3isolib.display.scene.IsoScene;

	import entities.BasicObject;
	import entities.Bounds;
	import entities.Cell;

	import sprites.SpritesPack;

	public class EscapeZone extends BasicObject
	{
		public function EscapeZone(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null)
		{
			type=Config.coin
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 60)
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, 0, 0, bounds, cell, scene, spritesPack, false, false, false, false);
		}
	}
}
