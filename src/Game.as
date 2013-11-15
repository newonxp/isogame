package 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	import game.Logic;

	import resource.ResourceManager;

	import starling.core.Starling;

	import utils.Popup;
	import utils.ResourcePreloader;

	public class Game extends Sprite
	{
		private static var _starling:Starling;
		private static var _resources:resource.ResourceManager
		private static var _resourcePreloader:ResourcePreloader 
		private static var _preloader:Preloader
		public function Game()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,init)
		}
		private function init(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,init)
			addPreloader()
		}
		private function addPreloader():void{
			_preloader = new Preloader()
			addChild(_preloader)
		}
		public function setResources(locale:String):void{
			_resources = new ResourceManager(locale,Config.build_number)
			_resources.set_host("../resources")
			_resourcePreloader = new ResourcePreloader()
			_resourcePreloader.load(resourcesLoaded)
		}
		private function resourcesLoaded():void{
			addScene()
		}
		private function addScene():void{
			_starling = new Starling(game.Logic, stage);
			_starling.start();
		}
		public static function get resources():ResourceManager{
			return _resources
		}
		public static function get preloader():Preloader{
			return _preloader
		}
	}
}

