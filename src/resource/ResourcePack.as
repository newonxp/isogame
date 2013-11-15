package resource
{
	public class ResourcePack
	{
		internal var _list:Vector.<Object>

		function ResourcePack()
		{
			_list = new Vector.<Object>()
		}

		public function push( type:String, id:String) : void
		{
			_list.push({ type:type, id:id} )
		}


	}
}

