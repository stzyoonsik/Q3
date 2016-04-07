package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class ResourceLoader
	{
		private var _completeFunc:Function;
		
		private var _bitmapData:BitmapData;
	
		
		private var _loaderArray:Array = new Array();
		private var _bitmapDataArray:Array = new Array();
		
		
		private var _urlArray:Array = new Array();
		
		
		private var _loader:Loader;// = new Loader();
		
		
	
		public function get bitmapDataArray():Array
		{
			return _bitmapDataArray;
		}
		
		public function set bitmapDataArray(value:Array):void
		{
			_bitmapDataArray = value;
		}
		
		public function get urlArray():Array
		{
			return _urlArray;
		}
		
		public function set urlArray(value:Array):void
		{
			_urlArray = value;
		}
		
		
		
		
		
		public function ResourceLoader(cFunc:Function)
		{

			_completeFunc = cFunc;
			buildURLArray();
			buildArrLoader();
			
		}
		
		
		/**
		 * 
		 * @param event 로딩이 끝나면 이벤트를 받아옴
		 * BitmapData에 로딩된 타겟을 그리고 배열에 푸쉬하는 리스너함수
		 */
		public function onLoaderComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			_bitmapData = new BitmapData(loaderInfo.width, loaderInfo.height);			
			_bitmapData.draw(loaderInfo.loader);
			
			_bitmapDataArray.push(_bitmapData);
			_completeFunc();
			
			//_loader.removeEventListener(Event.COMPLETE, onLoaderComplete);
		}
		
		
		/**
		 * 각각의 리소스를 로드하고 이벤트를 붙여주는 메소드 
		 * 
		 */
		private function buildArrLoader():void
		{
			for(var i:int = 0; i<_urlArray.length; ++i)
			{
				_loader = new Loader();
				
				_loader.load(new URLRequest(_urlArray[i]));
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
				
				_loaderArray.push(_loader);
			}			
			
		}
		
		
		/**
		 * 리소스의 이름을 Array에 푸쉬하는 메소드 
		 * 
		 */
		private function buildURLArray():void
		{
			_urlArray.push("0.png");
			_urlArray.push("1.png");
			_urlArray.push("2.png");
			_urlArray.push("3.png");
			_urlArray.push("4.png");
//			_urlArray.push("stz.jpg");
//			_urlArray.push("close.png");
//			_urlArray.push("minimize.png");
//			
		}
		
	}
}