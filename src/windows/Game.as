package windows
{
	import entities.BasicScene;
	import entities.Level;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	import resource.ResourceManager;

	import starling.core.Starling;

	import utils.Popup;
	import utils.ResourcePreloader;


	public class Game extends BasicWindow
	{
		private static var _resources:resource.ResourceManager
		private static var _resourcePreloader:ResourcePreloader
		private static var _windowsManager:WindowsManager

		public function Game()
		{

		}

		override public function init():void
		{
			_windowsManager=new WindowsManager()
			addChild(_windowsManager)
			//_windowsManager.addPreloader(setResources)
			setResources("ru")
		}

		public function setResources(locale:String):void
		{
			_resources=new ResourceManager(locale, Config.build_number)
			_resources.set_host("../resources")
			_resourcePreloader=new ResourcePreloader(resourcesLoaded)
			_resourcePreloader.load()
		}

		private function resourcesLoaded():void
		{
			_windowsManager.addGameInstance("level1")
		}

		public static function get resources():ResourceManager
		{
			return _resources
		}

		public static function get windowsManager():WindowsManager
		{
			return _windowsManager
		}
	}
}

