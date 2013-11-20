package utils
{
	import as3isolib.display.IsoView;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;

	import com.greensock.TweenMax;

	import entities.BasicObject;

	import flash.geom.Point;

	import windows.Game;

	public class CameraControl
	{
		private var _view:IsoView
		private var _targetPoint:Point

		public function CameraControl(view:IsoView):void
		{
			_targetPoint=new Point()
			_view=view
		}

		public function moveToObject(obj:BasicObject, time:Number=1):void
		{
			TweenMax.to(_targetPoint, time, {x: obj.x, y: obj.y, onUpdate: onTick})
		}

		private function onTick():void
		{
			moveToPoint(_targetPoint)
		}

		private function moveToPoint(tPoint:Point, fast:Boolean=false):void
		{
			var pt:Pt=new Pt(tPoint.x, tPoint.y, 0)
			pt=IsoMath.isoToScreen(pt)
			_view.panTo(pt.x, pt.y)
			Game.gameManager.currentRoot.oldX=_view.currentX
		}

		public function setTargetPoint(x:Number, y:Number):void
		{
			_targetPoint.x=x
			_targetPoint.y=y
			moveToPoint(_targetPoint)
		}

		public function setTargetCoords(x:Number, y:Number):void
		{
			_targetPoint.x=x
			_targetPoint.y=y
		}
	}
}
