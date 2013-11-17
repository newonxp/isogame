package entities
{

	public class Bounds
	{
		private var _x:int
		private var _y:int
		private var _z:int

		public function Bounds(x:int=0, y:int=0, z:int=0)
		{
			_x=x
			_y=y
			_z=z
		}

		public function get x():int
		{
			return _x
		}

		public function get y():int
		{
			return _y
		}

		public function get z():int
		{
			return _z
		}
	}
}
