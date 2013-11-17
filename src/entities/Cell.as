package entities
{

	public class Cell
	{
		private var _x:Number
		private var _y:Number
		private var _z:Number
		private var _blocked:Boolean
		public var testText:String=""

		private var _object:BasicObject=null

		public function Cell(x:Number=0, y:Number=0, z:Number=0)
		{
			_x=x
			_y=y
			_z=z
		}

		public function bind(object:BasicObject):void
		{
			_object=object

		}

		public function get object():BasicObject
		{
			return _object
		}

		public function get x():Number
		{
			return _x
		}

		public function get y():Number
		{
			return _y
		}

		public function get z():Number
		{
			return _z
		}

		public function get blocked():Boolean
		{
			return _blocked
		}

		public function set blocked(val:Boolean):void
		{
			_blocked=val
		}
	}
}
