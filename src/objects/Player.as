package objects
{
	import as3isolib.display.scene.IsoScene;

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.motionPaths.LinePath2D;

	import entities.BasicObject;
	import entities.Bounds;
	import entities.Cell;
	import entities.Level;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import sprites.SpritesPack;

	import starling.core.Starling;

	import windows.Game;

	public class Player extends BasicObject
	{
		private var _pathStage:int=0
		private var _path:Object

		public function Player(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null)
		{
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 1)
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, 0, 0, bounds, cell, scene, spritesPack, false, true, true, true);

			type=Config.player
		}

		public function walkTo(newCell:Cell):void
		{
			if (!newCell.blocked)
			{
				_path=Game.windowsManager.gameInstance.scene.getPath(new Point(cell.x, cell.y), new Point(newCell.x, newCell.y), false)
				if (_path != null)
				{
					var path:LinePath2D=new LinePath2D(_path.path);
					path.addFollower(this);
					TweenMax.killTweensOf(this)
					TweenMax.to(path, _path.length * Config.playerSpeed, {progress: 1, ease: com.greensock.easing.Linear.easeNone});
				}
			}
		}

		override public function collide(target:BasicObject):void
		{
			trace("collide")
			if (target.type == Config.enemy||target.type == Config.fireball)
			{
				trace("enemy")
				var level:Level = Starling.current.root as Level
				level.death()
				remove()
			}
		}

		override public function moveTo(x:Number=0, y:Number=0, z:Number=0):void{
			Game.windowsManager.gameInstance.scene.pan(x,y)
			super.moveTo(x,y,z)
		}
		override public function remove():void
		{
			Game.windowsManager.gameInstance.scene.collisionDetector.removeRect(this)
			super.remove()
		}

	}
}


