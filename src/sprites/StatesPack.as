package sprites
{

	public class StatesPack
	{
		private var _normal:*
		private var _mouseOver:*
		private var _disabled:*
		private var _moving:*

		public function StatesPack()
		{
			_normal=normal
			_mouseOver=mouseOver
			_disabled=disabled
			_moving=moving
		}



		public function set normal(val:*):void
		{
			_normal=val
		}

		public function set mouseOver(val:*):void
		{
			_mouseOver=val
		}

		public function set disabled(val:*):void
		{
			_disabled=val
		}

		public function set moving(val:*):void
		{
			_moving=val
		}



		public function get normal():*
		{
			return _normal
		}

		public function get mouseOver():*
		{
			return _mouseOver
		}

		public function get disabled():*
		{
			return _disabled
		}

		public function get moving():*
		{
			return _moving
		}


	}
}
