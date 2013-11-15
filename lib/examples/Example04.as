package examples 
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import flash.display.Bitmap;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author pautay
	 */
	public class Example04 extends Sprite
	{
		[Embed(source = "../../lib/tile.png")]
		public static const TILE : Class;
		
		public function Example04()
		{
			var scene: IsoScene = new IsoScene();
			scene.hostContainer = this; //it is recommended to use an IsoView
			
			var tile : Bitmap = new TILE();
			var img: Image = new Image(Texture.fromBitmap(tile));
			
			//place origin point on tile
			img.pivotX = img.width/2; 
			img.pivotY = 13;
			
			var grid:IsoGrid = new IsoGrid();
			//grid.showOrigin = false;
			scene.addChild(grid);
			
			var s0:IsoSprite = new IsoSprite();
			s0.setSize(49, 49, 12);
			s0.moveTo(0, 0, 0);
			s0.sprites = [img];
			scene.addChild(s0);
			
			var view : IsoView = new IsoView();
			view.setSize(480, 320);
			view.addScene(scene);
			addChild(view);
			
			scene.render();
		}
	}
}