package examples 
{
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author pautay
	 */
	public class Example05 extends Sprite
	{
		public function Example05() 
		{
			var box:IsoBox = new IsoBox();
			//box.moveTo(25, 0, 0);
			
			var grid:IsoGrid = new IsoGrid();
			//grid.moveTo(15, 15, 0);
			
			var scene:IsoScene = new IsoScene();
			scene.addChild(box);
			scene.addChild(grid);
			scene.render();
			
			var view:IsoView = new IsoView();
			view.setSize(300, 200);
			//view.x = 150;
			//view.y = 150;
			view.addScene(scene);
			addChild(view);
		}
	}
}