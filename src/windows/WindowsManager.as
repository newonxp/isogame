package windows
{
	import flash.display.Sprite;

	public class WindowsManager extends Sprite
	{
		private var _preloader:Preloader
		private var _gameInstance:GameInstance

		public function WindowsManager()
		{

		}

		public function addPreloader(callback:Function=null):void
		{
			_preloader=new Preloader(callback)
			addChild(_preloader)
		}

		public function addGameInstance(level:String):void
		{
			_gameInstance=new GameInstance(level)
			addChild(_gameInstance)
		}

		public function removeWindow(window:BasicWindow):void
		{
			removeChild(window)
		}

		public function get preloader():Preloader
		{
			return _preloader
		}

		public function get gameInstance():GameInstance
		{
			return _gameInstance
		}

	}
}
