/* Because this is a pooled object, the constructor should never be called externally.  Unfortunately,
ActionScript doesn't allow private constructors, so forcing this condition isn't possible.  Always use 
ObjectClass.pool.item when using pooled objects. */
package
{
	import flash.display.*;
	import flash.geom.*;
	
	public class Laser extends GameObject
	{
	 	public static var pool:Pool = new Pool(function():Laser { return new Laser; });
		public var inPool:Boolean = false;
		
		public function Laser()
		{
			
		}
		
		override public function step():void
		{
			super.step();
			if (this.x > game_2.bitmap.width || this.x + this.width < 0 
				|| this.y > game_2.bitmap.height || this.y + this.height < 0)
				shutdown();
		}				

/*		override public function draw():void
		{
			if (this.inPlay)
			{
				game_2.afterimageBitmap.bitmapData.draw(bitmapData, new Matrix(1, 0, 0, 1, x, y), null, flash.display.BlendMode.ADD, null, false);				 
			}
		}
*/		
		override public function shutdown():void
		{
			super.shutdown();
			inPool = true;			
		}
	}
}
