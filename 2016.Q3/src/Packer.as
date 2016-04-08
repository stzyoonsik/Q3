package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Packer
	{
		private const MAX_WIDTH:int = 1024;
		private const MAX_HEIGHT:int = 1024;
		
		private var _forXMLArray:Array = new Array();					//xml에 쓸 데이터 배열
		
		public function Packer()
		{
		}		


		public function get forXMLArray():Array
		{
			return _forXMLArray;
		}

		public function set forXMLArray(value:Array):void
		{
			_forXMLArray = value;
		}

			
		
		/**
		 * 
		 * @param imageArray 이미지가 들어있는 Array를 받아옴
		 * @return 새 Bitmap에 이미지를 넣고 리턴
		 * 하나의 큰 도화지에 이미지들을 MaxRects 알고리즘을 기반으로 넣어주는 메소드
		 */
		public function mergeImageByMaxRects(imageArray:Array):Bitmap
		{
			var canvas:BitmapData = new BitmapData(MAX_WIDTH, MAX_HEIGHT, false);
			var tempRect:Rectangle = new Rectangle(0, 0, MAX_WIDTH, MAX_HEIGHT);
			canvas.fillRect(tempRect, 0xAAAAAA);
			
			
			var mult:uint = 0xFF;			
			
			var maxRect:MaxRectPacker = new MaxRectPacker(MAX_WIDTH, MAX_HEIGHT);
			
			imageArray.sort(compareHeightDescending);
			
			for(var i:int = 0; i<imageArray.length; ++i)
			{	
				var rect:Rectangle = maxRect.quickInsert(imageArray[i].bitmapData.width, imageArray[i].bitmapData.height); 
				if(rect == null)
					continue;
				
				var point:Point = new Point(rect.x, rect.y);
				canvas.merge(imageArray[i].bitmapData, imageArray[i].bitmapData.rect, point, mult, mult, mult, mult);
				
				var imageData:ImageData = new ImageData();
				imageData.name = imageArray[i].name;
				imageData.rect.x = point.x;
				imageData.rect.y = point.y;
				imageData.rect.width = imageArray[i].bitmapData.width;
				imageData.rect.height = imageArray[i].bitmapData.height;
				_forXMLArray.push(imageData);
			}
			trace(imageArray.length + "개의 이미지 중 " + _forXMLArray.length + "개의 이미지 패킹 완료");
			return new Bitmap(canvas);
		}
		
		
		
		/**
		 * 
		 * @param imageArray 이미지가 들어있는 Array를 받아옴
		 * @return 새 Bitmap에 이미지를 넣고 리턴
		 * 하나의 큰 도화지에 이미지들을 Height를 기준으로 내림차순으로 넣어주는 메소드		 * 
		 */
		public function mergeImageByHeight(imageArray:Array):Bitmap
		{
			var canvas:BitmapData = new BitmapData(MAX_WIDTH, MAX_HEIGHT, false);
			var rect:Rectangle = new Rectangle(0, 0, MAX_WIDTH, MAX_HEIGHT);
			canvas.fillRect(rect, 0xAAAAAA);
			
			
			var bm:Bitmap;
			var point:Point = new Point(0,0);
			var mult:uint = 0xFF;					 // 알파값 조정 없이 100%로 이용 
			
			var newLine:Boolean = true;
			var tempHeight:int;
			
			//이미지의 height를 기준으로 내림차순 정렬
			imageArray.sort(compareHeightDescending);
			
			
			for(var i:int = 0; i<imageArray.length; ++i)
			{				
				bm = new Bitmap(imageArray[i].bitmapData);					
				
				if(newLine)
				{
					if(i == 0)
					{
						tempHeight = imageArray[i].bitmapData.height;
						trace("다음 라인의 height = " + tempHeight, imageArray[i].name);
					}
					else
					{
						tempHeight = imageArray[i-1].bitmapData.height;
						trace("다음 라인의 height = " + tempHeight, imageArray[i-1].name);
					}
					
					newLine = false;
					
				}
				
				if(i > 0)
				{
					//도화지의 가로 길이를 벗어나지 않으면
					if(point.x + imageArray[i-1].bitmapData.width + imageArray[i].bitmapData.width < MAX_WIDTH)
					{
						point.x += imageArray[i-1].bitmapData.width;
					}
					
					else
					{
						newLine = true;
						point.y += tempHeight;
						point.x = 0;
					}
					
					//도화지의 세로 길이를 벗어나면 종료
					if(point.y + imageArray[i].bitmapData.height > MAX_HEIGHT)
					{
						trace(i + "개의 이미지 패킹 완료");
						trace(imageArray.length - i + "개의 이미지는 패킹되지 않았음.");
						break;
					}
					trace(i + " " + point + " width = " + imageArray[i].bitmapData.width + " height = " + imageArray[i].bitmapData.height);
				}
				
				else
				{
					trace(i + " " + point + " width = " + imageArray[i].bitmapData.width + " height = " + imageArray[i].bitmapData.height);						
				}
				
				//큰 도화지에 하나씩 붙여넣음
				canvas.merge(bm.bitmapData, bm.bitmapData.rect, point, mult, mult, mult, mult);
				
				//xml로 쓸 데이터를 array에 저장
				var imageData:ImageData = new ImageData();
				imageData.name = imageArray[i].name;
				imageData.rect.x = point.x;
				imageData.rect.y = point.y;
				imageData.rect.width = imageArray[i].bitmapData.width;
				imageData.rect.height = imageArray[i].bitmapData.height;
				_forXMLArray.push(imageData);								
				
			}
			
			trace(imageArray.length + "개의 이미지 중 " + _forXMLArray.length + "개의 이미지 패킹 완료");
			return new Bitmap(canvas);
		}
		
		
		/**
		 * 
		 * @param a 이미지의 height 값
		 * @param b
		 * @return 내림차순
		 * 비교함수
		 */
		public function compareHeightDescending(a, b):int
		{
			var aHeight:int = a.bitmapData.height;
			var bHeight:int = b.bitmapData.height;
			
			
			if (bHeight < aHeight) 
			{ 
				return -1; 
			} 
			else if (bHeight > aHeight) 
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
		}
		
		public function compareHeightAscending(a, b):int
		{
			var aHeight:int = a.bitmapData.height;
			var bHeight:int = b.bitmapData.height;
			
			
			if (bHeight > aHeight) 
			{ 
				return -1; 
			} 
			else if (bHeight < aHeight) 
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
		}
	}
}