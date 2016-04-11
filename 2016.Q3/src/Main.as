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
		
		private var _count:int = 0;
		private var _loading:Number = 0;
		
		private var _select:int = 0;
		
	
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
			var bitmapDataArray:Array = _loadResource.imageDataArray;
			_loading++;
			trace("이미지 로딩  " + (_loading/_loadResource.urlArray.length * 100).toFixed(1) + "% 완료");
			
			//모두 로딩이 됬다면
			if(bitmapDataArray.length == _loadResource.urlArray.length)
			{	
				while(_packer.packedImageCount == 0)
				{
					var bitmap:Bitmap;
					switch(_select)
					{
						case 0:  
							bitmap = _packer.mergeImageByHeight(bitmapDataArray);
							break;
						
						case 1:
							bitmap = _packer.mergeImageByMaxRects(bitmapDataArray);
							break;
					}
					
					addChild(bitmap);
									
					saveToPNG(bitmap);	
									
					var tempArray:Array = _packer.forXMLArray;
					exportToXML(tempArray);
					
					//시트에 옴겨지지 못하고 남은 이미지가 존재한다면
					if(_packer.unpackedImageArray.length != 0)
					{
						trace("추가");
						_count++;
						bitmapDataArray = _packer.unpackedImageArray;
						_packer = new Packer();		
						
					}
					
				}
			}
		}
		
		/**
		 * 
		 * @param bitmap Bitmap을 입력받음
		 * png파일로 출력하는 메소드
		 */
		public function saveToPNG(bitmap:Bitmap):void
		{
			var _pngFile:File = File.documentsDirectory.resolvePath("sprite_sheet" + _count + ".png");
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
			var _xmlFile:File = File.documentsDirectory.resolvePath("sprite_sheet" + _count + ".xml");
			
			_fileStream.open(_xmlFile, FileMode.WRITE);
			_fileStream.writeUTFBytes("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
			_fileStream.writeUTFBytes("<TextureAtlas ImagePath=\"" + "sprite_sheet" + _count + ".png" + "\">\n");
			
			for(var i:int = 0; i<imageData.length; ++i)
			{
				_fileStream.writeUTFBytes("<SubTexture name=\"" + imageData[i].name + "\" x=\"" + imageData[i].rect.x 
					+ "\" y=\"" + imageData[i].rect.y + "\" width=\"" + imageData[i].rect.width + "\" height=\"" + imageData[i].rect.height + "\"/>\n");
			}
			_fileStream.writeUTFBytes("</TextureAtlas>");
			_fileStream.close();
			
		}
	}
}