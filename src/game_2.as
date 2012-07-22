package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import com.adobe.viewsource.ViewSource;

	public class game_2 extends Sprite
	{					
		public static var bitmap:Bitmap = new Bitmap();
		public static var afterimageBitmap:Bitmap = new Bitmap();
		public static var gameBounds:Rectangle = new Rectangle();
		public static var mute:Boolean = true;
						
		private var stepsThisFrame:uint;		
		private var _gameState:uint;
		private var txtPlay:TextField;
		private var txtByJordan:TextField;		
		private var txtYouDied:TextField;
		private var clearScreen:BitmapData = new BitmapData(640, 480, true, 0xFF000000);
		//private var clearAfterimage:BitmapData = new BitmapData(640, 480, true, 0x00000000);
		//private var afterimageFilter:BitmapFilter = new BlurFilter(4, 4, 3);		
		
		// debug helpers
		public static const debugMode:Boolean = true;		
		private var txtFps:TextField;		
		private var currentFrameTime:int;
		private var lastFrameTime:int;
				
		public function game_2()
		{
			ViewSource.addMenuItem(this, "srcview/index.html")
			//trace(Constants.player_acceleration);
			bitmap.blendMode = flash.display.BlendMode.NORMAL;			
			bitmap.bitmapData = clearScreen.clone();
			//afterimageBitmap.bitmapData = clearAfterimage.clone();
			
			gameBounds = clearScreen.rect.clone();			
			gameBounds.inflate(gameBounds.width * 0.1, gameBounds.height * 0.1);
			stage.frameRate = Constants.targetFrameRate;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addChild(bitmap);						
			//stage.addChild(afterimageBitmap);
			stage.mouseChildren = false;
			writeTextFields();												
			
			gameState = GameStates.TITLE_SCREEN;
			Assets.startup();
			Input.startup(stage);	
			CollisionTypes.initCollisionMap();
			//ObjectManager.startup();																								
		}
		
		private function click(event:MouseEvent):void
		{	
			trace("click!");					
			if (debugMode)
				lastStepTime = getTimer();
			
			if (gameState != GameStates.IN_GAME)
				gameState = GameStates.IN_GAME;									
		}		
				
		private function set gameState(value:uint):void
		{
			_gameState = value;
			switch(value)
			{
				case GameStates.TITLE_SCREEN:
					txtPlay.visible = true;
					txtByJordan.visible = true;
					removeEventListener(Event.ENTER_FRAME, step);
					stage.addEventListener(MouseEvent.CLICK, click, false, 0, true);					
					break;
				
				case GameStates.IN_GAME:
					txtPlay.visible = false;
					txtByJordan.visible = false;
					txtYouDied.visible = false;
					ObjectManager.startup();
					addEventListener(Event.ENTER_FRAME, step);
					stage.removeEventListener(MouseEvent.CLICK, click);
					break;
					
				case GameStates.PLAYER_DEAD:
					txtYouDied.visible = true;
					removeEventListener(Event.ENTER_FRAME, step);
					stage.addEventListener(MouseEvent.CLICK, click, false, 0, true);
					break;
			}
		}
		
		private function get gameState():uint
		{
			return _gameState;
		}
		
		private function step(event:Event):void
		{
			stepsThisFrame = 0;
			while (stepsThisFrame < Constants.stepsPerFrame)
			{
				ObjectManager.step();
				ObjectManager.checkCollisions();
				if (ObjectManager.player.isDead)
				{
					playerDied();
					return;
				}
				stepsThisFrame++;
			}
			
			bitmap.bitmapData.lock();
			//afterimageBitmap.bitmapData.lock();
			bitmap.bitmapData.draw(clearScreen, null, null, flash.display.BlendMode.NORMAL, null, false);
			//bitmap.bitmapData.copyPixels(clearScreen, clearScreen.rect, new Point());
			//afterimageBitmap.bitmapData.applyFilter(afterimageBitmap.bitmapData, afterimageBitmap.bitmapData.rect, new Point(), afterimageFilter);			
			ObjectManager.drawObjects();
			//afterimageBitmap.bitmapData.unlock();
			bitmap.bitmapData.unlock();						
		}
		
		private function playerDied():void
		{
			gameState = GameStates.PLAYER_DEAD;
		}				

		
		private function writeTextFields():void
		{
			txtPlay = new TextField();
			txtPlay.defaultTextFormat = new TextFormat("Verdana", 22, 0x00ff00, null, null, null, null, null, "center");
			txtPlay.autoSize = TextFieldAutoSize.CENTER;	
			txtPlay.text = "arrows to move.  \nr,g,b or 1,2,3 to shoot red, green, and blue lasers.\nclick anywhere to begin.";									
			txtPlay.x = clearScreen.width / 2 - txtPlay.width / 2;
			txtPlay.y = clearScreen.height / 2 - txtPlay.height / 2;
			txtPlay.visible = false;
			stage.addChild(txtPlay);
			
			txtByJordan = new TextField();
			txtByJordan.defaultTextFormat = new TextFormat("Verdana", 18, 0x00ff00, null, null, null, null, null, "center");
			txtByJordan.autoSize = TextFieldAutoSize.CENTER;
			txtByJordan.text = "the first game by Jordan Orelli. \nLast Update: 06-15-09 \norelli.j@neu.edu ";			
			txtByJordan.x = clearScreen.width / 2 - txtByJordan.width / 2;
			txtByJordan.y = clearScreen.height * 0.8 - txtByJordan.height / 2;
			txtByJordan.visible = false;			
			stage.addChild(txtByJordan);
			
			txtYouDied = new TextField();
			txtYouDied.defaultTextFormat = new TextFormat("Verdana", 30, 0x00ff00);
			txtYouDied.autoSize = TextFieldAutoSize.CENTER;
			txtYouDied.text = "you died.  Click to play again.";			
			txtYouDied.x = clearScreen.width / 2 - txtYouDied.width / 2;
			txtYouDied.y = clearScreen.height / 2 - txtYouDied.height /2;
			txtYouDied.visible = false;
			stage.addChild(txtYouDied);
			
			if (debugMode)
			{
				txtFps = new TextField();
				txtFps.defaultTextFormat = new TextFormat("Verdana", 10, 0xff0000);
				txtFps.autoSize = TextFieldAutoSize.CENTER;
				txtFps.x = 10;
				txtFps.y = 2;
				stage.addChild(txtFps);
				
				function updateRenderFps(event:Event):void
				{
					currentFrameTime = getTimer();
					txtFps.text = Math.round(1000.0 / (currentFrameTime - lastFrameTime)).toString();
					lastFrameTime = currentFrameTime;					
				}
				
				lastFrameTime = getTimer();				
				stage.addEventListener(Event.ENTER_FRAME, updateRenderFps);
				
				txtStepFps = new TextField();
				txtStepFps.defaultTextFormat = new TextFormat("Verdana", 10, 0x00ff00);
				txtStepFps.autoSize = TextFieldAutoSize.CENTER;
				txtStepFps.x = txtFps.x;
				txtStepFps.y = txtFps.y + 12;
				stage.addChild(txtStepFps);
			}			
		}						
	}
}
