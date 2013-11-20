package windows
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class BasicWindow extends Sprite
	{
		public function BasicWindow()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
		}

		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
			init()
		}

		public function init():void
		{

		}

		public function activate():void
		{

		}

		public function disactivate():void
		{

		}

		public function remove():void
		{
			Game.windowsManager.removeWindow(this)
		}

	}
}


