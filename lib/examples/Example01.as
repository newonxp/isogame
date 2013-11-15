package examples
{
		import as3isolib.display.IsoSprite;
        import as3isolib.display.primitive.IsoBox;
        import as3isolib.display.scene.IsoScene;
		import as3isolib.enum.RenderStyleType;
		import starling.display.Sprite;
        
        public class Example01 extends Sprite
        {
			public function Example01 ()
			{
				var box:IsoBox = new IsoBox();
				//var box:IsoSprite = new IsoSprite();
				
				box.styleType = RenderStyleType.WIREFRAME;
				box.setSize(50, 50, 50);
				box.moveTo(480/2, 0, 0);
				
				var scene:IsoScene = new IsoScene();
				scene.hostContainer = this;
				scene.addChild(box);
				scene.render();
			}
        }
}