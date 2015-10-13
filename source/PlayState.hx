package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import openfl.Assets;

import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

import flixel.group.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	private var _replaying:Bool = false;
	
	private var _tilemap:FlxTilemap;

	private var _currentPlayers:FlxSpriteGroup;
	private var _recorderPlayers:FlxSpriteGroup;
	private var _TTD:TDD;

	private var _TTDReady:Bool = true;
	private var _TTDcarrying:Bool = false;
	private var _TDDPlayer:Int;

	private var _vcr:FlxReplayEx;

	private var _roundTimer:FlxTimer;
	private var _roundTime:Float = 5.0;

	private var _startGame = true;

	private var _scores:FlxSpriteGroup;
	
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		
		// Set up the TILEMAP
		_tilemap = new FlxTilemap();
		_tilemap.loadMap(Assets.getText("assets/simpleMap.csv"), "assets/tiles.png", 25, 25, FlxTilemap.AUTO);
		add(_tilemap);
		_tilemap.y -= 15;

		_roundTimer = new FlxTimer(_roundTime, restartGame, 1);
		
		
		trace(Reg.level);

		_vcr = new FlxReplayEx();
		_vcr.create(FlxRandom.globalSeed);

		if (ReplayData.replays.length > 0)
		{
			_replaying = true;
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
		}

		// 56,60 size
		_TTD = new TDD(0,0);
		_TTD.screenCenter();
		add(_TTD);

		// current players
		_currentPlayers = new FlxSpriteGroup();
			// player 0
			var player = new Player(100, 200, 0);
			_currentPlayers.add(player);

			//  player 1
			var player = new Player(900, 200, 1);
			_currentPlayers.add(player);

		add(_currentPlayers);

		_scores = new FlxSpriteGroup(2);

			var score = new FlxText(0, 0, null,"0",30);
			_scores.add(score);

			var score = new FlxText(300, 0, null,"0",30);
			_scores.add(score);

		add(_scores);
		_scores.screenCenter();
		_scores.y = 30;
		
		super.create();
	}
	
	override public function update():Void
	{
		FlxG.collide(_tilemap, _currentPlayers);
		FlxG.overlap(_currentPlayers, checkPlayerPunch);
		FlxG.overlap(_currentPlayers, _TTD, pickUpTTD);

		if (_replaying)
		{
			FlxG.collide(_tilemap, _recorderPlayers);
			FlxG.overlap(_recorderPlayers, checkPlayerPunch);
		}

		if (_startGame)
		{
			_vcr.recordFrame();
		}
		else {
			FlxG.resetState();
		}

		super.update();
	}

	private function restartGame(Timer:FlxTimer):Void
	{
		ReplayData.replays.push(_vcr.save());
		Reg.level++;
		_startGame = false;
	}

	private function pickUpTTD(P:Player, TTD:FlxSprite):Void
	{
		if(_TTD.getReady())
		{
			_TTD.pickUpTTD(P.playerNumber);

			P.pickUpTTD();
		}
	}

	private function dropTTD(x:Float,y:Float):Void
	{
		_TTD.reset(x,y);
		_TTD.dropTTD();
	}

	private function checkPlayerPunch(P0:Player, P1:Player):Void
	{
		var p0Punching:Bool = P0.checkIsPunching();
		var p1Punching:Bool = P1.checkIsPunching();

		var p0TTD:Bool = P0.getCarryingTDD();
		var p1TTD:Bool = P1.getCarryingTDD();

		if (p0Punching)
		{
			if (p1TTD)
			{
				dropTTD(P1.x, P1.y);
			}
			P0.hasPunched();
			P1.hit(P0.facing);
		}

		if (p1Punching)
		{
			if (p0TTD)
			{
				dropTTD(P0.x, P0.y);
			}
			P1.hasPunched();
			P0.hit(P1.facing);
		}
	}
}