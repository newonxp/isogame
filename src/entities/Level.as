package entities
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	import starling.core.Starling;

	import windows.Game;

	public class Level extends BasicScene
	{
		private var _ui:GameUi
		private var _lives:int=3
		private var _win:Boolean=false
		private var _startTimer:Timer

		public function Level()
		{

		}

		override public function init():void
		{
			_startTimer=new Timer(2000, 1)
			_startTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void
			{
				addPlayer(startPoint)
				//cameraControl.moveToObject(player, 2)
			})
			_startTimer.start()

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
				player.walkTo(new Point(player.cell.x, player.cell.y), new Point(floor.cell.x, floor.cell.y))
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


