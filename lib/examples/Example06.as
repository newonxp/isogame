package examples 
{
	import as3isolib.core.ClassFactory;
	import as3isolib.core.IFactory;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.renderers.DefaultShadowRenderer;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	/**
	 * ...
	 * @author pautay
	 */
	public class Example06 extends Sprite 
	{
		private var _scene : IsoScene;
		
		public function Example06() 
		{
			_scene = new IsoScene();
			_scene.hostContainer = this;
			
			var g:IsoGrid = new IsoGrid();
			g.showOrigin = false;
			_scene.addChild(g);
			
			var box:IsoBox = new IsoBox();
			box.setSize(25, 25, 25);
			box.moveBy(20, 20, 15); //feature request added
			_scene.addChild(box);
			
			//var factory:ClassFactory = new ClassFactory(DefaultShadowRenderer);
			//factory.properties = {shadowColor:0x000000, shadowAlpha:0.15, drawAll:false};
			//_scene.styleRenderers = [factory];
			
			var factory:ClassFactory = new ClassFactory(DefaultShadowRenderer);
			factory.properties = {shadowColor:0xFF0000, shadowAlpha:1.0, drawAll:false};
			_scene.styleRenderers = [factory];
			
			var view:IsoView = new IsoView();
			view.setSize(480, 320);
			view.addScene(_scene);
			//view.scene = scene; //look in the future to be able to add more scenes
			
			addChild(view);
			
			_scene.render();
			
			
		}
		
		
		
	}

}