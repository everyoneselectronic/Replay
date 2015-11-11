package;

import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class ReplayData
{
	public static var replays:Array<String> = [];
	
	public static var playerStartPositions:Array<Array<Array<Int>>> =
	[
		[[100,200]]
	];

	// playerStartPositions[0][roundInt][xInt0]
	// playerStartPositions[0][roundInt][yInt0]


}