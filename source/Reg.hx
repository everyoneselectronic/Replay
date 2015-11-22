package;

import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	public static var playerSpawnLimtsEx:Array<Array<Int>> = [[5050,250675],[1000050,1250675]];

	public static var playerSpawnLimtsCo:Array<Array<Int>> = [[50,50,250,675],[1000,50,1250,675]];

	public static var level:Int = 0;

	public static var scores:Array<Int> = [0,0];

	public static var gameMode:Int = 0;

	public static var gameModeName:Array<String> = ["TugOfWar", "Individual"];

	public static var winScore:Int = 100;

	public static var loopTime:Int = 10;

	public static var pastInteraction:Bool = true;

	public static var friendlyFire:Bool = false;
	
}