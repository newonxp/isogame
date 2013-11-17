package entities
{
	import as3isolib.display.scene.IsoScene;

	import com.greensock.TweenLite;
	import com.greensock.motionPaths.LinePath2D;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import sprites.SpritesPack;

	import windows.Game;

	public class Player extends BasicObject
	{
		private var _pathStage:int=0
		private var _path:Vector.<Point>

		public function Player(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null)
		{
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 10)
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, 20, bounds, cell, scene, spritesPack);
			Game.windowsManager.gameInstance.scene.collisionDetector.registerRect(new Rectangle(x, y, Config.cell_size, Config.cell_size), this)
			type=Config.player
		}


		public function walkTo(newCell:Cell):void
		{
			//var path:LinePath2D=new LinePath2D(Game.windowsManager.gameInstance.scene.getPath(new Point(cell.x, cell.y), new Point(newCell.x, newCell.y), false))
			_path=Game.windowsManager.gameInstance.scene.getPath(new Point(cell.x, cell.y), new Point(newCell.x, newCell.y), false)
			//_path=Game.windowsManager.gameInstance.scene.getPath(new Point(cell.x + 1, cell.y + 1), new Point(newCell.x + 1, newCell.y + 1), false)

			checkPath()
		}

		private function gotoToNextStep(x:Number, y:Number):void
		{
			TweenLite.to(this, 0.5, {x: x, y: y, z: this.z, onComplete: checkPath})
		}

		private function checkPath():void
		{
			if (_pathStage < _path.length)
			{
				gotoToNextStep(_path[_pathStage].x * Config.cell_size, _path[_pathStage].y * Config.cell_size)
				_pathStage++
			}
			else
			{
				_pathStage=0
			}
		}

		override public function moveTo(x:Number=0, y:Number=0, z:Number=0):void
		{
			Game.windowsManager.gameInstance.scene.collisionDetector.updateRect(new Rectangle(x, y, Config.cell_size, Config.cell_size), this)
			super.moveTo(x, y, z)
		}

		override public function collide(target:BasicObject):void
		{
			if (target.type == Config.enemy)
			{
				remove()
			}
		}
	}
}
