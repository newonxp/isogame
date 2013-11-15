package examples 
{
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.enum.RenderStyleType;
	import as3isolib.graphics.SolidColorFill;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author pautay
	 */
	public class Example03 extends Sprite
	{
		
		public function Example03() 
		{
			var box:IsoBox = new IsoBox();
			//box.styleType = RenderStyleType.SHADED;
			
			var alpha:Number = 0.1;
			var a:SolidColorFill = new SolidColorFill(0xff0000, alpha); //top
			var b:SolidColorFill = new SolidColorFill(0x00ff00, alpha); //facing side right
			var c:SolidColorFill = new SolidColorFill(0x0000ff, alpha); //facing side left
			var d:SolidColorFill = new SolidColorFill(0xff0000, alpha); //rear side right
			var e:SolidColorFill = new SolidColorFill(0x00ff00, alpha); //rear side left
			var f:SolidColorFill = new SolidColorFill(0x0000ff, alpha); //bottom
			box.fills = [a, b, c, d, e, f];
			box.setSize(50, 50, 50);
			box.moveTo(200, 0, 0);
			
			var scene:IsoScene = new IsoScene();
			scene.hostContainer = this;
			scene.addChild(box);
			scene.render();
		}
		
	}

}