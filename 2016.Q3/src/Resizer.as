package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class Resizer
	{
		private static const MAX_WIDTH:int = 1024;
		private static const MAX_HEIGHT:int = 1024;
		private static const STRBGCOLOR:String = "aaaaaa";
		
		/**
		 * 
		 * @param canvas 완성된 캔버스를 받아옴
		 * @return 불필요한 부분을 제거하고 리턴
		 * 캔버스 각각의 픽셀의 RGB값을 비교하여 최소한의 2^n 크기로 자르고 리턴하는 메소드
		 */
		public static function cutCanvas(canvas:BitmapData):BitmapData
		{
			var newWidth:int = 0;
			var newHeight:int = 0;
			
			var x:int, y:int;
			//높이 검사
			for(x=MAX_WIDTH-1; x>=0; --x)
			{
				for(y=MAX_HEIGHT-1; y>=0; --y)
				{
					if(canvas.getPixel(x, y).toString(16) != STRBGCOLOR)
					{
						if(y > newHeight)
						{
							newHeight = y + 1;	
							break;
						}
					}
				}
			}
			
			//너비 검사
			for(y=MAX_WIDTH-1; y>=0; --y)
			{
				for(x=MAX_HEIGHT-1; x>=0; --x)
				{
					if(canvas.getPixel(x, y).toString(16) != STRBGCOLOR)
					{
						if(x > newWidth)
						{
							newWidth = x + 1;	
							break;
						}
					}
				}
			}
			
			
			newWidth = findCorrectWidth(newWidth);
			newHeight = findCorrectHeight(newHeight);
			
			var rect:Rectangle = new Rectangle(0, 0, newWidth, newHeight);
			var bitmapData:BitmapData = new BitmapData(newWidth, newHeight, false);
			
			bitmapData.draw(canvas, null, null, null, rect, false);
			
			//trace("newWidth = " + newWidth + " newHeight = " + newHeight);
			
			
			
			return bitmapData;
		}
		
		/**
		 * 
		 * @param width 패킹된 이미지들의 최대 x값
		 * @return 적절한 크기
		 * 
		 */
		public static function findCorrectWidth(width:int):int
		{
			var newWidth:int;
			
			if(width > 512 && width <= 1024)
			{
				newWidth = 1024;
			}
			else if(width > 256 && width <= 512)
			{
				newWidth = 512;
			}
			else
			{
				newWidth = 256;
			}
			
			
			return newWidth;
		}
		
		/**
		 * 
		 * @param height 패킹된 이미지들의 최대 y값
		 * @return 적절한 크기
		 * 
		 */
		public static function findCorrectHeight(height:int):int
		{
			var newHeight:int;
			
			if(height > 512 && height <= 1024)
			{
				newHeight = 1024;
			}
			else if(height > 256 && height <= 512)
			{
				newHeight = 512;
			}
			else
			{
				newHeight = 256;
			}
			
			
			
			
			return newHeight;
		}
	}
}