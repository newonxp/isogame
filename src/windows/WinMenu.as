package windows
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;

	import entities.Buttons;
	import entities.MySimpleButton;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class WinMenu extends BasicMenu
	{

		private var _assetSrc:String="ui/win_menu.swf@win_menu"
		private var _logo:DisplayObject
		private var _nextLevel:MySimpleButton
		private var _main_menu:MySimpleButton

		public function WinMenu()
		{
			super(_assetSrc);
		}

		override public function init():void
		{
			super.init()
			_logo=asset.getChildByName("logo")
			replaceButtons()
			animateIn()
		}

		private function replaceButtons():void
		{
			_nextLevel=Buttons.change_btn(asset, "nextLevel", Buttons.nextLevel)
			_main_menu=Buttons.change_btn(asset, "mainMenu", Buttons.mainMenu)

			_nextLevel.addEventListener(MouseEvent.CLICK, onNextLevel)
			_main_menu.addEventListener(MouseEvent.CLICK, onMainMenu)
			if (Game.gameManager.currentLevelNumber == Game.gameManager.totalLevels)
			{
				_nextLevel.disable(true)
			}
		}

		private function onNextLevel(e:MouseEvent):void
		{
			Game.gameManager.nextLevel()
		}

		private function onMainMenu(e:MouseEvent):void
		{
			Game.windowsManager.removeWindow(this)
			Game.gameManager.returnToMenu()
		}


		private function animateIn():void
		{
			TweenLite.from(_logo, 0.3, {x: _logo.x + 300, alpha: 0, ease: com.greensock.easing.Back.easeOut})
			TweenLite.from(_nextLevel, 0.3, {x: _nextLevel.x - 300, alpha: 0, delay: 0.1, ease: com.greensock.easing.Back.easeOut})
			TweenLite.from(_main_menu, 0.3, {x: _main_menu.x + 300, alpha: 0, delay: 0.2, ease: com.greensock.easing.Back.easeOut})
		}
	}
}

