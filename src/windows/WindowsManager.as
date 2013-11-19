package windows
{
	import flash.display.Sprite;

	public class WindowsManager extends Sprite
	{
		private var _preloader:Preloader
		private var _gameInstance:GameInstance
		private var _mainMenu:MainMenu

		public function WindowsManager()
		{

		}

		public function addPreloader(callback:Function=null):void
		{
			_preloader=new Preloader(callback)
			addWindow(_preloader)
		}

		public function addGameInstance(level:String):void
		{
			_gameInstance=new GameInstance(level)
			addWindow(_gameInstance)
		}

		public function addMainMenu():void{
			_mainMenu=new MainMenu()
			addWindow(_mainMenu)
		}

		private function addWindow(window:BasicWindow):void
		{
			addChild(window)
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


