package examples
{
        import as3isolib.display.primitive.IsoBox;
        import as3isolib.display.scene.IsoScene;
		import starling.display.Sprite;
        
        
        
        public class Example02 extends Sprite
        {
                public function Example02 ()
                {
					var box0:IsoBox = new IsoBox();
					box0.setSize(25, 25, 25);
					box0.moveTo(200, 0, 0);
					
					var box1:IsoBox = new IsoBox();
					box1.width = 10;
					box1.length = 25;
					box1.height = 50;
					box1.moveTo(200, -25, 20);
					
					var box2:IsoBox = new IsoBox();
					box2.setSize(10, 50, 5);
					box2.moveTo(200, 50, 10);
					
					var scene:IsoScene = new IsoScene();
					scene.hostContainer = this;
					scene.addChild(box2);
					scene.addChild(box1);
					scene.addChild(box0);
					scene.render();
                }
        }
}