package
{
	import windows.Game;

	public class GameManager
	{
		private var _currentLevelNumber:int=1
		private var _totalLevels:int=3

		public function GameManager()
		{
			if(Game.storage.have_value("currentLevelNumber")){
				_currentLevelNumber = int(Game.storage.get_value("currentLevelNumber"))
			}else{
				_currentLevelNumber=1
			}
		}

		public function newGame():void
		{
			_currentLevelNumber=1
			saveCurrentLevelNumber()
			Game.windowsManager.removeWindow(Game.windowsManager.mainMenu)
			Game.windowsManager.addGameInstance("level"+_currentLevelNumber)
		}

		public function continueGame():void{
			Game.windowsManager.removeWindow(Game.windowsManager.mainMenu)
			Game.windowsManager.addGameInstance("level"+_currentLevelNumber)
		}

		public function returnToMenu():void
		{
			Game.windowsManager.removeWindow(Game.windowsManager.gameInstance)
			Game.windowsManager.addMainMenu()
		}

		public function nextLevel():void
		{
			_currentLevelNumber++
			saveCurrentLevelNumber()
			Game.windowsManager.removeWindow(Game.windowsManager.winMenu)
			Game.windowsManager.removeWindow(Game.windowsManager.gameInstance)
			Game.windowsManager.addGameInstance("level"+_currentLevelNumber)
		}
		private function saveCurrentLevelNumber():void{
			Game.storage.set_value("currentLevelNumber",_currentLevelNumber)
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

