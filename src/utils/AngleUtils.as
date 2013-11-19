package utils
{
	import flash.geom.Point;

	public class AngleUtils
	{
		private var d_c:Vector.<Array>=new <Array>[[0, "e"], [45, "se"], [90, "s"], [135, "sw"], [180, "w"], [225, "nw"], [270, "n"], [315, "n"], [360, "e"]]

		public function AngleUtils()
		{
		}

		public function convert(d:Number):String
		{
			if (d < 0)
			{
				d=360 + d
			}
			if (d > 360)
			{
				d=d - 360
			}
			var maxVal:Number=360
			var current:Array=d_c[0]
			for (var i:int=0; i < d_c.length; i++)
			{
				var min:Number=Math.abs(d_c[i][0] - d)
				if (min < maxVal)
				{
					current=d_c[i]
					maxVal=min
				}
			}
			return current[1]
		}

		public function getCurrentAngle(point1:Point=null, point2:Point=null):Number
		{
			var dx:Number=point2.x - point1.x;
			var dy:Number=point2.y - point1.y;
			var radians:Number=Math.atan2(dy, dx);
			var degrees:Number=radians * 180 / Math.PI;
			if (degrees < 0)
			{
				degrees=360 + degrees
			}
			return degrees
		}
	}
}
