package
{
	public class Constants
	{
		public static const targetFrameRate:uint = 40;
		public static const stepsPerFrame:uint = 3;		 
		
		// f: the step frequency, in steps per second.
		public static const f:uint = targetFrameRate * stepsPerFrame;
		
		// T: the step period, in seconds.
		public static const T:Number = 1.0 / f;
				
		public static const player_dx_max:Number = T * 240;
		public static const player_acceleration:Number = T * 6;
		public static const player_reloadFramesTotal:uint = Math.round(f / 20);				
		
		public static const laser_dx:Number = 700 * T;
		//public static const laser_afterimage_duration:uint = Math.round(f);
		
		public static const enemy_framesPerShot:uint = Math.round(f * 2);
		public static const enemy_spawn_rate:uint = Math.round(f);
		public static const enemy_dx:Number = T * -60; 		
	}
}