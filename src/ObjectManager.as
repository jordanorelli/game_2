// Responsible for distributing requests from the root object to the
// gameObjects on the field, distributing the step() and draw() methods,
// and detecting collisions.  As far as I can tell, there's no real
// benefit to using a singleton here because Flash is sandboxed to 
// begin with, the ObjectManager will never be shut down, and I prefer
// writing "static" in my declarations to writing "ObjectManager.Instance"
// when I want to access anything.  Objects are stored in a multidimenional
// array "objectsInPlay".  ObjectsInPlay[x] is an array of objects that
// each have a collisionType of x.
package
{
	import flash.display.BlendMode;
	
	public class ObjectManager
	{
		private static var objectsInPlay:Array;
		private static var objectsToBeAdded:Array;
		private static var objectsToBeRemoved:Array;
		
		public static var player:Player;
		private static var framesBetweenEnemies:uint = Constants.enemy_spawn_rate.valueOf();
		private static var framesTillNextEnemy:uint;
		private static var enemyCount:uint = 0;
		
		
		
		public static function startup():void
		{
			player = new Player();
			objectsInPlay = new Array();
			for (var i:uint = 0; i < CollisionTypes.COUNT; i++)
			{
				objectsInPlay[i] = new Array();
			}
			objectsToBeAdded = new Array();
			objectsToBeRemoved = new Array();
			trace("ObjectManager: player.startup()");
			player.startup(50, 50, AssetKeys.PLAYER, CollisionTypes.PLAYER);
			framesTillNextEnemy = framesBetweenEnemies;
		}	
		
		public static function step():void
		{
			removeOldObjects();
			
			for (var i:uint = 0; i < objectsInPlay.length; i++)
			{
				for (var j:uint = 0; j < objectsInPlay[i].length; j++)
				{
					objectsInPlay[i][j].step();
				}
			}
			
			if (framesTillNextEnemy == 0)
			{
				spawnEnemy();
				enemyCount++;
				framesTillNextEnemy = framesBetweenEnemies;
				
				if (enemyCount % 3 == 0 && framesBetweenEnemies > 1)
					framesBetweenEnemies--;
			}
			else
				framesTillNextEnemy--;
									
			
			addNewObjects();
		}
		
		public static function checkCollisions():void
		{
			for(var i:uint = 0; i < CollisionTypes.COUNT; i++)
			{
				for(var j:uint = i + 1; j < CollisionTypes.COUNT; j++)
				{
					if (!CollisionTypes.typesCollide(i,j))
						continue;		

					for(var k:uint = 0; k < objectsInPlay[i].length; k++)
					{
						for(var l:uint = 0; l < objectsInPlay[j].length; l++)
						{
							if (objectsInPlay[i][k].rect.intersects(objectsInPlay[j][l].rect))
							{
								objectsInPlay[i][k].collide(objectsInPlay[j][l]);
								objectsInPlay[j][l].collide(objectsInPlay[i][k]);
							}
						}	
					}					
				}
			}
		}
		
		
		public static function drawObjects():void
		{
			for(var i:uint = 0; i < objectsInPlay.length; i++)
			{
				for(var j:uint = 0; j < objectsInPlay[i].length; j++)
				{
					objectsInPlay[i][j].draw();
				} 
			}			
		}
		
		public static function addGameObject(gameObject:GameObject):void
		{
			if (!gameObject.inPlay)
			{
				objectsToBeAdded.push(gameObject);				
			}
			else
				trace("rejected request to add  " + gameObject 
				+ " in ObjectManager.addGameObject(gameObject:GameObject) "
				+ "because it's inPlay property is set to true.");
		}	
		
		private static function addNewObjects():void
		{
			var currentObject:GameObject;
			while (objectsToBeAdded.length > 0)
			{
				currentObject = objectsToBeAdded.shift();
				if (!currentObject.inPlay)
				{
					objectsInPlay[currentObject.collisionType].push(currentObject);
					currentObject.inPlay = true;
				}
				else 
					trace("rejected request to add  " + currentObject 
						+ " in ObjectManager.addNewObjects() "
						+ "because its inPlay property is set to true.");
			}
		}		
		
		public static function removeGameObject(gameObject:GameObject):void
		{
			if (gameObject.inPlay)
				objectsToBeRemoved.push(gameObject);
			else
				trace("rejected request to remove " + gameObject 
					+ " in ObjectManager.removeGameObject(gameObject:GameObject) " 
					+ "because its inPlay property is set to false.");  
		}		
		
		private static function removeOldObjects():void
		{
			var currentObject:GameObject;
			var currentIndex:uint;
			while (objectsToBeRemoved.length > 0)
			{				
				currentObject = objectsToBeRemoved.shift();
				currentIndex = objectsInPlay[currentObject.collisionType].indexOf(currentObject);
				if (currentObject.inPlay)
				{
					objectsInPlay[currentObject.collisionType].splice(currentIndex, 1);
					currentObject.inPlay = false;
				}
				else
					trace("rejected request to remove " + currentObject 
						+ " in ObjectManager.removeOldObjects() " 
						+ "because its inPlay property is set to false.");
			}
		}
		
		private static function spawnEnemy():void
		{
			var enemy:Enemy = Enemy.pool.item;
			var enemyAssetKey:String;
			var enemyCollisionType:String;
			switch(Math.floor(Math.random() * 3))
			{
				case 0:
					enemyAssetKey = AssetKeys.RED_SQUARE;
					enemyCollisionType = CollisionTypes.ENEMY_RED;
					break;
				case 1:
					enemyAssetKey = AssetKeys.GREEN_SQUARE;
					enemyCollisionType = CollisionTypes.ENEMY_GREEN;
					break;
				case 2:
					enemyAssetKey = AssetKeys.BLUE_SQUARE; 
					enemyCollisionType = CollisionTypes.ENEMY_BLUE;
					break;								
			}
			enemy.startup(game_2.bitmap.width + Assets.bitmapData[enemyAssetKey].width, Math.random() * game_2.bitmap.height, enemyAssetKey, enemyCollisionType);
			enemy.dx = Constants.enemy_dx;
			
		}
				
		public static function shutdown():void
		{
			for (var i:uint = 0; i < objectsInPlay.length; i++)
			{
				for (var j:uint = 0; j < objectsInPlay[i].length; j++)
				{
					objectsInPlay[i][j].shutdown();
				}
			}
			
			for (i = 0; i < objectsToBeAdded.length; i++)
			{
				objectsToBeAdded[i].shutdown();
			}
			
			for (i = 0; i < objectsToBeRemoved.length; i++)
			{
				objectsToBeRemoved[i].shutdown();
			}				
			framesBetweenEnemies:uint = Constants.enemy_spawn_rate.valueOf();
			enemyCount = 0;
		}
	}		
}