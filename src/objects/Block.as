package objects
{
	import as3isolib.display.scene.IsoScene;

	import flash.geom.Rectangle;

	import sprites.SpritesPack;

	import windows.Game;
	import entities.BasicObject;
	import entities.Bounds;
	import entities.Cell;

	public class Block extends BasicObject
	{
		public function Block(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null)
		{
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 60)
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, 0, 0, bounds, cell, scene, spritesPack, false, true, false, true);
			type=Config.block
		}

		override public function remove():void
		{
			cell.blocked=false
			super.remove()
		}
	}
}


