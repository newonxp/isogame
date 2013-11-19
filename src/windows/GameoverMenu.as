package windows
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;

	import entities.Buttons;
	import entities.MySimpleButton;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class GameoverMenu extends BasicMenu{

		private var _assetSrc:String="ui/game_over.swf@game_over_menu"
		private var _logo:DisplayObject
		private var _retry:MySimpleButton
		private var _main_menu:MySimpleButton

		public function GameoverMenu()
		{
			super(_assetSrc);
		}
		override public function init():void{
			super.init()
			_logo = asset.getChildByName("logo")
			replaceButtons()
			animateIn()
		}
		private function replaceButtons():void{
			_retry= Buttons.change_btn(asset,"retry",Buttons.retry)
			_main_menu= Buttons.change_btn(asset,"mainMenu",Buttons.mainMenu)

			_retry.addEventListener(MouseEvent.CLICK,onRetry)
			_main_menu.addEventListener(MouseEvent.CLICK,onMainMenu)
		}

		private function onRetry(e:MouseEvent):void{

		}
		private function onMainMenu(e:MouseEvent):void{
			Game.gameManager.returnToMenu()
		}


		private function animateIn():void{
			TweenLite.from(_logo,0.3,{x:_logo.x+300,alpha:0,ease:com.greensock.easing.Back.easeOut})
			TweenLite.from(_retry,0.3,{x:_retry.x-300,alpha:0,delay:0.1,ease:com.greensock.easing.Back.easeOut})
			TweenLite.from(_main_menu,0.3,{x:_main_menu.x+300,alpha:0,delay:0.2,ease:com.greensock.easing.Back.easeOut})
		}
	}
}

