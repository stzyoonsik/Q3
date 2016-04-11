package
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	[SWF(width = "1024", height = "1024")]
	public class Main extends Sprite
	{
		private var _loadResource:ResourceLoader;
		private var _packer:Packer = new Packer();
		
		private var _count:int = 0;
		//private var _loading:Number = 0;
		
	
		private var _fileStream:FileStream = new FileStream(); 
		
		private var _button0:SimpleButton = new SimpleButton();
		private var _button1:SimpleButton = new SimpleButton();
		
		private var _finalArray:Array = new Array();
		
		public function Main()
		{
			_loadResource = new ResourceLoader(onLoadingComplete);
			initButton();					
			
		}
		
		/**
		 * 버튼의 내용과 위치를 초기화하는 메소드 
		 * 마우스 업 이벤트가 달려있음
		 */
		public function initButton():void
		{
			var text0:TextField = new TextField();
			text0.text = "Height";
			text0.autoSize = "left";
			text0.border = true;
			
			//text.backgroundColor = 0x555555;
			_button0.upState = text0;
			_button0.overState = text0;
			_button0.hitTestState = text0;
			_button0.x = 300;
			_button0.y = 300;
			addChild(_button0);
			
			
			var text1:TextField = new TextField(); 
			text1.text = "Max Rects";
			text1.autoSize = "left";
			text1.border = true;
			
			_button1.upState = text1;
			_button1.overState = text1;
			_button1.hitTestState = text1;
			_button1.x = 400;
			_button1.y = 300;
			addChild(_button1);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp);
		}
		
		/**
		 * 
		 * @param e 마우스 업
		 *  마우스 업 이벤트 콜백 메소드
		 */
		public function onButtonMouseUp(e:MouseEvent):void
		{
			var select:int;
			switch(e.target)
			{
				case _button0 :
					select = 0;					
					break;
				
				case _button1 :
					select = 1;					
					break;
			}
			
			makeSpriteSheet(select);
				
		}
		
		/**
		 * 
		 * @param select 0이면 높이우선 , 1이면 맥스렉트
		 * 스프라이트 시트를 만드는 메소드
		 */
		public function makeSpriteSheet(select:int):void
		{
			while(_packer.packedImageCount == 0)
			{
				var bitmap:Bitmap;
				switch(select)
				{
					//높이 우선 알고리즘
					case 0:  
						bitmap = _packer.mergeImageByHeight(_finalArray);
						break;
					//Max Rects 알고리즘
					case 1:
						bitmap = _packer.mergeImageByMaxRects(_finalArray);
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
					_finalArray = _packer.unpackedImageArray;
					_packer = new Packer();		
					
				}				
			}
		}
		/**
		 * 모든 리소스의 로딩이 끝났는지를 검사하는 메소드
		 * 다 끝났다면 새 배열로 복사함
		 * 
		 */
		public function onLoadingComplete():void
		{	
			
			//모두 로딩이 됬다면
			trace((_loadResource.imageDataArray.length / _loadResource.fileCount * 100).toFixed(1) + "% 완료");
			if(_loadResource.imageDataArray.length == _loadResource.fileCount)
			{	
				_finalArray = _loadResource.imageDataArray;

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