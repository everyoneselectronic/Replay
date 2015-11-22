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

	public static var previousPositions:Array<Int> = [];
	
	public static var playerStartPositions:Array<Array<Array<Int>>>;
	// [ // round
	// 	// [ //player0		1
	// 	// 	[100,200],[100,200]
	// 	// ],
	// 	// [ //player0		1
	// 	// 	[100,200],[100,200]
	// 	// ],
	// ];

	// playerStartPositions[roundInt][playerInt0][xInt0]
	// playerStartPositions[roundInt][playerInt0][yInt0]


}