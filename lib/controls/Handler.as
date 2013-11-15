package controls 
{
	import starling.core.Starling;
	import starling.display.Quad;
	/**
	 * ...
	 * @author pautay
	 */
	public class Handler extends Quad
	{		
		public function Handler() 
		{
			Locator.HANDLER = this;
			super(Starling.current.viewPort.width, Starling.current.viewPort.height, 0, true);
			alpha = 0.2;
		}
	}
}