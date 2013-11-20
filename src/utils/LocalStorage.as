package utils
{
	import flash.net.SharedObject

	public class LocalStorage
	{
		function LocalStorage( id:String )
		{
			try
			{
				_object = SharedObject.getLocal( id )
			}
			catch ( e:Error )
			{
				_object = null
			}
		}

		public function set_value( param:String, val:* ) : void
		{
			if ( _object )
				_object.data[param] = val

			try
			{
				_object.flush()
			}
			catch ( e:Error )
			{

			}
		}

		public function have_value( param:String ) : Boolean
		{
			return _object && param in _object.data
		}

		public function get_value( param:String ) : *
		{
			if ( _object )
				return _object.data[param]
		}

		private var _object:SharedObject
	}
}

