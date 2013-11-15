package examples 
{
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	/**
	 * ...
	 * @author pautay
	 */
	public class Example08 extends Sprite
	{
		private var view:IsoView;
		private var scene:IsoScene;
		private var gridHolder:IsoScene; 
		private var grid:IsoGrid;
		private var box:IsoBox;
		
		private var panPt:Point;
		private var zoom:Number = 1;
 
		public function Example08() 
		{
			view = new IsoView();
			view.setSize((Starling.current.viewPort.width), Starling.current.viewPort.height );
			view.clipContent = true;
			view.showBorder = false;
			Main.STAGE.addEventListener(MouseEvent.MOUSE_DOWN, viewMouseDown);
			Main.STAGE.addEventListener(MouseEvent.MOUSE_WHEEL, viewZoom);

			addChild(view);
	 
			gridHolder = new IsoScene();
			view.addScene(gridHolder);
	 
			scene = new IsoScene();
			view.addScene(scene);
	 
			grid = new IsoGrid();
			grid.cellSize = 40;
			grid.setGridSize(5, 5, 0);
			gridHolder.addChild(grid);
	 
			box = new IsoBox();
			box.setSize(40, 40, 40);
			box.moveTo(80, 80, 0);
			scene.addChild(box);
	 
			gridHolder.render();
			scene.render();
		}
		
		private function viewMouseDown(e:MouseEvent) : void
		{
			panPt = new Point(Main.STAGE.mouseX, Main.STAGE.mouseY);
			Main.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, viewPan);
			Main.STAGE.addEventListener(MouseEvent.MOUSE_UP, viewMouseUp);
		}
		
		private function viewMouseUp(e:MouseEvent) : void
		{
			Main.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, viewPan);
			Main.STAGE.removeEventListener(MouseEvent.MOUSE_UP, viewMouseUp);
		}
		
		private function viewPan(e:MouseEvent) : void
		{
			view.panBy(panPt.x - Main.STAGE.mouseX, panPt.y - Main.STAGE.mouseY);
			panPt.x = Main.STAGE.mouseX;
			panPt.y = Main.STAGE.mouseY;
		}
		
		private function viewZoom(e:MouseEvent) : void
		{
			if(e.delta > 0)
			{
				zoom +=  0.10;
			}
			if(e.delta < 0)
			{
				zoom -=  0.10;
			}
			
			if (zoom < 0) zoom = 0;
			view.currentZoom = zoom;
		}
	}
}