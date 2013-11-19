package objects
{
	import as3isolib.display.scene.IsoScene;

	import entities.BasicImage;
	import entities.BasicObject;
	import entities.Bounds;
	import entities.Cell;

	import sprites.SpritesPack;

	public class Wall extends BasicObject
	{
		public function Wall(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null)
		{
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 40)
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, -1, 0, bounds, cell, scene, spritesPack, false, true, false, true);
			type=Config.wall
			var img:BasicImage=_sprite.sprites[0] as BasicImage
			if (cell.x != 0 && cell.y != 0)
			{
				alpha=0.8
			}
		}
	}
}
