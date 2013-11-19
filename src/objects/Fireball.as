package objects
{
	import as3isolib.display.scene.IsoScene;

	import flash.events.Event;
	import flash.geom.Rectangle;

	import sprites.SpritesPack;

	import windows.Game;
	import entities.BasicObject;
	import entities.Bounds;
	import entities.Cell;

	public class Fireball extends BasicObject
	{
		private var _explosed:Boolean=false
		private var _shiftX:Number
		private var _shiftY:Number

		public function Fireball(shiftX:Number=0, shiftY:Number=0, scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null)
		{
			_shiftX=shiftX
			_shiftY=shiftY
			type=Config.fireball
			var bounds:Bounds=new Bounds(Config.cell_size * 0.1, Config.cell_size * 0.1, 10)
			super(cell.x * Config.cell_size + Config.cell_size / 2, cell.y * Config.cell_size + Config.cell_size / 2, 20, 0, bounds, cell, scene, spritesPack, false, false, true, true);
			Game.windowsManager.gameInstance.scene.shotsManager.addShot(this, shiftX, shiftY)
		}

		public function tick():void
		{
			if (this.x > 30 * Config.cell_size)
			{
				remove()
			}
		}

		override public function collide(target:BasicObject):void
		{

			Game.windowsManager.gameInstance.scene.addExplosion(x - _shiftX * 5, y - _shiftY * 5)
			_explosed=true

			remove()
		}

		override public function remove():void
		{
			Game.windowsManager.gameInstance.scene.shotsManager.removeShot(this)
			super.remove()
		}

	}
}
