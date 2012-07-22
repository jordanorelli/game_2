package
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Enemy extends GameObject
	{
		public static var pool:Pool = new Pool(function():Enemy {return new Enemy();});
		public var inPool:Boolean = false;
		private var framesPerShot:uint = Constants.enemy_framesPerShot.valueOf();
		private var framesTillNextShot:uint;
						
		public function Enemy()
		{
			super();
		}
		
		override public function startup(x:Number, y:Number, assetKey:String, collisionType:uint):void
		{
			super.startup(x, y, assetKey, collisionType);
			framesTillNextShot = framesPerShot;
		}
		
		override public function step():void
		{
			super.step();
			framesTillNextShot--;
			if (framesTillNextShot == 0)
			{
				//fire();
				framesTillNextShot = framesPerShot;
			}
		}
		
		private function reflect(laser:GameObject):void
		{
			var newLaser:Laser = Laser.pool.item;
			var newLaserCollisionType:uint;
			switch(laser.collisionType)
			{
				case CollisionTypes.PLAYER_RED_PROJECTILE:
					newLaserCollisionType = CollisionTypes.ENEMY_RED_PROJECTILE;
					break;
				case CollisionTypes.PLAYER_GREEN_PROJECTILE:
					newLaserCollisionType = CollisionTypes.ENEMY_GREEN_PROJECTILE;
					break;
				case CollisionTypes.PLAYER_BLUE_PROJECTILE:
					newLaserCollisionType = CollisionTypes.ENEMY_BLUE_PROJECTILE;
					break;
			}
			newLaser.startup(laser.x, laser.y, laser.assetKey, newLaserCollisionType);
			newLaser.dx = -laser.dx;
		}
		
		private function fire():void
		{
			if (Math.random() > 0.5)
			{
				var laser:GameObject = Laser.pool.item;
				var laserAssetKey:String;
				var laserCollisionType:uint;
				switch(this.assetKey)
				{
					case AssetKeys.RED_SQUARE:
						laser.assetKey = AssetKeys.RED_LASER;
						laser.collisionType = CollisionTypes.ENEMY_RED_PROJECTILE;
						break;
	
					case AssetKeys.GREEN_SQUARE:
						laser.assetKey = AssetKeys.GREEN_LASER;
						laser.collisionType = CollisionTypes.ENEMY_GREEN_PROJECTILE;					
						break;
	
					case AssetKeys.BLUE_SQUARE:
						laser.assetKey = AssetKeys.BLUE_LASER;
						laser.collisionType = CollisionTypes.ENEMY_BLUE_PROJECTILE;					
						break;			
				}
				laser.dx = -Constants.laser_dx;
				laser.startup(this.rect.left, this.y + this.bitmapData.height * 0.5, laserAssetKey, laserCollisionType);
				laser.x -= laser.width;231			
				laser.y -= laser.height * 0.5;
				laser = null;					
			}
		}
		
		override public function collide(other:GameObject):void
		{
			switch(other.collisionType)
			{
				case CollisionTypes.PLAYER:
					this.shutdown();
					//shotTimer.stop();
					//super.collide(other);
					break;
				
				case CollisionTypes.PLAYER_RED_PROJECTILE:
					if (this.collisionType == CollisionTypes.ENEMY_RED)
					{
						this.shutdown();
						//shotTimer.stop();
						//super.collide(other);
					}
					else
					{
						reflect(other);
					}
					break;
				
				case CollisionTypes.PLAYER_GREEN_PROJECTILE:
					if (this.collisionType == CollisionTypes.ENEMY_GREEN)
					{
						this.shutdown();
						//shotTimer.stop();
						//super.collide(other);
					}
					else
					{
						reflect(other);
					}
					break;
				
				case CollisionTypes.PLAYER_BLUE_PROJECTILE:
					if (this.collisionType == CollisionTypes.ENEMY_BLUE)
					{
						this.shutdown();
						//shotTimer.stop();
						//super.collide(other);
					}
					else
					{
						reflect(other);
					}					
					break;
				
				case CollisionTypes.PLAYER_WHITE_PROJECTILE:
					this.shutdown();
					//shotTimer.stop();
					//super.collide(other);
					break;
			}
		}
		
		override public function shutdown():void
		{
			super.shutdown();
			this.inPool = true;
			framesTillNextShot = framesPerShot;
		}
	}
}