package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import openfl.Assets;

// import flixel.system.replay.FlxReplay;
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
	private var _player:FlxSprite;

	private var _recorderPlayers:FlxSpriteGroup;

	private var _vcr:FlxReplayEx;

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
		
		Reg.level++;
		trace(Reg.level);

		_vcr = new FlxReplayEx();

		if (!(Reg.level%2 == 0)) {
			_vcr.create(FlxRandom.globalSeed);
			recording = true;
			trace("recording");

			_player = new Player(30, 200);
			add(_player);

		}
		else
		{
			replaying = true;
			_vcr.load(ReplayData.replays[0]);
			trace("playing");
			trace(ReplayData.replays[0]);

			_recorderPlayers = new FlxSpriteGroup();

			for (replay in ReplayData.replays) {
				var player = new Player(30, 200, true, replay);
				_recorderPlayers.add(player);
			}

			add(_recorderPlayers);
		}
		
		super.create();
	}
	
	override public function update():Void
	{
		FlxG.collide(_tilemap, _player);
		FlxG.collide(_tilemap, _recorderPlayers);

		if (_startGame)
		{
			if (recording) {
				_vcr.recordFrame();
			}
			else if (replaying)
			{
				// if (!_vcr.finished)
				// {
				// 	_vcr.playNextFrame();
				// }
			}

		}
		else {
			FlxG.resetState();
		}

		super.update();
	}

	private function restartGame(Timer:FlxTimer):Void
	{
		ReplayData.replays.push(_vcr.save());
		_startGame = false;
	}
}