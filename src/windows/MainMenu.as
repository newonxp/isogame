package windows
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;

	import entities.Buttons;
	import entities.MySimpleButton;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class MainMenu extends BasicMenu
	{
		private var _logo:DisplayObject
		private var _continue:MySimpleButton
		private var _newGame:MySimpleButton
		private var _titles:MySimpleButton
		private var _assetSrc:String="ui/main_menu.swf@main_menu"
		public function MainMenu()
		{
			super(_assetSrc);
		}
		override public function init():void{
			super.init()
			_logo = asset.getChildByName("logo")
			replaceButtons()
			animateIn()
			Game.windowsManager.clearScreen()
		}
		private function replaceButtons():void{
			_continue= Buttons.change_btn(asset,"continueB",Buttons.continueB)
			_newGame= Buttons.change_btn(asset,"newGame",Buttons.newGame)
			_titles= Buttons.change_btn(asset,"about",Buttons.about)
			_continue.addEventListener(MouseEvent.CLICK,onCont)
			_newGame.addEventListener(MouseEvent.CLICK,onNewGame)
			_titles.addEventListener(MouseEvent.CLICK,onAbout)
			if(Game.gameManager.currentLevelNumber==1){
				_continue.disable(true)
			}
		}
		private function onCont(e:MouseEvent):void{
			Game.gameManager.continueGame()
		}
		private function onNewGame(e:MouseEvent):void{
			Game.gameManager.newGame()
		}
		private function onAbout(e:MouseEvent):void{
			trace("onAbout")
		}
		private function animateIn():void{
			TweenLite.from(_logo,0.3,{x:_logo.x+300,alpha:0,ease:com.greensock.easing.Back.easeOut})
			TweenLite.from(_continue,0.3,{x:_continue.x-300,alpha:0,delay:0.1,ease:com.greensock.easing.Back.easeOut})
			TweenLite.from(_newGame,0.3,{x:_newGame.x+300,alpha:0,delay:0.2,ease:com.greensock.easing.Back.easeOut})
			TweenLite.from(_titles,0.3,{x:_titles.x-300,alpha:0,delay:0.3,ease:com.greensock.easing.Back.easeOut})
		}
	}
}

