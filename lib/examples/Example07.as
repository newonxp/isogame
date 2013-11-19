package examples
{
	import starling.display.Quad;
	import starling.events.Event;
	import flash.events.MouseEvent;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author pautay
	 */

	import as3isolib.core.IIsoDisplayObject;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;

	import eDpLib.events.ProxyEvent;

	public class Example07 extends Sprite
	{
		private var box:IsoBox;
		private var scene:IsoScene;
		private var _tween:Tween;

		private var _bg:Quad;

		public function Example07()
		{
			_bg=new Quad(480, 320, 0x408080);
			_bg.alpha=0;
			addChild(_bg);

			scene=new IsoScene();

			var g:IsoGrid=new IsoGrid();
			g.showOrigin=false;
			_bg.addEventListener(TouchEvent.TOUCH, _onTouch);
			scene.addChild(g);

			box=new IsoBox();
			box.setSize(25, 25, 25);
			scene.addChild(box);

			var view:IsoView=new IsoView();
			view.clipContent=false;
			view.setSize(480, 320);
			view.addScene(scene);
			addChild(view);

			scene.render();

			view.showBorder=true;
		}

		private function _onTouch(e:TouchEvent):void
		{
			var touch:Touch=e.getTouch(this, TouchPhase.BEGAN);
			if (!touch)
				return;

			var pt:Pt=new Pt(touch.globalX - 480 / 2, touch.globalY - 320 / 2);

			pt=IsoMath.screenToIso(pt);

			if (_tween)
			{
				_tween.reset(box, 0.5);
			}
			else
			{
				_tween=new Tween(box, 0.5);
				_tween.onComplete=gt_completeHandler;
			}

			_tween.animate("x", pt.x);
			_tween.animate("y", pt.y);

			if (!Starling.juggler.contains(_tween))
				Starling.juggler.add(_tween);

			if (!hasEventListener(EnterFrameEvent.ENTER_FRAME))
				this.addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
		}

		private function gt_completeHandler():void
		{
			this.removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(evt:EnterFrameEvent):void
		{
			scene.render();
		}
	}
}
