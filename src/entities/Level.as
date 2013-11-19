package entities
{
	import starling.core.Starling;

	public class Level extends BasicScene
	{
		public function Level()
		{

		}

		public function floorClicked(floor:BasicObject):void
		{
			_player.walkTo(floor.cell)
		}

	}
}
