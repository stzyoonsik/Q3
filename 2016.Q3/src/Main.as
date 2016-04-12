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
		
		private var _loadResource:ResourceLoader;						//ResourceLoader 객체 선언
		private var _packer:Packer = new Packer();						//Packer 객체 선언 및 초기화
		
		private var _count:int = 0;										//시트가 1장을 넘어갈 경우 이름을 바꿔주기 위한 변수
	
		private var _fileStream:FileStream = new FileStream(); 			//파일스트림 객체
		
		private var _button0:SimpleButton = new SimpleButton();			//알고리즘 선택 버튼
		private var _button1:SimpleButton = new SimpleButton();			//알고리즘 선택 버튼
		
		private var _button2:SimpleButton = new SimpleButton();			//리사이징 선택 버튼
		private var _text2:TextField = new TextField();
		private var _isReSizing:Boolean;
		
		private var _finalArray:Array = new Array();					//최종적으로 만들어지는 배열
		
		private var _loadingText:TextField = new TextField();			//이미지 로딩의 진행을 알려주는 텍스트필드
		
		
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
			//로딩 텍스트필드 
			_loadingText.x = 325;
			_loadingText.y = 200;
			_loadingText.autoSize = "left";
			addChild(_loadingText);
			
			
			//버튼0 (Shelf)
			var text0:TextField = new TextField();
			text0.text = "Shelf";
			text0.autoSize = "left";
			text0.border = true;
			_button0.upState = text0;			
			_button0.overState = text0;
			_button0.hitTestState = text0;
			_button0.x = 300;
			_button0.y = 300;
			addChild(_button0);
			
			//버튼1 (MaxRect)
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
			
			//버튼2 (리사이징)
			 
			_text2.text = "Resizing";
			_text2.autoSize = "left";
			_text2.border = true;			
			_button2.upState = _text2;
			_button2.overState = _text2;
			_button2.hitTestState = _text2;
			_button2.x = 500;
			_button2.y = 300;
			addChild(_button2);
			
			//마우스 클릭을 떼는 시점을 구별하기위해 이벤트 리스너에 등록
			stage.addEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp);
		}
		
		/**
		 * 
		 * @param e 마우스 업
		 *  마우스 업 이벤트 콜백 메소드
		 */
		public function onButtonMouseUp(e:MouseEvent):void
		{			
			//마우스 클릭을 떼는 시점에 타겟이 버튼0이면 내부적으로 변수 값을 0으로 하고, 이후에 있을 makeSpriteSheet 메소드에 매개변수로 넘겨준다. (버튼1이면 1을 넘겨줌)
			switch(e.target)
			{
				case _button0 :					
					makeSpriteSheet(0);
					break;
				
				case _button1 :
					makeSpriteSheet(1);				
					break;
				case _button2 :
				{
					_isReSizing = !_isReSizing;
					if(_isReSizing)
						_text2.text = "No Resizing";
					else
						_text2.text = "Resizing";
					_button2.upState = _text2;
					_button2.overState = _text2;
					_button2.hitTestState = _text2;
					break;
				}
			}
			
			
			//프로그램 전체에서 클릭이벤트는 한번만 있기 때문에 바로 리무브
			//stage.removeEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp);
		}
		
		/**
		 * 
		 * @param select 0이면 shelf , 1이면 맥스렉트
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
						bitmap = _packer.mergeImageByShelf(_finalArray);
						break;
					//Max Rects 알고리즘
					case 1:
						bitmap = _packer.mergeImageByMaxRects(_finalArray);
						break;
				
				}
				if(_isReSizing)
				{
					bitmap.bitmapData = Resizer.cutCanvas(bitmap.bitmapData);
				}
				
				addChild(bitmap);
								
				saveToPNG(bitmap);	
								
				exportToXML(_packer.forXMLArray);
				
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
			
			//얼마나 로딩됬는지를 나타냄
			if(_loadResource.imageDataArray.length / _loadResource.fileCount != 1)
				_loadingText.text = (_loadResource.imageDataArray.length / _loadResource.fileCount * 100).toFixed(1);
			else if(_loadResource.imageDataArray.length / _loadResource.fileCount == 1)
				_loadingText.text = "이미지 로딩 완료\n" +
					"알고리즘을 선택하세요";
			else
				_loadingText.text = "이미지 로딩 실패";
				
			//모두 로딩이 됬다면
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
			//내문서에 저장됨
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