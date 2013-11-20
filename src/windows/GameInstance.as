package windows
{
	import entities.BasicScene;
	import entities.Level;

	import flash.events.Event;
	import flash.events.MouseEvent;

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
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, initScene)
			this.addEventListener(flash.events.Event.REMOVED_FROM_STAGE, onRemove)
		}

		private function initScene(e:starling.events.Event):void
		{
			_starling.removeEventListeners(starling.events.Event.ROOT_CREATED)
			Starling.current.showStats=true
			Game.gameManager.currentRoot=Starling.current.root as Level
			Game.gameManager.currentRoot.setLevel(_level)
			stage.addEventListener(MouseEvent.RIGHT_CLICK, rightClicked)
			Game.gameManager.currentRoot.addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame)
		}

		private function onEnterFrame(e:starling.events.Event):void
		{
			Game.gameManager.currentRoot.removeEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame)
			Game.windowsManager.clearScreen()
		}


		private function rightClicked(e:MouseEvent):void
		{
			Game.gameManager.currentRoot.rightClick(e)
		}

		private function onRemove(e:flash.events.Event):void
		{
			stage.removeEventListener(MouseEvent.RIGHT_CLICK, rightClicked)
			Game.gameManager.currentRoot.remove()
			_starling.stop(true)
			_starling.dispose()
			_starling=null
		}

	}
}


