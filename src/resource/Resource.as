package resource
{
	public class Resource
	{
		public static const type_xml:String  = "xml"
		public static const type_img:String  = "img"
		public static const type_fnt:String  = "fnt"
		public static const type_snd:String  = "snd"

		private var _id:String
		private var _type:String
		private var _data:*

		function Resource( type:String, id:String, data:* )
		{
			_id = id
			_type = type
			_data = data
		}

		public function get id() : String
		{
			return _id
		}

		public function get data() : *
		{
			return _data
		}


	}
}

