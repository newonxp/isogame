package objects
{
	import as3isolib.display.scene.IsoScene;

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
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
		private var _path:LinePath2D
		private var _placed:Boolean=false


		public function Player(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null)
		{
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 1)
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, 0, 0, bounds, cell, scene, spritesPack, false, true, true, true);

			type=Config.player
		}

		override public function addedOnStage():void
		{
			TweenMax.from(this, 1.4, {z: 100, ease: com.greensock.easing.Bounce.easeOut, onComplete: function():void
			{
				_placed=true
			}})
		}

		override public function walkTo(start:Point, end:Point):void
		{
			if (_placed == true)
			{
				super.walkTo(start, end)
			}
		}

		override public function collide(target:BasicObject):void
		{
			if (target.type == Config.enemy || target.type == Config.fireball)
			{
				var level:Level=Starling.current.root as Level
				level.death()
				remove()
			}
			else if (target.type == Config.coin)
			{
				var coin:Coin=target as Coin
				coin.animateOut()
				Game.windowsManager.gameInstance.scene.addCoinsScore()
			}
		}

		override public function moveTo(x:Number=0, y:Number=0, z:Number=0):void
		{
			Game.windowsManager.gameInstance.scene.pan(x, y)
			super.moveTo(x, y, z)
			Game.windowsManager.gameInstance.scene.checkWinCell(cell)
		}

		override public function remove():void
		{
			Game.windowsManager.gameInstance.scene.collisionDetector.removeRect(this)
			super.remove()
		}

	}
}


