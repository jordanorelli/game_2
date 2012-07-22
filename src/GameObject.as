// There's more get/set functionality at the bottom.  I moved it to the bottom because
// Flex Builder won't keep folded code sections folded, and it got really annoying having
// them at the top.  Notable is that setting assetKey retrieves the assets from the asset
// library, and that inPlay is a read-only boolean.  Altering inPlay can only be done
// externally through the startup() and shutdown() methods.  Protected/private properties 
// that begin with an underscore (_) signify that they have custom get/set methods that 
// perform some additional action and should not be accessed outside their get/set methods, 
// while protected/private properties without the underscore are just regular private
// properties.  I use vx and vy so that the speeds are independent of the game's frame rate.
package
{
	import flash.display.BitmapData;
	import flash.geom.*;
			
	public class GameObject
	{
		public var x:Number = 0;
		public var y:Number = 0;		
		public var dx:Number = 0;
		public var dy:Number = 0;
		public var collisionType:uint;
		public var inPlay:Boolean = false;
		public var numGhosts:int = 0;		
		
		protected var _assetKey:String;	// use the get/set methods to access this property!
		protected var bitmapData:BitmapData;
		protected var alphaBitmapData:BitmapData;
		protected var ghostAlphas:Array = new Array(numGhosts); 	// BitmapData only
		protected var ghostOrigins:Array = new Array(numGhosts); 	// Points only
											// ghostOrigins[n] stores the origin of the sprite at n+1 frames ago.
						
		public function GameObject()
		{
			
		}
		
		public function toString():String
		{
			return "[GameObject x:" + this.x + " y:" + this.y + " assetKey:" + this.assetKey + " collisionType:" + this.collisionType + "]";
		}
		
		public function startup(x:Number, y:Number, assetKey:String, collisionType:uint):void
		{
			if(!this.inPlay)
			{
				this.x = x;								
				this.y = y;
				this.assetKey = assetKey;
				this.collisionType = collisionType;		
				for (var i:int = 0; i < numGhosts; i++)
				{		
					this.ghostOrigins.push(new Point(x, y));
				}
				ObjectManager.addGameObject(this);
				
			}			
		}
		
		public function step():void
		{
			x += dx;
			y += dy;
			ghostOrigins.shift();
			ghostOrigins.push(new Point(x,y));
		}
		
		public function draw():void
		{
			if (this.inPlay)
			{
				game_2.bitmap.bitmapData.copyPixels(bitmapData, bitmapData.rect, new Point(x, y), alphaBitmapData, new Point(0,0), true);				
				for (var i:int = 0; i < numGhosts; i++)
				{
					game_2.bitmap.bitmapData.copyPixels(bitmapData, bitmapData.rect, ghostOrigins[i], ghostAlphas[i], new Point(0,0), true);
				}
			}		
		}
		
		public function collide(other:GameObject):void
		{
			shutdown();	
		}
		
		public function shutdown():void
		{
			ObjectManager.removeGameObject(this);
		}
				
		public function get width():Number
		{
			return bitmapData.width;
		}
		
		public function get height():Number
		{
			return bitmapData.height;
		}
				
		public function get rect():Rectangle
		{
			return new Rectangle(x, y, width, height);
		}
		
		public function set assetKey(value:String):void
		{
			this.bitmapData = Assets.bitmapData[value];
			this.alphaBitmapData = Assets.alphaBitmapData[value];
			for (var ghost:int = 0; ghost < this.numGhosts; ghost++)
			{
				this.ghostAlphas[ghost] = new BitmapData(this.bitmapData.width, this.bitmapData.height, true, 0xFFFFFFFF);
				for (var i:int = 0; i < this.bitmapData.width; i++)
				{
					for (var j:int = 0; j < this.bitmapData.width; j++)
					{
						ghostAlphas[ghost].setPixel(i,j, 0);
					}							
				}
			}
			_assetKey = value;
		}
		
		public function get assetKey():String
		{
			return _assetKey;
		}
	}
}