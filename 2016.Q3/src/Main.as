package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	[SWF(width = "1024", height = "1024")]
	public class Main extends Sprite
	{
		//private var _canvas:BitmapData = new BitmapData(MAX_WIDTH, MAX_HEIGHT, false);						//모든 이미지들을 한장으로 만들 도화지
		
		
		private var _loadResource:ResourceLoader;
		private var _packer:Packer = new Packer();
		
		
		private var _pngFile:File = File.documentsDirectory.resolvePath("sprite_sheet.png");
		private var _xmlFile:File = File.documentsDirectory.resolvePath("sprite_sheet.xml");
		private var _fileStream:FileStream = new FileStream(); 
		
		public function Main()
		{
			_loadResource = new ResourceLoader(completeResource);			
			
		}
		
		/**
		 * 모든 리소스의 로딩이 끝났는지를 검사하는 메소드
		 * 
		 * 
		 */
		public function completeResource():void
		{			
			//var bitmapDataArray:Array = _loadResource.bitmapDataArray;			
			var bitmapDataArray:Array = _loadResource.imageDataArray;
			
			
			//모두 로딩이 됬다면
			if(bitmapDataArray.length == _loadResource.urlArray.length)
			{	
				var bitmap:Bitmap = _packer.mergeImages(bitmapDataArray);
				addChild(bitmap);
				
				saveToPNG(bitmap);	
				
				var tempArray:Array = _packer.forXMLArray;
				exportToXML(tempArray);
			}
		}
		
		/**
		 * 
		 * @param bitmap Bitmap을 입력받음
		 * png파일로 출력하는 메소드
		 */
		public function saveToPNG(bitmap:Bitmap):void
		{
			var byteArray:ByteArray = PNGEncoder.encode(bitmap.bitmapData);
			
			_fileStream.open(_pngFile, FileMode.WRITE);
			_fileStream.writeBytes(byteArray);
			_fileStream.close();
		}
		
		/**
		 * 
		 * @param rectData 벡터에 저장된 point, width, height
		 * xml 파일로 출력하는 메소드
		 */
		public function exportToXML(imageData:Array):void
		{
			_fileStream.open(_xmlFile, FileMode.WRITE);
			_fileStream.writeUTFBytes("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
			_fileStream.writeUTFBytes("<TextureAtlas ImagePath=\"" + "sprite_sheet.png" + "\">\n");
			
			for(var i:int = 0; i<imageData.length; ++i)
			{
				_fileStream.writeUTFBytes("<SubTexture name=\"" + imageData[i].name + "\" x=\"" + imageData[i].rect.x 
					+ "\" y=\"" + imageData[i].rect.y + "\" width=\"" + imageData[i].rect.width + "\" height=\"" + imageData[i].rect.height + " \"/>\n");
			}
			_fileStream.writeUTFBytes("</TextureAtlas>");
			_fileStream.close();
			
		}
	}
}