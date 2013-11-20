package objects
{
	import as3isolib.display.scene.IsoScene;

	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;

	import entities.BasicObject;
	import entities.Bounds;
	import entities.Cell;

	import sprites.SpritesPack;

	public class Coin extends BasicObject
	{
		public function Coin(scene:IsoScene=null, spritesPack:SpritesPack=null, cell:Cell=null)
		{
			type=Config.coin
			var bounds:Bounds=new Bounds(Config.cell_size, Config.cell_size, 60)
			super(cell.x * Config.cell_size, cell.y * Config.cell_size, 25, 0, bounds, cell, scene, spritesPack, false, false, false, true);
		}

		public function animateOut():void
		{
			removeCollisionRect()
			TweenMax.to(this, 0.5, {z: 50, alpha: 0, ease: com.greensock.easing.Sine.easeIn, onComplete: function():void
			{
				remove()
			}})
		}
	}
}


