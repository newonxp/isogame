package windows
{
	import flash.display.DisplayObjectContainer;

	import resource.Resource;

	public class BasicMenu extends BasicWindow
	{
		private var _assetSrc:String
		private var _asset:DisplayObjectContainer
		public function BasicMenu(asset:String)
		{
			_assetSrc = asset
			super();
		}
		override public function init():void{
			_asset=Game.resources.get_resource(Resource.type_img,_assetSrc).data as DisplayObjectContainer
			addChild(_asset)
		}
		public function get asset():DisplayObjectContainer{
			return _asset
		}
	}
}

