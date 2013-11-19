package entities
{
	import starling.core.Starling;

	public class Level extends BasicScene
	{
		var _ui:GameUi 
		public function Level()
		{

		}
		override public function init():void{
			_ui = new GameUi(this)
		}
		public function floorClicked(floor:BasicObject):void
		{
			_player.walkTo(floor.cell)
		}

	}
}


