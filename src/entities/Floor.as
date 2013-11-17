package entities
{
	import as3isolib.display.scene.IsoScene;

	import sprites.SpritesPack;

	import windows.Game;

	public class Floor extends BasicObject
	{
		public function Floor(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null)
		{
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 10)
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, 0, bounds, cell, scene, spritesPack);
			type=Config.floor
		}

		override public function onLeftClick():void
		{

			Game.windowsManager.gameInstance.scene.floorClicked(this)
		}

		override public function onRightClick():void
		{
			Game.windowsManager.gameInstance.scene.addBlock(cell)
			Game.windowsManager.gameInstance.scene.updateCollisionMap()
			remove()
		}


	}
}
