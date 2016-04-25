package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Packer
	{
		private const MAX_WIDTH:int = 1024;
		private const MAX_HEIGHT:int = 1024;
		private const BGCOLOR:uint = 0xAAAAAA;
		private var _packedImageArray:Array = new Array();					//xml에 쓸 데이터 배열
		
		private var _unpackedImageArray:Array = new Array();			//패킹되지 못한 이미지 파일들이 담긴 배열
		
		private var _packedImageCount:int;
		
	


		public function get packedImageCount():int
		{
			return _packedImageCount;
		}

		public function set packedImageCount(value:int):void
		{
			_packedImageCount = value;
		}

		public function get unpackedImageArray():Array
		{
			return _unpackedImageArray;
		}

		public function set unpackedImageArray(value:Array):void
		{
			_unpackedImageArray = value;
		}

		public function get packedImageArray():Array
		{
			return _packedImageArray;
		}

		public function set packedImageArray(value:Array):void
		{
			_packedImageArray = value;
		}

		

		/**
		 * 
		 * @param imageArray 이미지가 들어있는 Array를 받아옴
		 * @return 새 Bitmap에 이미지를 넣고 리턴
		 * 하나의 큰 도화지에 이미지들을 MaxRects 알고리즘을 기반으로 넣어주는 메소드
		 */
		public function mergeImageByMaxRects(imageArray:Array):void
		{
		
			
			var maxRect:MaxRectPacker = new MaxRectPacker(MAX_WIDTH, MAX_HEIGHT);
			
			//면적 기준 내림차순 정렬
			//imageArray.sort(compareAreaDescending);
			
			//이름 기준 정렬
			imageArray.sort(compareName);
			
			for(var i:int = 0; i<imageArray.length; ++i)
			{	
				trace("삽입 이미지 Name = " + imageArray[i].name + " Rect = " + imageArray[i].bitmapData.rect);
				var rect:Rectangle = maxRect.quickInsert(imageArray[i].bitmapData.width, imageArray[i].bitmapData.height); 
				trace("삽입 위치 = " + rect);
				if(rect == null)
				{
					_unpackedImageArray.push(imageArray[i]);
					continue;
				}
				
				
				var imageData:ImageData = new ImageData();
				imageData.bitmapData = imageArray[i].bitmapData;
				imageData.name = imageArray[i].name;
				imageData.rect.x = rect.x;
				imageData.rect.y = rect.y;
				imageData.rect.width = imageArray[i].bitmapData.width;
				imageData.rect.height = imageArray[i].bitmapData.height;
				_packedImageArray.push(imageData);
				
				_packedImageCount++;
				
				
			}
		}

		
		/**
		 * 
		 * @param imageArray 이미지가 들어있는 Array를 받아옴
		 * @return 새 Bitmap에 이미지를 넣고 리턴
		 * 하나의 큰 도화지에 이미지들을 Height를 기준으로 내림차순으로 넣어주는 메소드		 * 
		 */
		public function mergeImageByShelf(imageArray:Array):void
		{
			var point:Point = new Point(0,0);
			
			var newLine:Boolean = true;
			var tempHeight:int;
			
			var isFull:Boolean;
			
			//이미지의 height를 기준으로 내림차순 정렬
			//imageArray.sort(compareHeightDescending);
			imageArray.sort(compareHeightDescending);
			
			for(var i:int = 0; i<imageArray.length; ++i)
			{								
				
				if(isFull)
				{
					_unpackedImageArray.push(imageArray[i]);
					continue;
				}
				if(newLine)
				{
					if(i == 0)
					{
						tempHeight = imageArray[i].bitmapData.height;
						//trace("다음 라인의 height = " + tempHeight, imageArray[i].name);
					}
					else
					{
						tempHeight = imageArray[i-1].bitmapData.height;
						//trace("다음 라인의 height = " + tempHeight, imageArray[i-1].name);
					}
					
					newLine = false;
					
				}
				
				if(i > 0)
				{
					//도화지의 가로 길이를 벗어나지 않으면
					if(point.x + imageArray[i-1].bitmapData.width + imageArray[i].bitmapData.width <= MAX_WIDTH)
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
						isFull = true;
						continue;
					}
					//trace(i + " " + point + " width = " + imageArray[i].bitmapData.width + " height = " + imageArray[i].bitmapData.height);
				}
				
				else
				{
					//trace(i + " " + point + " width = " + imageArray[i].bitmapData.width + " height = " + imageArray[i].bitmapData.height);						
				}
				
				//큰 도화지에 하나씩 붙여넣음
				
				
				var imageData:ImageData = new ImageData();
				imageData.bitmapData = imageArray[i].bitmapData;
				imageData.name = imageArray[i].name;
				imageData.rect.x = point.x;
				imageData.rect.y = point.y;
				imageData.rect.width = imageArray[i].bitmapData.width;
				imageData.rect.height = imageArray[i].bitmapData.height;
				_packedImageArray.push(imageData);						
				
				_packedImageCount++;
			}
			
			trace(_unpackedImageArray.length + "개의 이미지 패킹 실패");
			trace(imageArray.length + "개의 이미지 중 " + _packedImageArray.length + "개의 이미지 패킹 완료");
			
			
			
		}
		
		
		/**
		 * 
		 * @param a 이미지의 데이터
		 * @param b
		 * @return a가 height가 더 크다면 -1, b가 크다면 1, 같으면 0
		 * 내림차순 비교함수
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
		
		/**
		 * 
		 * @param a 이미지의 데이터
		 * @param b
		 * @return 
		 * 오름차순
		 */
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
		
		/**
		 * 
		 * @param a 이미지의 데이터
		 * @param b 이미지의 데이터
		 * @return  a가 면적이 더 크다면 -1, b가 크다면 1, 같으면 0
		 * 내림차순
		 */
		public function compareAreaDescending(a, b):int
		{
			var aArea:int = a.bitmapData.height * a.bitmapData.width;
			var bArea:int = b.bitmapData.height * b.bitmapData.width;
			
			
			if (bArea < aArea) 
			{ 
				return -1; 
			} 
			else if (bArea > aArea) 
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
		}
		
		/**
		 * 
		 * @param a 이미지의 데이터
		 * @param b 이미지의 데이터
		 * @return  
		 * 내림차순
		 */
		public function compareName(a, b):int
		{
			//var aName:int = a.bitmapData.height * a.bitmapData.width;
			//var bName:int = b.bitmapData.height * b.bitmapData.width;
			
			
			if (b.name > a.name) 
			{ 
				return -1; 
			} 
			else if (b.name < a.name) 
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