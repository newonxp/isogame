package examples
{
        import as3isolib.display.primitive.IsoBox;
        import as3isolib.display.scene.IsoScene;
				
		import starling.display.Sprite;
		import starling.events.EnterFrameEvent;
        
        
        
        public class Example09 extends Sprite
        {
			private var _scene : IsoScene;
			private var _box1 : IsoBox;
			private var _box0 : IsoBox;
			
			private var _mover : Number;
			
			public function Example09 ()
			{
				_box0 = new IsoBox();
				_box0.setSize(25, 25, 25);
				_box0.moveTo(200, 50, 10);
				
				_box1 = new IsoBox();
				_box1.width = 25;
				_box1.length = 25;
				_box1.height = 25;
				_box1.moveTo(200, -25, 10);			
				
				_scene = new IsoScene();
				_scene.hostContainer = this;				
				_scene.addChild(_box1);
				_scene.addChild(_box0);
				_scene.render();
				
				_mover = _box0.y;				
				addEventListener(EnterFrameEvent.ENTER_FRAME, _step);
			}
			
			private function _step(e:EnterFrameEvent) : void 
			{			
				if (_mover > -60)
				{
					_mover--;
					_box0.y = _mover;
					_scene.render();
				}
			}			
        }
}