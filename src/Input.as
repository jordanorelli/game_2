/*	

This class is based on Richard Lord's KeyPoll class, available via Google Code:
http://code.google.com/p/bigroom/wiki/KeyPoll 

*/
package
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;

	public class Input
	{
		private static var keyStates:ByteArray;

		public static function startup(stage:Stage):void
		{
			keyStates = new ByteArray();
			for (var i:int = 0; i < 8; ++i)
			{
				keyStates.writeUnsignedInt(0);
			}
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener, false, 0, true);
			stage.addEventListener(Event.ACTIVATE, toggleListener, false, 0, true);
			stage.addEventListener(Event.DEACTIVATE, toggleListener, false, 0, true);			
		}

		public static function keyPressed(keyCode:uint):Boolean
		{			
			return (keyStates[keyCode >>> 3] & (1 << (keyCode & 7))) != 0;
		}
		
		private static function keyDownListener(event:KeyboardEvent):void
		{						
			keyStates[event.keyCode >>> 3] |= 1 << (event.keyCode & 7);
		}
		
		private static function keyUpListener(event:KeyboardEvent):void
		{
			keyStates[event.keyCode >> 3] &= ~(1 << (event.keyCode & 7));
		}
		
		private static function toggleListener(event:Event):void
		{
			for (var i:int = 0; i < 32; ++i)
			{
				keyStates[i] = 0;
			}
		}
	}
}