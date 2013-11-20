package objects
{
	import as3isolib.display.scene.IsoScene;

	import entities.BasicObject;
	import entities.Bounds;
	import entities.Cell;

	import sprites.SpritesPack;

	import starling.filters.ColorMatrixFilter;

	import windows.Game;

	public class Floor extends BasicObject
	{
		public function Floor(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null)
		{
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 10)
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, -12, 0, bounds, cell, scene, spritesPack, true);
			type=Config.floor
		}

		override public function onLeftClick():void
		{
			Game.gameManager.currentRoot.floorClicked(this)
		}

		override public function onRightClick():void
		{
			if (Game.gameManager.currentRoot.isNearPlayer(cell))
			{
				Game.gameManager.currentRoot.addBlock(cell)
				Game.gameManager.currentRoot.updateCollisionMap()

			}
		}

		override public function onMouseOver():void
		{
			if (Game.gameManager.currentRoot.isNearPlayer(cell))
			{
				var colorMatrixFilter:ColorMatrixFilter=new ColorMatrixFilter()
				colorMatrixFilter.adjustBrightness(0.1);
				colorMatrixFilter.adjustHue(0.3);
				_sprite.actualSprites[0].filter=colorMatrixFilter;
			}
			else
			{
				super.onMouseOver()
			}
		}
	}
}
