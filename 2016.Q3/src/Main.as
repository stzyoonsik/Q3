package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	[SWF(width = "1024", height = "1024")]
	public class Main extends Sprite
	{
		//private var _canvas:BitmapData = new BitmapData(MAX_WIDTH, MAX_HEIGHT, false);						//모든 이미지들을 한장으로 만들 도화지
		
		
		private var _loadResource:ResourceLoader;
		private var _packer:Packer = new Packer();
		
		
		private var _file:File = File.documentsDirectory.resolvePath("sprite_sheet.png");
		private var _fileStream:FileStream = new FileStream(); 
		
		public function Main()
		{
			_loadResource = new ResourceLoader(completeResource);			
			
		}
		
		/**
		 * 모든 리소스의 로딩이 끝났는지를 검사하고
		 * 끝났으면 png파일을 출력하는 메소드
		 * 
		 */
		public function completeResource():void
		{			
			var bitmapDataArray:Array = _loadResource.bitmapDataArray;			
			
			//모두 로딩이 됬다면
			if(bitmapDataArray.length == _loadResource.urlArray.length)
			{	
				var bitmap:Bitmap = _packer.mergeImages(bitmapDataArray);
				addChild(bitmap);
				
				var byteArray:ByteArray = PNGEncoder.encode(bitmap.bitmapData);
				
				_fileStream.open(_file, FileMode.WRITE);
				_fileStream.writeBytes(byteArray);
				_fileStream.close();
				
			}
						
			
		}
	}
}