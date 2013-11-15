package errors
{
	public class CustomError extends Error
	{
		private var _opt:String
		private var _msg:String
		private var _internal_msg:String
		function CustomError( msg:String, opt:String = null, internal_msg:String = null )
		{
			_msg = msg
			_opt = opt
			_internal_msg = internal_msg

			super(msg + ( opt ? ", " + opt : "") + (internal_msg ? ", " + internal_msg : ""))
		}

		public function get msg() : String
		{
			return _msg
		}

		public function get opt() : String
		{
			return _opt
		}

		public function get internal_msg() : String
		{
			return _internal_msg
		}
	}
}

