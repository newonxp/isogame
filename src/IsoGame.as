package
{
	import flash.display.Sprite;

	import windows.Game;

	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#053557")]
	public class IsoGame extends Sprite
	{

		private var game:Game=new Game()

		public function IsoGame()
		{
			stage.showDefaultContextMenu=false;
			addChild(game)

		}
	}
}

