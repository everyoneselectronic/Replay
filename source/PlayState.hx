package;

import flixel.FlxG;
import flixel.FlxCamera;
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
import flixel.addons.display.FlxZoomCamera;

import flixel.tile.FlxTilemap;

using flixel.util.FlxSpriteUtil;

/*

game options

gameMode		- TugOfWar or IndidualScore.   tog- one score that the players are fighter over, if p0 gets 500, p2 has to negate the score to then start incceasing theirs.
winScore		- score to win, how many button press
loopTime		- how long for round loop to last
pastInteraction	- past can hit future but only oppsoite player
friendlyFire	- if same play past selves can hit each other, plus current self


*/

class PlayState extends FlxState
{
	private var _replaying:Bool = false;
	
	private var _tilemap:FlxTilemap;

	private var _camera:FlxZoomCamera;

	private var _currentPlayers:FlxSpriteGroup;
	private var _recorderPlayers:FlxSpriteGroup;
	private var _TTD:TDD;
	private var _playersCenterPoint:FlxSprite;

	private var _TTDReady:Bool = true;
	private var _TTDcarrying:Bool = false;
	private var _TDDPlayer:Int;

	private var _vcr:FlxReplayEx;

	private var _roundTimer:FlxTimer;
	private var _roundTime:Float = 0;

	private var _startGame = true;

	private var _scores:FlxTypedGroup<FlxText>;

	private var _cameraTest:FlxSprite;
	
	override public function create():Void
	{
		FlxG.mouse.visible = false;

		_roundTime = Reg.loopTime;

		// Set up the TILEMAP
		_tilemap = new FlxTilemap();
		_tilemap.loadMap(Assets.getText("assets/simpleMap.csv"), "assets/tiles.png", 25, 25, FlxTilemap.AUTO);
		add(_tilemap);
		_tilemap.y -= 15;

		// var bg = new FlxTilemap();
		// bg.loadMap(Assets.getText(AssetPaths.test__csv), AssetPaths.tile__png, 16, 16);
		// add(bg);

		// var bg = new TiledLevel(AssetPaths.bg__tmx);
		// add(bg.backgroundTiles);

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

					var player = new Player(ReplayData.playerStartPositions[0][0][0], ReplayData.playerStartPositions[0][0][1], 0, this, true, i, ReplayData.replays[i]);
					_recorderPlayers.add(player);
					var player = new Player(900, 200, 1, this, true, i, ReplayData.replays[i]);
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
			var player = new Player(100, 200, 0, this);
			_currentPlayers.add(player);

			//  player 1
			var player = new Player(900, 200, 1, this);
			_currentPlayers.add(player);

		add(_currentPlayers);

		_scores = new FlxTypedGroup<FlxText>(2);

			var xOffset = 300;
			var yOffset = 30;

			var score = new FlxText(xOffset + 0, yOffset, null, Std.string(Reg.scores[0]),30);
			_scores.add(score);

			var score = new FlxText(xOffset + 300, yOffset, null, Std.string(Reg.scores[1]),30);
			_scores.add(score);

		add(_scores);
		// _scores.screenCenter();
		// _scores.y = 30;

		var xM = (_currentPlayers.members[0].x + _currentPlayers.members[1].x)/2;
		var yM = (_currentPlayers.members[0].y + _currentPlayers.members[1].y)/2;

		_playersCenterPoint = new FlxSprite(xM, yM);
		_playersCenterPoint.makeGraphic(1,1,FlxColor.WHITE);
		_playersCenterPoint.visible = false;
		add(_playersCenterPoint);

		_camera = new FlxZoomCamera(0, 0, FlxG.width, FlxG.height,1);
		_camera.setBounds(0, 0, _tilemap.width, _tilemap.height);
		_camera.follow(_playersCenterPoint, 2);
		FlxG.cameras.add(_camera);

		// _cameraTest = new FlxSprite(0,0);
		// _cameraTest.makeGraphic(400,300,FlxColor.RED);
		// _cameraTest.alpha = 0.3;
		// add(_cameraTest);

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
			updateCamera();
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
			_TTD.pickUpTTD(P.getPlayerNum());

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

	public function updateScore(playerNumer:Int):Void
	{
		Reg.scores[playerNumer]--;
		trace(Reg.scores[playerNumer]);
		_scores.members[playerNumer].text = Std.string(Reg.scores[playerNumer]);
		checkScore(playerNumer);
	}

	private function checkScore(playerNumer:Int):Void
	{
		if (Reg.scores[playerNumer] <= 0) 
		{
			gameEnd();
		}
	}

	private function gameEnd():Void
	{
		trace("END GAME!!!!!");
	}

	public function updateCamera():Void
	{
		var p0x = _currentPlayers.members[0].x + (_currentPlayers.members[0].width/2);
		var p0y = _currentPlayers.members[0].y + (_currentPlayers.members[0].height/2);

		var p1x = _currentPlayers.members[1].x + (_currentPlayers.members[1].width/2);
		var p1y = _currentPlayers.members[1].y + (_currentPlayers.members[1].height/2);

		var p0:FlxPoint = new FlxPoint(p0x, p0y);
		var p1:FlxPoint = new FlxPoint(p1x, p1y);

		var distance = Std.int(p0.distanceTo(p1)+200);

		// update centerpoint
		var xM = (p0x + p1x)/2;
		var yM = (p0y + p1y)/2;

		_playersCenterPoint.x = xM;// - (_playersCenterPoint.width/2);
		_playersCenterPoint.y = yM;// - (_playersCenterPoint.height/2);

		// update camera zoom
		var z = (FlxG.height/distance)*1.2;

		if (z < 1)
		{
			_camera.zoom = 1;
		}
		else
		{
			_camera.zoom = z;
		}
	}

	private function spawnPlayers():Void
	{
		// spawn player locations
		// save locations for can be loaded with recorderd players
		// p0 area xy + wh
		// p1 area xy + wh
	}


}