package
{
	import flash.events.TimerEvent;
	import flash.system.System;
	
	public class Player extends GameObject
	{		
		public var isDead:Boolean = false;
		private var godMode:Boolean = false;
		private var acceleration:Number = Constants.player_acceleration.valueOf();
		private var dx_max:Number = Constants.player_dx_max.valueOf();
		private var d2x:Number = 0;
		private var d2y:Number = 0;
		private var hp:int = 100;
		
		private var reloadFramesTotal:uint = Constants.player_reloadFramesTotal.valueOf();
		private var reloadFramesLeft:uint = 0;
		private var shotReady:Boolean = true;
		private var lastLaserColor:uint = 0;
		
		private var shotType:uint = 0;
		
		public function Player()
		{
			super();			
		}
				
		override public function startup(x:Number, y:Number, assetKey:String, collisionType:uint):void
		{
			super.startup(x, y, assetKey, collisionType);
			trace("Player: starting up at (" + x + ", " + y + "), acceleration: " + acceleration + ", dx_max: " + dx_max);
		}
		
		override public function step():void
		{	
			super.step();
			
			if (x <= 0)  	// left boundary
			{
				x = 0;
				dx = Math.max(dx, 0);
			}
			
			if (x + bitmapData.width >= game_2.bitmap.width)	// right boundary
			{
				x = game_2.bitmap.width - bitmapData.width;
				dx = Math.min(dx, 0);
			}
			
			if (y <= 0)	// top boundary
			{
				y = 0;
				dy = Math.max(dy, 0);
			}
			
			if (y + bitmapData.height >= game_2.bitmap.height)	// bottom boundary
			{
				y = game_2.bitmap.height - bitmapData.height;
				dy = Math.min(dy, 0);
			}
			
			d2x = 0;
			d2y = 0;
			
			if (Input.keyPressed(37))	// left
				d2x -= acceleration;
			if (Input.keyPressed(38))	// up
				d2y -= acceleration;
			if (Input.keyPressed(39))	// right
				d2x += acceleration;
			if (Input.keyPressed(40))	// down
				d2y += acceleration;
				
			if (d2x == 0)				// fire the stabilizers! (horizontal)
			{
				if (dx > 0)
					dx = Math.max(0, dx - acceleration);
				else if (dx < 0)
					dx = Math.min(0, dx + acceleration);
			}
			
			if (d2y == 0)				// fire the stabilizers! (vertical)
			{
				if (dy > 0)
					dy = Math.max(0, dy - acceleration);
				else if (dy < 0)
					dy = Math.min(0, dy + acceleration);

			}
			
			if (Math.abs(dx) < dx_max)	// update horizontal velocity					
			{
				if (dx + d2x > dx_max)
					dx = dx_max;
				else if (dx + d2x < -dx_max)
					dx = -dx_max;
				else
					dx += d2x;		
			}
			
			if (Math.abs(dy) < dx_max)	// update vertical velocity
			{
				if (dy + d2y > dx_max)
					dy = dx_max;
				else if (dy + d2y < -dx_max)
					dy = -dx_max;
				else 
					dy += d2y;
			}

			if (reloadFramesLeft == 0)
			{
				shotType = 0;
				if (Input.keyPressed(82) || Input.keyPressed(49))	// R || 1
					shotType += 4; 	
				if (Input.keyPressed(71) || Input.keyPressed(50))	// G || 2
					shotType += 2;
				if (Input.keyPressed(66) || Input.keyPressed(51))	// B || 3
					shotType += 1;
				shoot();
			}
			else (reloadFramesLeft--);			
		}						
				
		private function shoot():void	// [1]
		{
			reloadFramesLeft = reloadFramesTotal;									
			switch(shotType)
			{
				case 7:	// red, green, + blue
					switch(lastLaserColor)
					{
						case 0:
							pew(1);							
							break;
						case 1:
							pew(2);
							break;
						case 2:
							pew(0);
							break;
					}
					break;
				case 6:	// red + green
					switch(lastLaserColor)
					{
						case 0:
							pew(1);							
							break;
						case 1:
							pew(0);
							break;
						case 2:
							pew(0);
							break;
					}
					break;
				case 5:	// red + blue
					switch(lastLaserColor)
					{
						case 0:
							pew(2);							
							break;
						case 1:
							pew(2);
							break;
						case 2:
							pew(0);
							break;
					}
					break;
				case 4:	// red
					pew(0);
					break;
				case 3:	// green + blue
					switch(lastLaserColor)
					{
						case 0:
							pew(1);							
							break;
						case 1:
							pew(2);
							break;
						case 2:
							pew(1);
							break;
					}
					break;
				case 2:	// green
					pew(1);
					break;
				case 1:	// blue
					pew(2);
					break;
			}
		}
		
		private function pew(laserColor:uint):void
		{			
			var laser:Laser = Laser.pool.item;	
			var laserAssetKey:String;
			var laserCollisionType:uint;			
			switch(laserColor)
			{
				case 0:
					laserAssetKey = AssetKeys.RED_LASER;
					laserCollisionType = CollisionTypes.PLAYER_RED_PROJECTILE;
					if(!game_2.mute)
						Assets.red_shot_sound.play();	
					break;
				case 1:
					laserAssetKey = AssetKeys.GREEN_LASER;
					laserCollisionType = CollisionTypes.PLAYER_GREEN_PROJECTILE;
					if(!game_2.mute)
						Assets.green_shot_sound.play();
					break;
				case 2:
					laserAssetKey = AssetKeys.BLUE_LASER;
					laserCollisionType = CollisionTypes.PLAYER_BLUE_PROJECTILE;
					if(!game_2.mute)
						Assets.blue_shot_sound.play();
					break;
			}					
			laser.dx = Constants.laser_dx;
			//laser.dy = Math.random() -0.5; 			
			laser.startup(this.rect.right, this.y + this.bitmapData.height * 0.5, laserAssetKey, laserCollisionType);			
			laser.y -= laser.height * 0.5;
			laser = null;					
			lastLaserColor = laserColor;
		}
		
		override public function collide(other:GameObject):void
		{			
			if(!godMode)
			{
				this.isDead = true;
				super.collide(other);
			}		
		}				
	}
}

/*
[1] shoot() - OK I admit it, there must be a more elegant way to do this.  I wrote it lying in bed at
3 in the morning though, so I just wanted it to get done.
*/