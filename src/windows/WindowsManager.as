package windows
{
	import flash.display.Sprite;

	public class WindowsManager extends Sprite
	{
		private var _preloader:Preloader
		private var _gameInstance:GameInstance
		private var _mainMenu:MainMenu
		private var _gameoverMenu:GameoverMenu
		private var _winMenu:WinMenu
		private var _transitionScreen:TransitionScreen

		public function WindowsManager()
		{

		}

		public function addPreloader(callback:Function=null, callback2:Function=null):void
		{
			_preloader=new Preloader(callback, callback2)
			addWindow(_preloader)
		}

		public function addGameInstance(level:String):void
		{
			function func ():void{
				Game.windowsManager.doAddGameInstance(level)
			}
			addTransitionScreen(func)
		}
		public function doAddGameInstance(level:String):void{
			_gameInstance=new GameInstance(level)
			addWindow(_gameInstance)
		}

		public function addMainMenu():void
		{
			_mainMenu=new MainMenu()
			addWindow(_mainMenu)
		}

		public function addGameoverMenu():void
		{
			_gameoverMenu=new GameoverMenu()
			addWindow(_gameoverMenu)
		}

		public function addWinMenu():void
		{
			_winMenu=new WinMenu()
			addWindow(_winMenu)
		}

		public function addTransitionScreen(callback:Function):void{
			_transitionScreen = new TransitionScreen(callback)
			addWindow(_transitionScreen)
		}

		public function clearScreen():void{
			if(_transitionScreen!=null){
				_transitionScreen.remove()
			}
		}

		private function addWindow(window:BasicWindow):void
		{
			addChild(window)
		}

		public function removeWindow(window:BasicWindow):void
		{
			if(window!=null){
				removeChild(window)
				window=null
			}
		}

		public function get preloader():Preloader
		{
			return _preloader
		}

		public function get mainMenu():MainMenu
		{
			return _mainMenu
		}

		public function get gameInstance():GameInstance
		{
			return _gameInstance
		}

		public function get gameoverMenu():GameoverMenu
		{
			return _gameoverMenu
		}
		public function get winMenu():WinMenu
		{
			return _winMenu
		}
	}
}


