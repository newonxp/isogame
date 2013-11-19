package windows
{
	import entities.BasicScene;
	import entities.Level;

	import flash.events.MouseEvent;

	import starling.core.Starling;
	import starling.events.Event;

	public class GameInstance extends BasicWindow
	{
		private var _level:String
		private static var _starling:Starling;
		private var _scene:Level

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
				Starling.current.showStats=true
				_scene=Starling.current.root as Level
				_scene.setLevel(_level)
			/*	stage.addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void
				{
					_scene.rightClick(e)
				})*/
			})

		}

		public function get scene():Level
		{
			return _scene
		}
	}
}


