package entities
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoScene;

	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.motionPaths.LinePath2D;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import sprites.SpritesPack;

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;

	import utils.AngleUtils;

	import windows.Game;

	public class BasicObject extends Sprite
	{
		private var _scene:IsoScene
		private var _spritesPack:SpritesPack
		private var _bounds:Bounds

		private var _cell:Cell
		public var _sprite:IsoSprite
		private var _box:IsoBox
		public var _converter:AngleUtils
		private var _spritesArray:Array
		private var _blocking:Boolean
		private var _movable:Boolean
		private var _collidable:Boolean

		private var _x:Number
		private var _y:Number
		private var _z:Number
		private var _alpha:Number
		private var _rotation:Number
		private var _rotationState:String

		private var _oldX:Number
		private var _oldY:Number


		private var _type:String
		private var _touchable:Boolean

		private var _path:LinePath2D
		private var _tween:TweenMax

		public function BasicObject(x:Number=0, y:Number=0, z:Number=0, rotation:Number=0, bounds:Bounds=null, cell:Cell=null, scene:IsoScene=null, spritesPack:SpritesPack=null, touchable:Boolean=false, blocking:Boolean=false, movable:Boolean=false, collidable:Boolean=false)
		{
			_scene=scene
			_spritesPack=spritesPack
			_x=x
			_y=y
			_z=z
			_rotation=rotation
			_bounds=bounds
			_touchable=touchable
			_blocking=blocking
			_movable=movable
			_collidable=collidable
			_oldX=x
			_oldY=y
			init()
		}

		private function init():void
		{
			_spritesArray=new Array()
			_converter=new AngleUtils()
			_sprite=new IsoSprite();
			_sprite.isAnimated=true
			_sprite.autoUpdate=true
			_sprite.setSize(_bounds.x, _bounds.y, _bounds.z);
			if (_collidable == true)
			{
				Game.gameManager.currentRoot.collisionDetector.registerRect(new Rectangle(x, y, _bounds.x, _bounds.y), this)
			}
			addSprite(_spritesPack.e.normal)
			_scene.addChild(_sprite);
			moveTo(_x, _y, _z)
			rotate(_rotation)
			addedOnStage()
		}

		public function addedOnStage():void
		{
		}

		public function renderScene():void
		{
			Game.gameManager.currentRoot.renderScene(_scene)
		}

		private function addSprite(img:*):void
		{
			if (_spritesPack.animated == true)
			{
				addMovieClip(img)
			}
			else
			{
				addImage(img)
			}
		}

		public function rotate(degrees:Number=0):void
		{
			_rotation=degrees
			//trace("12312312 " + degrees)
			var side:String=_converter.convert(degrees)
			//	trace("side= " + side + " " + degrees)
			if (_rotationState != side)
			{
				_rotationState=side
				removeImage()
				if (_spritesPack[side].normal != null)
				{
					addSprite(_spritesPack[side].normal)
				}
				else
				{
					rotate(degrees + 45)
				}
			}
		}

		private function addImage(img:BasicImage):void
		{
			img.setAs3IsoObject(this)
			img.x=((_sprite.width / 2) - (img.width / 2)) - (_sprite.length / 2);
			img.y=((_sprite.length / 2) + (_sprite.width / 2)) - img.height;
			img.touchable=_touchable
			_spritesArray=new Array()
			_spritesArray.push(img)
			_sprite.sprites=_spritesArray
		}

		private function addMovieClip(img:BasicMovieClip):void
		{
			img.setAs3IsoObject(this)
			img.x=((_sprite.width / 2) - (img.width / 2)) - (_sprite.length / 2);
			img.y=((_sprite.length / 2) + (_sprite.width / 2)) - img.height;
			img.touchable=_touchable
			_spritesArray=new Array()
			_spritesArray.push(img)
			_sprite.sprites=_spritesArray
			Starling.juggler.add(img)
		}

		public function removeImage():void
		{
			if (_spritesPack.animated == true)
			{
				Starling.juggler.remove(_sprite.sprites[0])
			}
			_sprite.sprites=[]
		}

		public function moveTo(x:Number=0, y:Number=0, z:Number=0):void
		{

			if (_collidable == true)
			{
				Game.gameManager.currentRoot.collisionDetector.updateRect(x, y, this)
			}
			if (_movable == true)
			{
				if (_oldX != Math.round(x) || _oldY != Math.round(y))
				{
					if (Math.abs(x - _oldX) > 4 || Math.abs(y - _oldY) > 4)
					{
						checkDirection(new Point(_oldX, _oldY), new Point(Math.round(x), Math.round(y)))
						_oldX=Math.floor(x)
						_oldY=Math.floor(y)
					}
				}
			}
			if (_cell == null)
			{
				_cell=Game.gameManager.currentRoot.getCellAtCoords(x, y)
				if (_blocking == true)
				{
					_cell.blocked=true
				}
			}
			if (_blocking == true)
			{
				var newCell:Cell=Game.gameManager.currentRoot.getCellAtCoords(x, y)
				if (_cell)
				{
					if (newCell != _cell && !newCell.blocked)
					{

						_cell.blocked=false
						newCell.blocked=true
						_cell=newCell
						Game.gameManager.currentRoot.updateCollisionMap()
					}
				}
				else
				{
					_cell=newCell
					_cell.blocked=false
				}
			}
			_sprite.moveTo(x, y, z);

			renderScene()
		}

		public function walkTo(start:Point, end:Point):void
		{

			var path:Object=Game.gameManager.currentRoot.getPath(start, end, false)
			if (path != null)
			{
				TweenMax.killTweensOf(this)
				if (_path != null)
				{
					_path.removeAllFollowers()
				}
				cell.blocked=false
				_path=new LinePath2D(path.path);
				_path.addFollower(this);
				_tween=TweenMax.to(_path, path.length * Config.playerSpeed, {progress: 1, ease: com.greensock.easing.Linear.easeNone, onComplete: walkFinished});
			}
		}

		public function walkFinished():void
		{

		}

		public function checkDirection(point1:Point, point2:Point):void
		{

			rotate(_converter.getCurrentAngle(point1, point2))
		}

		public function onMouseOver():void
		{
			var colorMatrixFilter:ColorMatrixFilter=new ColorMatrixFilter()
			colorMatrixFilter.adjustBrightness(0.1);
			_sprite.actualSprites[0].filter=colorMatrixFilter;
		}

		public function onMouseOut():void
		{
			_sprite.actualSprites[0].filter=null;
		}

		public function onLeftClick():void
		{

		}

		public function onRightClick():void
		{

		}

		override public function get x():Number
		{
			return _x
		}

		override public function get y():Number
		{
			return _y
		}

		public function get z():Number
		{
			return _z
		}

		override public function get rotation():Number
		{
			return _rotation
		}

		public function get cell():Cell
		{
			return _cell
		}

		public function get type():String
		{
			return _type
		}


		override public function set x(val:Number):void
		{
			_x=val
			moveTo(_x, _y, _z)
		}

		override public function set y(val:Number):void
		{
			_y=val
			moveTo(_x, _y, _z)
		}

		public function set z(val:Number):void
		{
			_z=val
			moveTo(_x, _y, _z)
		}


		override public function set alpha(val:Number):void
		{
			_alpha=val
			_sprite.sprites[0].alpha=val
		}

		override public function set rotation(val:Number):void
		{
			rotate(val)

		}

		public function set cell(val:Cell):void
		{
			_cell=val
		}

		public function set type(val:String):void
		{
			_type=val
		}

		public function collide(target:BasicObject):void
		{

		}

		public function get scene():IsoScene
		{
			return _scene
		}

		public function removeCollisionRect():void
		{
			if (_collidable == true)
			{
				Game.gameManager.currentRoot.collisionDetector.removeRect(this)
			}
		}

		public function remove():void
		{
			if (_cell.blocked)
			{
				_cell.blocked=false
			}
			if (_path != null)
			{
				_tween.kill()
				_path.removeAllFollowers()
			}
			TweenMax.killTweensOf(this)
			TweenMax.killDelayedCallsTo(walkFinished)
			removeCollisionRect()
			_sprite.actualSprites[0].filter=null;
			_scene.removeChild(_sprite)
			Game.gameManager.currentRoot.removeObject(this)
		}
	}
}


