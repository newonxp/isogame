package
{
	import windows.Game;

	public class GameManager
	{
		private var _currentLevelNumber:int=3
		private var _totalLevels:int=3

		public function GameManager()
		{
		}

		public function newGame():void
		{
			Game.windowsManager.removeWindow(Game.windowsManager.mainMenu)
			Game.windowsManager.addGameInstance("level1")
		}

		public function returnToMenu():void
		{
			Game.windowsManager.removeWindow(Game.windowsManager.gameInstance)
			Game.windowsManager.addMainMenu()
		}

		public function nextLevel():void
		{
			_currentLevelNumber++

		}

		public function get currentLevelNumber():int
		{
			return _currentLevelNumber
		}

		public function set currentLevelNumber(val:int):void
		{
			_currentLevelNumber=val
		}

		public function get totalLevels():int
		{
			return _totalLevels
		}
	}
}

