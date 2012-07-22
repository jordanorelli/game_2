package
{
	public final class CollisionTypes
	{
		public static const NONE:uint = 0;
		
		public static const PLAYER:uint = 1;
		
		public static const ENEMY_RED:uint = 2;
		public static const ENEMY_GREEN:uint = 3;
		public static const ENEMY_BLUE:uint = 4;
		public static const ENEMY_WHITE:uint = 5;

		public static const PLAYER_RED_PROJECTILE:uint = 6;
		public static const PLAYER_GREEN_PROJECTILE:uint = 7;
		public static const PLAYER_BLUE_PROJECTILE:uint = 8;
		public static const PLAYER_WHITE_PROJECTILE:uint = 9;		
		
		public static const ENEMY_RED_PROJECTILE:uint = 10;
		public static const ENEMY_GREEN_PROJECTILE:uint = 11;
		public static const ENEMY_BLUE_PROJECTILE:uint = 12;
		
		public static const COUNT:uint = 13;
		
		private static var collisionMap:Array = new Array();
		
		public static function initCollisionMap():void
		{
			for (var i:uint = 0; i < CollisionTypes.COUNT; i++)
			{
				collisionMap[i] = new Array();
			}
			
			makeTypesCollide(CollisionTypes.ENEMY_RED, CollisionTypes.PLAYER);
			makeTypesCollide(CollisionTypes.ENEMY_RED, CollisionTypes.PLAYER_RED_PROJECTILE);
			makeTypesCollide(CollisionTypes.ENEMY_RED, CollisionTypes.PLAYER_GREEN_PROJECTILE);			
			makeTypesCollide(CollisionTypes.ENEMY_RED, CollisionTypes.PLAYER_BLUE_PROJECTILE);
			
			makeTypesCollide(CollisionTypes.ENEMY_GREEN, CollisionTypes.PLAYER);			
			makeTypesCollide(CollisionTypes.ENEMY_GREEN, CollisionTypes.PLAYER_RED_PROJECTILE);
			makeTypesCollide(CollisionTypes.ENEMY_GREEN, CollisionTypes.PLAYER_GREEN_PROJECTILE);			
			makeTypesCollide(CollisionTypes.ENEMY_GREEN, CollisionTypes.PLAYER_BLUE_PROJECTILE);
			
			makeTypesCollide(CollisionTypes.ENEMY_BLUE, CollisionTypes.PLAYER);			
			makeTypesCollide(CollisionTypes.ENEMY_BLUE, CollisionTypes.PLAYER_RED_PROJECTILE);
			makeTypesCollide(CollisionTypes.ENEMY_BLUE, CollisionTypes.PLAYER_GREEN_PROJECTILE);			
			makeTypesCollide(CollisionTypes.ENEMY_BLUE, CollisionTypes.PLAYER_BLUE_PROJECTILE);
			
			makeTypesCollide(CollisionTypes.PLAYER, CollisionTypes.ENEMY_RED_PROJECTILE);
			makeTypesCollide(CollisionTypes.PLAYER, CollisionTypes.ENEMY_GREEN_PROJECTILE);
			makeTypesCollide(CollisionTypes.PLAYER, CollisionTypes.ENEMY_BLUE_PROJECTILE);
		}
		
		private static function makeTypesCollide(collisionTypeOne:uint, collisionTypeTwo:uint):void
		{			
			collisionMap[collisionTypeOne].push(collisionTypeTwo);
			collisionMap[collisionTypeTwo].push(collisionTypeOne);
		}
		
		public static function typesCollide(collisionTypeOne:uint, collisionTypeTwo:uint):Boolean
		{
			return collisionMap[collisionTypeOne].indexOf(collisionTypeTwo) != -1;
		}				
	}
}