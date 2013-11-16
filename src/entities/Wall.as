package entities
{
	import as3isolib.display.scene.IsoScene;

	import starling.display.Image;

	public class Wall extends BasicStaticObject
	{
		public function Wall(scene:IsoScene=null, spriteImg:BasicImage=null, spriteImgOver:BasicImage=null)
		{
			super(scene, spriteImg, spriteImgOver)
		}
	}
}
