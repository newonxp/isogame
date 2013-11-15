package game

{ import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.events.IsoEvent;

	import flash.events.MouseEvent;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.text.TextField;

	public class Logic extends Sprite
	{
		public function Logic()
		{
			var box:IsoBox = new IsoBox();
			box.moveTo(0, 0, 0);

			var grid:IsoGrid = new IsoGrid();
			grid.showOrigin = true;
			box.container.addEventListener(MouseEvent.CLICK, onMouseClick)

			var scene:IsoScene = new IsoScene();
			scene.addChild(box);
			scene.addChild(grid);
			scene.render();

			var view:IsoView = new IsoView();
			view.setSize(1024, 768);
			view.addScene(scene);

			addChild(view)

			view.clipContent = false;

		}
		private function onMouseClick(e:MouseEvent):void{
			trace("asdadasd")
		}
	}
}

