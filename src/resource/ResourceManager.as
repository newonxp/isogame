package resource
{
	import flash.events.Event
	import flash.events.IOErrorEvent
	import flash.events.ProgressEvent
	import flash.utils.ByteArray
	import flash.net.URLLoader
	import flash.net.URLRequest
	import flash.net.URLLoaderDataFormat
	import flash.media.Sound
	import flash.display.Loader
	import flash.display.Bitmap
	import flash.display.MovieClip
	import flash.display.BitmapData
	import flash.display.LoaderInfo
	import flash.display.DisplayObject

	import errors.ResourceError

	public class ResourceManager
	{

		private var _host:String
		private var _lang:String
		private var _build_id:String
		private var _cache:Array
		private var _load_listeners:Array
		private var _error_listeners:Array
		private var _locale_res_list:Array

		private static const symbol_separator:String="@"
		private static const glob_locale:String="glob"

		function ResourceManager(lang:String, build_id:String)
		{
			_lang=lang
			_build_id=build_id
			_locale_res_list=new Array()

			_cache=new Array()
			_cache[Resource.type_xml]=new Array()
			_cache[Resource.type_img]=new Array()
			_cache[Resource.type_snd]=new Array()
			_cache[Resource.type_fnt]=new Array()

			_load_listeners=new Array()
			_error_listeners=new Array()
		}

		public function set_host(host:String):void
		{
			_host=host + "/"
		}

		public function load_locale_config(id:String, callback:Function):void
		{
			_locale_res_list[id]=id

			var on_loaded:Function=function(res:Resource):void
			{
				var xml:XML=res.data

				for each (var i:XML in xml.children())
				{
					var id:String=i.@id
					_locale_res_list[id]=id
				}

				callback()
			}

			load_xml(id, on_loaded)
		}

		public function has_resource(type:String, id:String):Boolean
		{
			var list:Array=_cache[type]
			return list && list[get_source_locale_id(id)]
		}

		public function get_resource(type:String, id:String):Resource
		{
			var src_id:String=get_source_locale_id(id)
			var smb_id:String=get_symbol_id(id)

			var list:Array=_cache[type]
			if (!list)
			{
				throw new ResourceError("ResourceManager::get_resource", "unknown resource type:" + type)
			}
			var res:Object=list[src_id]
			if (!res)
			{
				throw new ResourceError("ResourceManager::get_resource", "resource not in cache, id:" + id)
			}
			switch (type)
			{
				case Resource.type_snd:
					break

				case Resource.type_xml:
					if (smb_id)
					{
						var xml:XML=res as XML
						var children:XMLList=xml.child(smb_id)
						if (children.length() == 0)
						{
							throw new ResourceError("ResourceManager::get_resource", "unknown symbol:" + smb_id + " in xml:" + src_id)
						}
						res=children[0]
					}
					break

				case Resource.type_fnt:
					if (!res.loaderInfo.applicationDomain.hasDefinition(smb_id))
					{
						throw new ResourceError("ResourceManager::get_resource", "unknown symbol:" + smb_id + " in resource:" + src_id)
					}
					res=res.loaderInfo.applicationDomain.getDefinition(smb_id) as Class
					break

				case Resource.type_img:
					var bmp:BitmapData=res as BitmapData
					var obj:DisplayObject=res as DisplayObject

					if (bmp)
					{
						res=new Bitmap(res as BitmapData)
					}
					else if (obj && smb_id)
					{
						if (!obj.loaderInfo.applicationDomain.hasDefinition(smb_id))
							throw new ResourceError("ResourceManager::get_resource", "unknown symbol:" + smb_id + " in resource:" + src_id)

						res=new (obj.loaderInfo.applicationDomain.getDefinition(smb_id) as Class)
					}
					break

				default:
					throw new ResourceError("ResourceManager::get_resource", "unknown resource type:" + type)
			}

			return new Resource(type, id, res)
		}

		public function get_img(id:String):Resource
		{
			return get_resource(Resource.type_img, id)
		}

		public function get_xml(id:String):Resource
		{
			return get_resource(Resource.type_xml, id)
		}

		public function get_font(id:String):Resource
		{
			return get_resource(Resource.type_fnt, id)
		}

		public function get_sound(id:String):Resource
		{
			return get_resource(Resource.type_snd, id)
		}

		public function add_resource(type:String, id:String, res:Object):void
		{
			if (has_resource(type, id))
			{
				throw new ResourceError("ResourceManager::add_resource", "resource already exist, id:" + id)
			}
			_cache[type][get_source_locale_id(id)]=res
		}

		public function load_resource(type:String, id:String, on_complete:Function, on_error:Function=null):void
		{
			switch (type)
			{
				case Resource.type_xml:
					load_xml(id, on_complete, on_error)
					break

				case Resource.type_img:
					load_image(id, on_complete, on_error)
					break

				case Resource.type_snd:
					load_sound(id, on_complete, on_error)
					break

				case Resource.type_fnt:
					load_font(id, on_complete, on_error)
					break

				default:
					throw new ResourceError("ResourceManager::load_resource", "unknown resource type:" + type)
			}
		}

		public function load_resource_pack(pack:ResourcePack, on_complete:Function, on_error:Function=null):void
		{
			var failed:Boolean=false
			var counter:int=pack._list.length
			var list:Vector.<Resource>=new Vector.<Resource>()

			if (counter == 0)
			{
				on_complete(list)
			}
			var on_loaded:Function=function(res:Resource):void
			{
				list.push(res)

				if (--counter == 0)
					on_complete(list)
			}

			var on_fail:Function=function(id:String):void
			{
				if (failed)
				{
					return
				}
				failed=true
				if (on_error != null)
				{
					on_error(id)
				}
				else
				{
					throw new ResourceError("ResourceManager::load_resource_pack", "failed to load id:" + id)
				}
			}

			while (pack._list.length > 0)
			{
				var res:Object=pack._list.shift()
				load_resource(res.type, res.id, on_loaded, on_fail)
			}
		}

		public function load_xml(id:String, on_complete:Function, on_error:Function=null):void
		{
			if (has_resource(Resource.type_xml, id))
			{
				on_complete(get_resource(Resource.type_xml, id))
				return
			}

			if (add_listeners(Resource.type_xml, id, on_complete, on_error))
			{
				return
			}

			var on_loaded:Function=function(text:String):void
			{
				var res:XML=null

				try
				{
					res=new XML(text)
				}
				catch (e:Error)
				{
					throw new ResourceError("ResourceManager::load_xml", "XML parsing error, id:" + id)
				}

				add_resource(Resource.type_xml, id, res)
				call_load_listeners(Resource.type_xml, id)
			}

			var on_failed:Function=function(id:String):void
			{
				call_error_listeners(Resource.type_xml, id)
			}

			load_external_text(get_source_locale_id(id), on_loaded, on_failed)
		}

		public function load_sound(id:String, on_complete:Function, on_error:Function=null):void
		{
			if (has_resource(Resource.type_snd, id))
			{
				on_complete(get_resource(Resource.type_snd, id))
				return
			}

			if (add_listeners(Resource.type_snd, id, on_complete, on_error))
			{
				return
			}

			var on_loaded:Function=function(e:Event):void
			{
				e.target.removeEventListener(Event.COMPLETE, on_loaded)
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, on_io_error)

				add_resource(Resource.type_snd, id, e.target)
				call_load_listeners(Resource.type_snd, id)
			}

			var on_io_error:Function=function(e:Event):void
			{
				e.target.removeEventListener(Event.COMPLETE, on_loaded)
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, on_io_error)

				call_error_listeners(Resource.type_snd, id)
			}

			var sound:Sound=new Sound()
			sound.addEventListener(Event.COMPLETE, on_loaded)
			sound.addEventListener(IOErrorEvent.IO_ERROR, on_io_error)
			sound.load(new URLRequest(res_link(get_locale_id(id))))
		}

		public function load_image(id:String, on_complete:Function, on_error:Function=null):void
		{
			if (has_resource(Resource.type_img, id))
			{
				on_complete(get_resource(Resource.type_img, id))
				return
			}

			if (add_listeners(Resource.type_img, id, on_complete, on_error))
			{
				return
			}

			var on_loaded:Function=function(loader:LoaderInfo):void
			{
				if (loader.content as Bitmap)
				{
					add_resource(Resource.type_img, id, (loader.content as Bitmap).bitmapData)
				}
				else
				{
					add_resource(Resource.type_img, id, loader.content)
				}
				call_load_listeners(Resource.type_img, id)
			}

			var on_failed:Function=function(id:String):void
			{
				call_error_listeners(Resource.type_img, id)
			}

			load_external_res(get_source_locale_id(id), on_loaded, on_failed)
		}

		public function load_font(id:String, on_complete:Function, on_error:Function=null):void
		{
			if (has_resource(Resource.type_fnt, id))
			{
				on_complete(get_resource(Resource.type_fnt, id))
				return
			}

			if (add_listeners(Resource.type_fnt, id, on_complete, on_error))
			{
				return
			}

			var on_loaded:Function=function(loader:LoaderInfo):void
			{
				add_resource(Resource.type_fnt, id, loader.content)
				call_load_listeners(Resource.type_fnt, id)
			}

			var on_failed:Function=function(id:String):void
			{
				call_error_listeners(Resource.type_fnt, id)
			}

			load_external_res(get_source_locale_id(id), on_loaded, on_failed)
		}

		private function load_external_res(id:String, on_complete:Function, on_error:Function):void
		{
			var on_loader_complete:Function=function(e:Event):void
			{
				unsubscribe(e)
				on_complete(e.target)
			}

			var on_io_error:Function=function(e:Event):void
			{
				unsubscribe(e)

				if (on_error != null)
					on_error(id)
				else
					throw new ResourceError("ResourceManager::load_external_image", "io_error, id:" + id)
			}

			var unsubscribe:Function=function(e:Event):void
			{
				e.target.removeEventListener(Event.COMPLETE, on_loader_complete)
				e.target.removeEventListener(IOErrorEvent.IO_ERROR, on_io_error)
			}

			var loader:Loader=new Loader()

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, on_loader_complete)
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, on_io_error)

			loader.load(new URLRequest(res_link(id)))
		}

		private function load_external_text(id:String, on_complete:Function, on_error:Function):void
		{
			var on_loaded:Function=function(e:Event):void
			{
				e.target.removeEventListener(e.type, arguments.callee)

				if (e.target.dataFormat != URLLoaderDataFormat.TEXT)
					throw new ResourceError("ResourceManager::load_text_resource", "not text resource, id:" + id)

				on_complete(e.target.data)
			}

			var on_io_error:Function=function(e:Event):void
			{
				e.target.removeEventListener(e.type, arguments.callee)

				if (on_error != null)
					on_error(id)
				else
					throw new ResourceError("ResourceManager::load_text_resource", "io_error, id:" + id)
			}

			var loader:URLLoader=new URLLoader()
			loader.addEventListener(Event.COMPLETE, on_loaded)
			loader.addEventListener(IOErrorEvent.IO_ERROR, on_io_error)
			loader.load(new URLRequest(res_link(id)))
		}

		private function add_listeners(type:String, id:String, on_complete:Function, on_error:Function):Boolean
		{
			var src_id:String=get_source_locale_id(id)

			if (!_load_listeners[type])
				_load_listeners[type]=new Array()

			if (!_error_listeners[type])
				_error_listeners[type]=new Array()

			if (!_load_listeners[type][src_id])
				_load_listeners[type][src_id]=new Vector.<Object>()

			if (!_error_listeners[type][src_id])
				_error_listeners[type][src_id]=new Vector.<Object>()

			_load_listeners[type][src_id].push({id: id, func: on_complete})
			_error_listeners[type][src_id].push({id: id, func: on_error})

			return _load_listeners[type][src_id].length > 1
		}

		private function call_load_listeners(type:String, id:String):void
		{
			var src_id:String=get_source_locale_id(id)

			if (!_load_listeners[type] || !_load_listeners[type][src_id])
				throw new ResourceError("ResourceManager::call_load_listeners", "type:" + type + " id:" + src_id)

			var list:Vector.<Object>=_load_listeners[type][src_id]
			for each (var i:Object in list)
				i.func(get_resource(type, i.id))

			delete _load_listeners[type][src_id]
		}

		private function call_error_listeners(type:String, id:String):void
		{
			var src_id:String=get_source_locale_id(id)

			if (!_error_listeners[type] || !_error_listeners[type][src_id])
				throw new ResourceError("ResourceManager::call_error_listeners", "type:" + type + " id:" + src_id)

			var list:Vector.<Object>=_error_listeners[type][id]
			for each (var i:Object in list)
			{
				if (i.func != null)
					i.func(i.id)
				else
					throw new ResourceError("ResourceManager::call_error_listeners", "unknown id:" + id)
			}

			_error_listeners[type][id]=null
		}

		private function get_source_id(id:String):String
		{
			var idx:int=id.indexOf(symbol_separator)
			return idx == -1 ? id : id.slice(0, idx)
		}

		private function get_source_locale_id(id:String):String
		{
			return get_locale_id(get_source_id(id))
		}

		private function get_locale_id(id:String):String
		{
			var src_id:String=get_source_id(id)
			return src_id in _locale_res_list ? _lang + "/" + id : glob_locale + "/" + id
		}

		private function get_symbol_id(id:String):String
		{
			var idx:int=id.indexOf(symbol_separator)
			return idx == -1 ? null : id.slice(idx + 1)
		}

		private function res_link(id:String):String
		{
			return _host + id + "?" + _build_id
		}

		public function get locale():String
		{
			return _lang
		}
	}
}

