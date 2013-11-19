package entities
{
	import flash.geom.Point;

	import starling.core.Starling;

	import windows.Game;

	public class Level extends BasicScene
	{
		private var _ui:GameUi
		private var _lives:int=3
		private var _win:Boolean=false

		public function Level()
		{

		}

		override public function init():void
		{
			_ui=new GameUi(this)
			super.init()
		}

		public function death():void
		{
			_lives--
			if (_lives == 0)
			{
				_ui.redrawHearts()
				Game.windowsManager.addGameoverMenu()
			}
			else
			{
				_ui.redrawHearts()
			}
			addPlayer(getCellAt(startPoint.x, startPoint.y))
		}

		public function floorClicked(floor:BasicObject):void
		{
			if (!floor.cell.blocked)
			{
				_player.walkTo(new Point(_player.cell.x, _player.cell.y), new Point(floor.cell.x, floor.cell.y))
			}
		}

		public function checkWinCell(cell:Cell):void
		{
			if (cell == endPoint && _win == false)
			{
				_win=true
				Game.windowsManager.addWinMenu()
			}
		}

		public function get lives():int
		{
			return _lives
		}

		public function addCoinsScore():void
		{

		}


	}
}


