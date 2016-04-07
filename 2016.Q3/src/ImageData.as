package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class ImageData
	{
		private var _name:String;
		private var _rect:Rectangle = new Rectangle();
		
		private var _bitmapData:BitmapData;
		
		public function ImageData()
		{
		}

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
		}

		public function get rect():Rectangle
		{
			return _rect;
		}

		public function set rect(value:Rectangle):void
		{
			_rect = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

	}
}