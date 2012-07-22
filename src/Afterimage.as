package
{
	public class Afterimage extends GameObject
	{
		public var duration:int = Constants.laser_afterimage_duration.valueOf();
		private var framesLeft:int;
				
		public function Afterimage()
		{
			
		}
		
		
		
		override public function step():void
		{
			// afterimages don't move, so I'm removing the movement update.	
		}
		
		override public function draw():void
		{
			
		}
	}
}