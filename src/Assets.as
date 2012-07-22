package
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.filters.*;
	import flash.geom.*;
	import flash.media.Sound;
	
	import mx.core.SoundAsset;
	
	public class Assets
	{
		[Embed(source="../sfx/red_shot.mp3")]
		public static var red_shot_sound_src:Class;
		public static var red_shot_sound:SoundAsset = new red_shot_sound_src() as SoundAsset;
		
		[Embed(source="../sfx/green_shot.mp3")]
		public static var green_shot_sound_src:Class;
		public static var green_shot_sound:SoundAsset = new green_shot_sound_src() as SoundAsset;
		
		[Embed(source="../sfx/blue_shot.mp3")]
		public static var blue_shot_sound_src:Class;
		public static var blue_shot_sound:SoundAsset = new blue_shot_sound_src() as SoundAsset;


		public static var bitmapData:Object = new Object();
		public static var alphaBitmapData:Object = new Object();		
		
		public static function startup():void
		{
			generatePlayerGraphics();
			generateEnemyGraphics();
			
			cacheAsBitmap(AssetKeys.RED_LASER, drawLaser(0xFF0000, 2, 20));
			cacheAsBitmap(AssetKeys.GREEN_LASER, drawLaser(0x00FF00, 2, 20));
			cacheAsBitmap(AssetKeys.BLUE_LASER, drawLaser(0x0000FF, 2, 20));
		}
		
		private static function generatePlayerGraphics():void
		{			
			cacheAsBitmap(AssetKeys.PLAYER, drawSquare(0xFFFFFF, 2, 0xAAAAAA, 15));
		}
		
		private static function generateEnemyGraphics():void
		{
			cacheAsBitmap(AssetKeys.RED_SQUARE, drawSquare(0xFF0000, 2, 0xAA0000, 15));
			cacheAsBitmap(AssetKeys.GREEN_SQUARE, drawSquare(0x00FF00, 2, 0x00AA00, 15));
			cacheAsBitmap(AssetKeys.BLUE_SQUARE, drawSquare(0x0000FF, 2, 0x0000AA, 15));
		}		
		
		private static function generateLaser(color:uint, assetKey:String):void
		{
			var laser:Shape = new Shape();
	
			laser.graphics.beginFill(color, 1);			
			laser.graphics.drawEllipse(0, 0, 32, 4);
			laser.graphics.endFill();
			trace(laser.getBounds(game_2.bitmap));

			var filter:DropShadowFilter = new DropShadowFilter(24, 180, color, 0.7, 16, 0, 4, 4);
			var filterRect:Rectangle = game_2.bitmap.bitmapData.generateFilterRect(laser.getBounds(game_2.bitmap), filter);
			laser.filters = [filter];
			trace(laser.blendMode);
			trace(filterRect);						
			
			var laserBitmapData:BitmapData = new BitmapData(filterRect.width, filterRect.height, true, 0x00000000);			
			laserBitmapData.draw(laser, new Matrix(1, 0, 0, 1, -filterRect.x, -filterRect.y));//, null, flash.display.BlendMode.ADD);
			trace("laserBitmapData.rect: " + laserBitmapData.rect);
//			var laserAlphaBitmapData:BitmapData = new BitmapData(filterRect.width, filterRect.height, true, 0xFFFFFFFF);		
//			laserAlphaBitmapData.draw(laser, new Matrix(1, 0, 0, 1, -filterRect.x, -filterRect.y), null, flash.display.BlendMode.ALPHA);

			
			bitmapData[assetKey] = laserBitmapData;
//			alphaBitmapData[assetKey] = laserAlphaBitmapData;
		}
		
		public static function cacheAsBitmap(key:String, value:DisplayObject):void
		{
			bitmapData[key] = extractBitmapData(value);
			alphaBitmapData[key] = extractAlphaBitmapData(value);	
		}
		
		private static function extractBitmapData(source:DisplayObject):BitmapData
		{
			var sourceRect:Rectangle = source.getBounds(game_2.bitmap);						

			var bd:BitmapData = new BitmapData(source.width, source.height, true, 0x00000000);			
			bd.draw(source, new Matrix(1, 0, 0, 1, -sourceRect.x, -sourceRect.y));
			sourceRect = null;
			return bd;
		}
		
		private static function extractAlphaBitmapData(source:DisplayObject):BitmapData
		{									
			var sourceRect:Rectangle = source.getBounds(game_2.bitmap);

			var bd:BitmapData = new BitmapData(source.width, source.height, true, 0xFFFFFFFF);			
			bd.draw(source, new Matrix(1, 0, 0, 1, -sourceRect.x, -sourceRect.y), null, flash.display.BlendMode.ALPHA);
			sourceRect = null;			
			return bd;
		}
		
		private static function drawSquare(borderColor:Number, borderThickness:Number, fillColor:Number, width:Number):Shape
		{
			var square:Shape = new Shape();			
			square.graphics.lineStyle(borderThickness, borderColor, 1, true);
			square.graphics.beginFill(fillColor);
			square.graphics.drawRect(0, 0, width, width);
			square.graphics.endFill();						
			return square;
		}
		
		private static function drawLaser(color:Number, thickness:Number, length:Number):Shape
		{
			var laser:Shape = new Shape();
			/*laser.graphics.beginFill(color);
			laser.graphics.drawCircle(0, 0, thickness);
			laser.graphics.endFill();*/
			laser.graphics.lineStyle(thickness, color, 1, true);			
			laser.graphics.lineTo(length, 0);						
			return laser;
		}
		
	}
}