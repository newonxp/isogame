package starling
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author pautay
	 */
	public class Utils 
	{
		
		public static function createImage(dp : DisplayObject, w : int = -1, h : int = -1) : Image
		{
			var texture : Texture ;
			
			var bmpd : BitmapData;
			if (w == -1)
				bmpd = new BitmapData(dp.width, dp.height, true, 0);
			else
				bmpd = new BitmapData(w, h, true, 0);
			
			bmpd.draw(dp);
			texture = Texture.fromBitmapData(bmpd, false, false/*, Starling.contentScaleFactor*/);
			
			var image : Image = new Image(texture);
			//image.smoothing = TextureSmoothing.TRILINEAR ;
			return image;
		}
		
		public static function drawShape(color : int = -1, radius : Number = 20, filters : Array = null ) : Image
		{
			if (color == -1)
				color = Math.random() * 0xFFFFFF;
			
			var shape : Sprite = new Sprite();
			shape.graphics.beginFill(color);
			shape.graphics.drawCircle(radius, radius, radius);
			shape.graphics.endFill();
			
			if (filters)
				shape.filters = filters;
			
			var bmpd : BitmapData = new BitmapData(radius * 2, radius * 2, true, 0);
			bmpd.draw(shape);
			
			var texture : Texture = Texture.fromBitmapData(bmpd);
			var image : Image = new Image(texture);
			image.pivotX = -(radius / 2);
			image.pivotY = -(radius / 2);
			
			return image;
		}
		
		public static function createTextField(w : uint, h : uint) : TextField
		{
			var tf : TextField = new TextField(w, h, "New Textfield", "Verdana", 38, 0xFFFFFF);
			return tf;
		}		
		
		public static function clearSprite(sp : starling.display.Sprite) : void
		{
			while (sp.numChildren > 0)
				sp.removeChildAt(0);
		}
		
		
		public static function scaleBitmapData( clip : DisplayObject, maxW : Number, maxH : Number ) : BitmapData
        {
			var sx : Number = clip.scaleX ; 
			var sy : Number = clip.scaleY ; 
			
			clip.scaleX = clip.scaleY = 1 ; 
			
            var scale : Number = Math.min( maxW / clip.width, maxH / clip.height ) ;
            var nw : Number = clip.width * scale ;
            var nh : Number = clip.height * scale ;
            var bmp : BitmapData = new BitmapData(nw, nh, true, 0) ;
            var m : Matrix = new Matrix() ;
            m.scale(scale, scale) ;
            bmp.draw(clip, m, null, null, null, true) ;
			clip.scaleX = sx ; 
			clip.scaleY = sy ; 
			
            return bmp ;
        }
		
		
		public static function copyAsBitmapData(sprite:starling.display.Sprite):BitmapData 
		{
			if (sprite == null) return null;
			var resultRect:Rectangle = new Rectangle();
			sprite.getBounds(sprite/*, resultRect*/);
			var context:Context3D = Starling.context;
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear();
			support.setOrthographicProjection(0,0,Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			support.transformMatrix(sprite.root);
			support.translateMatrix( -resultRect.x, -resultRect.y);
			var result:BitmapData = new BitmapData(resultRect.width, resultRect.height, true, 0x00000000);
			support.pushMatrix();
			support.transformMatrix(sprite);
			sprite.render(support, 1.0);
			support.popMatrix();
			support.finishQuadBatch();
			context.drawToBitmapData(result);
			return result;
		}		
	}
}