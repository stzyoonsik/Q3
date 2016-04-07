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
		
		public function Packer()
		{
		}
		
		/**
		 * 
		 * @param imageArray 이미지가 들어있는 Array를 받아옴
		 * @return 새 Bitmap에 이미지를 넣고 리턴
		 * 하나의 큰 도화지에 이미지들을 넣어주는 메소드
		 */
		public function mergeImages(imageArray:Array):Bitmap
		{
			var canvas:BitmapData = new BitmapData(MAX_WIDTH, MAX_HEIGHT, false);
			var rect:Rectangle = new Rectangle(0, 0, MAX_WIDTH, MAX_HEIGHT);
			canvas.fillRect(rect, 0xAAAAAA);
			
			
			var bm:Bitmap;
			var point:Point = new Point(0,0);
			var mult:uint = 0xFF; // 50% 
			
			var newLine:Boolean = true;
			var tempHeight:int;
			
			//이미지의 height를 기준으로 내림차순 정렬
			imageArray.sort(compareHeight);
			
			for(var i:int = 0; i<imageArray.length; ++i)
			{				
				bm = new Bitmap(imageArray[i]);					
				
				if(newLine)
				{
					tempHeight = imageArray[i].height; 
					newLine = false;
				}
				
				if(i > 0)
				{
					//도화지의 가로 길이를 벗어나지 않으면
					if(point.x + imageArray[i-1].width + imageArray[i].width < MAX_WIDTH)
					{
						point.x += imageArray[i-1].width;
					}
					
					else
					{
						//point.y += findMax(imageArray);
						newLine = true;
						point.y += tempHeight;
						point.x = 0;
					}
					
					//도화지의 세로 길이를 벗어나면 종료
					if(point.y + imageArray[i].height > MAX_HEIGHT)
					{
						break;
					}
					
					
					trace(i + point);
				}
				else
				{
					trace(i + point);						
				}
				
				canvas.merge(bm.bitmapData, bm.bitmapData.rect, point, mult, mult, mult, mult);
				
			}
			
			return new Bitmap(canvas);
		}
		
		
		/**
		 * 
		 * @param a 이미지의 height 값
		 * @param b
		 * @return 내림차순
		 * 비교함수
		 */
		public function compareHeight(a, b):int
		{
			var aHeight:int = a.height;
			var bHeight:int = b.height;
			
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
	}
}