package
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;

	public class ResourceLoader
	{		

		

		private var _completeFunc:Function;		
		
		
		private var _urlArray:Array = new Array();					//파일명이 담긴 배열
		private var _imageDataArray:Array = new Array();			//ImageData가 담긴 배열 
		
		private var _fileCount:int;
		
		
		public function get imageDataArray():Array
		{
			return _imageDataArray;
		}
		
		public function set imageDataArray(value:Array):void
		{
			_imageDataArray = value;
		}
		
	
		
		public function get fileCount():int
		{
			return _fileCount;
		}
		
		public function set fileCount(value:int):void
		{
			_fileCount = value;
		}
		
		
		
		
		public function ResourceLoader(cFunc:Function)
		{
			_completeFunc = cFunc;
			
			var array:Array = new Array();
			array = getResource();
			findOnlyImageFile(array);
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
			var slash:int = name.lastIndexOf("/");
			var dot:int = name.lastIndexOf(".");
			name = name.substring(slash + 1, dot);			
			
			var imageData:ImageData = new ImageData();
			imageData.name = name;
			
			var _bitmapData:BitmapData = new BitmapData(loaderInfo.width, loaderInfo.height);			
			_bitmapData.draw(loaderInfo.loader);
			imageData.bitmapData = _bitmapData;
			
			_imageDataArray.push(imageData);
			
			loaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete);
			_completeFunc();
			
			
		}
		
		public function onLoaderFailed(event:Event):void
		{
			trace("로드 실패 " + event);
			_fileCount--;
		}
		
		
		/**
		 * 각각의 리소스를 로드하고 이벤트를 붙여주는 메소드 
		 * 
		 */
		private function buildLoader():void
		{
			for(var i:int = 0; i<_urlArray.length; ++i)
			{
				var loader:Loader = new Loader();				
				loader.load(new URLRequest(_urlArray[i]));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);				
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderFailed);
				
			}			
			
		}		
		
	
		
		/**
		 * application 디렉토리에 있는 모든 파일을 가져와서 각각을 Array에 저장하고 리턴하는 메소드 
		 * @return 폴더 안의 각각의 파일들
		 * 
		 */
		private function getResource():Array
		{
			var directory:File = File.applicationDirectory.resolvePath("resources");
			
			var array:Array = directory.getDirectoryListing();			
			
			
			return array;
		}
		
		/**
		 * 
		 * @param resourceArray 폴더 안에 들어있던 모든 파일들
		 * 파일 이름을 push하는 메소드
		 */
		private function findOnlyImageFile(resourceArray:Array):void
		{			
			for(var i:int = 0; i<resourceArray.length; ++i)
			{				
				var url:String = resourceArray[i].url; 		
				url = url.substring(5, url.length);	
				
				_urlArray.push(url);					
				_fileCount++;
				
			}
		}
	}
}