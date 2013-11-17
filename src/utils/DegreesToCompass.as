package utils
{

	public class DegreesToCompass
	{
		private var d_c:Vector.<Array>=new <Array>[[0, "n"], [45, "ne"], [90, "e"], [135, "se"], [180, "s"], [225, "sw"], [270, "w"], [315, "nw"], [360, "n"]]

		public function DegreesToCompass()
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
	}
}
