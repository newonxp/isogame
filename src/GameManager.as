package
{
	import windows.Game;

	public class GameManager
	{
		public function GameManager()
		{
		}
		public function newGame():void{
			Game.windowsManager.removeWindow(Game.windowsManager.mainMenu)
			Game.windowsManager.addGameInstance("level1")
		}
		public function returnToMenu():void{
			Game.windowsManager.removeWindow(Game.windowsManager.gameInstance)
			Game.windowsManager.addMainMenu()
		}
	}
}

