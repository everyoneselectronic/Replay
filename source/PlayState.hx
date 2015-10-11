package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import openfl.Assets;

import flixel.system.replay.FlxReplay;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

import flixel.group.FlxSpriteGroup;

class PlayState extends FlxState
{
	/**
	 * We use these to tell which mode we are at, recording or replaying
	 */
	private var recording:Bool = false;
	private var replaying:Bool = false;
	
	/**
	 * Some intructions
	 */
	private var _hintText:FlxText;
	/**
	 * Just a simple tilemap
	 */
	private var _tilemap:FlxTilemap;
	/**
	 * The blue block player controls
	 */

	private var _currentPlayers:FlxSpriteGroup;
	private var _recorderPlayers:FlxSpriteGroup;

	private var _vcr:FlxReplay;

	private var _roundTimer:FlxTimer;
	private var _roundTime:Float = 5.0;

	private var _startGame = true;
	
	override public function create():Void
	{
		
		// Set up the TILEMAP
		_tilemap = new FlxTilemap();
		_tilemap.loadMap(Assets.getText("assets/simpleMap.csv"), "assets/tiles.png", 25, 25, FlxTilemap.AUTO);
		add(_tilemap);
		_tilemap.y -= 15;

		_roundTimer = new FlxTimer(_roundTime, restartGame, 1);
		
		
		trace(Reg.level);

		// _vcr = new FlxReplay();
		// _vcr.create(FlxRandom.globalSeed);

		// current players
		_currentPlayers = new FlxSpriteGroup();
			// player 0
			var player = new Player(100, 200, 0);
			_currentPlayers.add(player);

			//  player 1
			var player = new Player(900, 200, 1);
			_currentPlayers.add(player);

		add(_currentPlayers);
		trace("C- " + _currentPlayers.members.length);

		if (ReplayData.replays.length > 0)
		{
			// _vcr.load(ReplayData.replays[0]);
			// trace("playing");
			// trace(ReplayData.replays[0]);

			// add recored players
			_recorderPlayers = new FlxSpriteGroup();
				for (i in 0...ReplayData.replays.length)
				{
					var player = new Player(100, 200, 0, true, i, ReplayData.replays[i]);
					_recorderPlayers.add(player);
					var player = new Player(900, 200, 1, true, i, ReplayData.replays[i]);
					_recorderPlayers.add(player);
				}
			add(_recorderPlayers);
			trace("R- " + _recorderPlayers.members.length);
		}
		
		super.create();
	}
	
	override public function update():Void
	{
		FlxG.collide(_tilemap, _currentPlayers);
		FlxG.collide(_tilemap, _recorderPlayers);

		if (_startGame)
		{
			// _vcr.recordFrame();
		}
		else {
			FlxG.resetState();
		}

		super.update();
	}

	private function restartGame(Timer:FlxTimer):Void
	{
		// ReplayData.replays.push(_vcr.save());
		Reg.level++;
		_startGame = false;
	}
}