package entities
{
	import entities.MySimpleButton;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.text.TextField;

	import resource.ResourceManager

	import windows.Game;


	public class Buttons
	{
		public static const continueB:String="ui/buttons.swf@continue"
		public static const newGame:String="ui/buttons.swf@newGame"
		public static const about:String="ui/buttons.swf@about"
		public static const retry:String="ui/buttons.swf@retry"
		public static const mainMenu:String="ui/buttons.swf@mainMenu"
		public static const nextLevel:String="ui/buttons.swf@nextLevel"

		public static function change_btn(container:DisplayObjectContainer, btn_name:String, id:String, text:String="", textStyle:String=""):MySimpleButton
		{
			var src:DisplayObject=container.getChildByName(btn_name)
			var btn:MySimpleButton=new MySimpleButton(get_button(id))
			btn.name=src.name
			btn.x=src.x
			btn.y=src.y
			btn.scaleX=src.scaleX
			btn.scaleY=src.scaleY
			container.addChildAt(btn, container.getChildIndex(src))
			container.removeChild(src)
			return btn
		}

		public static function get_res(id:String):DisplayObjectContainer
		{
			if (id.charAt(id.length - 1) == '_')
			{
				return Game.resources.get_img(id.slice(0, id.length - 1)).data as DisplayObjectContainer
			}
			else
			{
				return Game.resources.get_img(id).data as DisplayObjectContainer
			}
		}

		public static function get_button(id:String):DisplayObjectContainer
		{
			var btn:DisplayObjectContainer=get_res(id)

			disable_text_mouse(btn)

			var container:DisplayObjectContainer=btn as DisplayObjectContainer

			return btn
		}

		public static function disable_text_mouse(obj:DisplayObjectContainer):void
		{
			var container:DisplayObjectContainer=obj
			if (!container)
			{
				return
			}

			for (var i:int=0; i < container.numChildren; ++i)
			{
				var child:InteractiveObject=container.getChildAt(i) as InteractiveObject
				if (child)
				{
					child.mouseEnabled=child as SimpleButton != null
				}
			}
		}
	}
}
