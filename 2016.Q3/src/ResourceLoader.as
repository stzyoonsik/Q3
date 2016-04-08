package
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class ResourceLoader
	{
		//File.getDirectoryListing() 써라!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		private var _completeFunc:Function;		
		
		
		private var _urlArray:Array = new Array();					//파일명이 담긴 배열
		private var _imageDataArray:Array = new Array();			//ImageData가 담긴 배열 
		
		
		public function get imageDataArray():Array
		{
			return _imageDataArray;
		}
		
		public function set imageDataArray(value:Array):void
		{
			_imageDataArray = value;
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
			buildLoader();
		}
		
		
		/**
		 * 
		 * @param event 로딩이 끝나면 이벤트를 받아옴
		 * BitmapData에 로딩된 타겟을 그리고 배열에 푸쉬하는 리스너함수
		 */
		public function onLoaderComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			
			var name:String = loaderInfo.url;
			name = name.substring(5, name.length - 4);			
			
			var imageData:ImageData = new ImageData();
			imageData.name = name;
			
			var _bitmapData:BitmapData = new BitmapData(loaderInfo.width, loaderInfo.height);			
			_bitmapData.draw(loaderInfo.loader);
			imageData.bitmapData = _bitmapData;
			
			_imageDataArray.push(imageData);
			
			_completeFunc();
			
		}
		
		
		/**
		 * 각각의 리소스를 로드하고 이벤트를 붙여주는 메소드 
		 * 
		 */
		private function buildLoader():void
		{
			for(var i:int = 0; i<_urlArray.length; ++i)
			{
				var _loader:Loader = new Loader();
				
				_loader.load(new URLRequest(_urlArray[i]));
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);				
				
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
			_urlArray.push("5.png");
			_urlArray.push("6.png");
			_urlArray.push("7.png");
			_urlArray.push("8.png");
			_urlArray.push("9.png");
			
			_urlArray.push("a.png");
			_urlArray.push("b.png");
			_urlArray.push("c.png");
			_urlArray.push("d.png");
			_urlArray.push("e.png");
			_urlArray.push("f.png");
			_urlArray.push("g.png");
			_urlArray.push("h.png");
			_urlArray.push("i.png");
			_urlArray.push("j.png");
			_urlArray.push("k.png");
			_urlArray.push("l.png");
			_urlArray.push("m.png");
		
		}
		
	}
}