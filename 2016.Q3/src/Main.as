package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[SWF(width = "1024", height = "1024")]
	public class Main extends Sprite
	{
		//private var _canvas:BitmapData = new BitmapData(MAX_WIDTH, MAX_HEIGHT, false);						//모든 이미지들을 한장으로 만들 도화지
		
		
		private var _loadResource:ResourceLoader;
		private var packer:Packer = new Packer();
		
		public function Main()
		{
			_loadResource = new ResourceLoader(completeResource);			
			
		}
		
		/**
		 * 모든 리소스의 로딩이 끝났는지를 검사하는 메소드
		 * 
		 */
		public function completeResource():void
		{			
			var bitmapDataArray:Array = _loadResource.bitmapDataArray;			
			
			//모두 로딩이 됬다면
			if(bitmapDataArray.length == _loadResource.urlArray.length)
			{			

				var bitmap:Bitmap = packer.mergeImages(bitmapDataArray);
				addChild(bitmap);
			}
						
			
		}
	}
}