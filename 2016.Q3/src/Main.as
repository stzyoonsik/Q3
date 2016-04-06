package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	[SWF(width = "1024", height = "768")]
	public class Main extends Sprite
	{
		private var _bitmapData:BitmapData;
		private var _loadResource:ResourceLoader;
		
		
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
				for(var i:int = 0; i<bitmapDataArray.length; ++i)
				{
					var bm:Bitmap = new Bitmap(bitmapDataArray[i]);
					addChild(bm);
					trace(i);
				}
			}
						
			
		}
	}
}