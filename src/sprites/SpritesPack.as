package sprites
{
	import entities.BasicMovieClip;

	public class SpritesPack
	{
		private var _animated:Boolean
		private var _n:StatesPack
		private var _ne:StatesPack
		private var _e:StatesPack
		private var _se:StatesPack
		private var _s:StatesPack
		private var _sw:StatesPack
		private var _w:StatesPack
		private var _nw:StatesPack
		private var _effect:BasicMovieClip
		private var _name:String

		public function SpritesPack(name:String)
		{

			_name=name
		}


		public function set animated(val:Boolean):void
		{
			_animated=val
		}

		public function set n(val:StatesPack):void
		{
			_n=val
		}

		public function set ne(val:StatesPack):void
		{
			_ne=val
		}

		public function set e(val:StatesPack):void
		{
			_e=val
		}

		public function set se(val:StatesPack):void
		{
			_se=val
		}

		public function set s(val:StatesPack):void
		{
			_s=val
		}

		public function set sw(val:StatesPack):void
		{
			_sw=val
		}

		public function set w(val:StatesPack):void
		{
			_w=val
		}

		public function set nw(val:StatesPack):void
		{
			_nw=val
		}

		public function set effect(val:BasicMovieClip):void
		{
			_effect=val
		}


		public function get name():String
		{
			return _name
		}

		public function get animated():Boolean
		{
			return _animated
		}

		public function get n():StatesPack
		{
			return _n
		}

		public function get ne():StatesPack
		{
			return _ne
		}

		public function get e():StatesPack
		{
			return _e
		}

		public function get se():StatesPack
		{
			return _se
		}

		public function get s():StatesPack
		{
			return _s
		}

		public function get sw():StatesPack
		{
			return _sw
		}

		public function get w():StatesPack
		{
			return _w
		}

		public function get nw():StatesPack
		{
			return _nw
		}

		public function get effect():BasicMovieClip
		{
			return _effect
		}

	}
}
