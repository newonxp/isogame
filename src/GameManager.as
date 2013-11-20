package
{
	import entities.Level;

	import windows.Game;

	public class GameManager
	{
		private var _currentLevelNumber:int=1
		private var _totalLevels:int=3
		private var _currentRoot:Level

		public function GameManager()
		{
			if (Game.storage.have_value("currentLevelNumber"))
			{
				_currentLevelNumber=int(Game.storage.get_value("currentLevelNumber"))
			}
			else
			{
				_currentLevelNumber=1
			}
		}

		public function newGame():void
		{
			_currentLevelNumber=1
			saveCurrentLevelNumber()
			Game.windowsManager.removeWindow(Game.windowsManager.mainMenu)
			Game.windowsManager.addGameInstance("level" + _currentLevelNumber)
		}

		public function continueGame():void
		{
			Game.windowsManager.removeWindow(Game.windowsManager.mainMenu)
			Game.windowsManager.addGameInstance("level" + _currentLevelNumber)
		}

		public function returnToMenu():void
		{
			function func():void
			{
				Game.windowsManager.removeWindow(Game.windowsManager.gameInstance)
				Game.windowsManager.addMainMenu()
			}
			Game.windowsManager.addTransitionScreen(func)
		}

		public function nextLevel():void
		{
			_currentLevelNumber++
			saveCurrentLevelNumber()
			function func():void
			{
				Game.windowsManager.removeWindow(Game.windowsManager.winMenu)
				Game.windowsManager.removeWindow(Game.windowsManager.gameInstance)
				Game.windowsManager.doAddGameInstance("level" + _currentLevelNumber)
			}
			Game.windowsManager.addTransitionScreen(func)
		}

		public function retry():void
		{
			function func():void
			{
				Game.windowsManager.removeWindow(Game.windowsManager.gameoverMenu)
				Game.windowsManager.removeWindow(Game.windowsManager.gameInstance)
				Game.windowsManager.doAddGameInstance("level" + _currentLevelNumber)
			}
			Game.windowsManager.addTransitionScreen(func)
		}

		private function saveCurrentLevelNumber():void
		{
			Game.storage.set_value("currentLevelNumber", _currentLevelNumber)
		}

		public function get currentLevelNumber():int
		{
			return _currentLevelNumber
		}

		public function set currentLevelNumber(val:int):void
		{
			_currentLevelNumber=val
		}

		public function set currentRoot(val:Level):void
		{
			_currentRoot=val
		}


		public function get totalLevels():int
		{
			return _totalLevels
		}

		public function get currentRoot():Level
		{
			return _currentRoot
		}
	}
}

