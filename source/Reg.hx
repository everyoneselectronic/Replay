package;

import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<Int> = [1000,1000];

	// public static var score:Int = 1000;

	public static var gameMode:Int = 0;

	public static var gameModeName:Array<String> = ["TugOfWar", "Individual"];

	public static var winScore:Int = 100;

	public static var loopTime:Int = 10;

	public static var pastInteraction:Bool = false;

	public static var friendlyFire:Bool = false;
	
}