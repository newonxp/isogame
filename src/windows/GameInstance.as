package windows
{
	import entities.BasicScene;
	import entities.Level;

	import starling.core.Starling;
	import starling.events.Event;

	public class GameInstance extends BasicWindow
	{
		private var _level:String
		private static var _starling:Starling;

		public function GameInstance(level:String="")
		{
			_level=level
			super();
		}

		override public function init():void
		{
			_starling=new Starling(Level, stage);
			_starling.start();
			_starling.addEventListener(Event.ROOT_CREATED, function():void
			{
				var scene:Level=Starling.current.root as Level
				scene.setLevel(_level)
			})

		}
	}
}
