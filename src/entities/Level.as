package entities
{
	import starling.core.Starling;

	import windows.Game;

	public class Level extends BasicScene
	{
		private var _ui:GameUi 
		private var _lives:int=3
		public function Level()
		{

		}
		override public function init():void{
			_ui = new GameUi(this)
			super.init()
		}
		public function death():void{
			_lives--
			if(_lives==0){
				Game.windowsManager.addGameoverMenu()
			}else{
				_ui.redrawHearts()
			}
			addPlayer(getCellAt(10,10))
		}
		public function floorClicked(floor:BasicObject):void
		{
			_player.walkTo(floor.cell)
		}

		public function get lives():int{
			return _lives
		}


	}
}


