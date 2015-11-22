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
import flixel.group.FlxTypedSpriteGroup;
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
	// Width: 1300 Height: 725
	private var _replaying:Bool = false;
	
	private var _tilemap:FlxTilemap;

	private var _camera:FlxZoomCamera;

	private var _currentPlayers:FlxSpriteGroup;
	private var _recorderPlayers:FlxSpriteGroup;
	private var _TTD:TDD;
	private var _playersCenterPoint:FlxSprite;

	private var _TTDReady:Bool = true;
	private var _TTDcarrying:Bool = false;
	private var _TDDPlayer:Int = 0;

	private var _vcr:FlxReplayEx;

	private var _roundTimer:FlxTimer;
	private var _roundTime:Float = 0;

	private var _startGame = true;

	private var _scores:FlxTypedSpriteGroup<FlxText>;

	private var _cameraTest:FlxSprite;

	private var scorehud:FlxText;
	
	override public function create():Void
	{

		FlxG.mouse.visible = false;

		for (i in 1...250)
		{
			var u = i*1000;
			var l = u-(1000-675);
			for (a in l...u)
			{
				ReplayData.previousPositions.push(a);
			}			 
		}

		_roundTime = Reg.loopTime;

		// var bg = new TiledLevel(AssetPaths.bg__tmx);
		// add(bg.backgroundTiles);

		var bg = new FlxTilemap();
		bg.loadMap(generateTilemap(16,true), AssetPaths.tile__png, 16, 16);
		add(bg);

		_tilemap = new FlxTilemap();
		_tilemap.loadMap(generateTilemap(25,false), AssetPaths.tiles__png, 25, 25, FlxTilemap.AUTO);
		add(_tilemap);

		_tilemap.x -= (_tilemap.width-FlxG.width)/2;
		_tilemap.y -= (_tilemap.height-FlxG.height)/2;

		// w = 41		h = 32
		// w = 	1025		h = 800

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

					var player = new Player(ReplayData.playerStartPositions[i][0][0], ReplayData.playerStartPositions[i][0][1], 0, this, true, i, ReplayData.replays[i]);
					_recorderPlayers.add(player);
					var player = new Player(ReplayData.playerStartPositions[i][1][0], ReplayData.playerStartPositions[i][1][1], 1, this, true, i, ReplayData.replays[i]);
					_recorderPlayers.add(player);
				}
			add(_recorderPlayers);
			_recorderPlayers.alpha = 0.5;
		}

		// 56,60 size
		_TTD = new TDD(0,0);
		_TTD.screenCenter();
		add(_TTD);

		// current players
		_currentPlayers = new FlxSpriteGroup();
			// player 0
			var pos = spawnPlayers(0);
			var player = new Player(pos[0], pos[1], 0, this);
			_currentPlayers.add(player);

			//  player 1
			pos = spawnPlayers(1);
			var player = new Player(pos[0], pos[1], 1, this);
			_currentPlayers.add(player);

		add(_currentPlayers);

		_scores = new FlxTypedSpriteGroup<FlxText>();

			if (Reg.gameMode == 0)
			{
				var f:Float = Math.abs(Reg.scores[0]-Reg.scores[1]);
				var s = Std.int(f);
				var score = new FlxText(-8,-35, null, addZeros(s,2),20);
				_scores.add(score);

				score.alpha = 0.5;

				if (Reg.scores[0] > Reg.scores[1])
				{
					score.color = FlxColor.RED;
				}
				else if (Reg.scores[0] == Reg.scores[1])
				{
					score.color = FlxColor.WHITE;
				}
				else
				{
					score.color = FlxColor.BLUE;
				}
			}
			else{
				var score = new FlxText(0,0, null, Std.string(Reg.scores[0]),30);
				_scores.add(score);

				var score = new FlxText(100,0, null, Std.string(Reg.scores[1]),30);
				_scores.add(score);
			}

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
		_camera.follow(_playersCenterPoint, FlxCamera.STYLE_TOPDOWN, 1);
		FlxG.cameras.add(_camera);

		// _cameraTest = new FlxSprite(0,0);
		// _cameraTest.makeGraphic(400,300,FlxColor.RED);
		// _cameraTest.alpha = 0.3;
		// add(_cameraTest);

		// hud = new HUD();
		// add(hud);

		super.create();
	}
	
	override public function update():Void
	{
		FlxG.collide(_tilemap, _currentPlayers);
		FlxG.collide(_tilemap, _TTD);
		FlxG.overlap(_currentPlayers, checkPlayerPunch);
		FlxG.overlap(_currentPlayers, _TTD, pickUpTTD);

		if (Reg.pastInteraction)
		{
			FlxG.overlap(_currentPlayers, _recorderPlayers, checkPlayerPunch);
		}

		if (Reg.friendlyFire)
		{

		}

		if (_replaying)
		{
			FlxG.collide(_tilemap, _recorderPlayers);
			FlxG.overlap(_recorderPlayers, checkPlayerPunch);
		}

		if (_startGame)
		{
			_vcr.recordFrame();
			updateCamera();
			scorePosition();

			if (FlxG.keys.justPressed.ESCAPE)
			{
				FlxG.resetGame();
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
		Reg.level++;
		_startGame = false;
	}

	private function pickUpTTD(P:Player, TTD:FlxSprite):Void
	{
		if(_TTD.getReady())
		{
			_TTD.pickUpTTD(P.getPlayerNum());
			P.pickUpTTD();

			_TTDcarrying = true;
			_TDDPlayer = P.getPlayerNum();
		}
	}

	private function dropTTD(x:Float,y:Float):Void
	{
		_TTD.reset(x,y);
		_TTD.dropTTD();
		_TTDcarrying = false;
	}

	private function checkPlayerPunch(P0:Player, P1:Player):Void
	{
		var p0Punching:Bool = P0.checkIsPunching();
		var p1Punching:Bool = P1.checkIsPunching();

		var p0TTD:Bool = P0.getCarryingTDD();
		var p1TTD:Bool = P1.getCarryingTDD();

		var p0num:Int = P0.getPlayerNum();
		var p1num:Int = P1.getPlayerNum();

		var canPunch:Bool = false;

		if (Reg.friendlyFire)
		{
			canPunch = true;
		}
		else
		{
			if (p0num != p1num)
			{
				canPunch = true;
			}
		}

		if (canPunch)
		{
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

	public function updateScore(playerNumber:Int):Void
	{
		Reg.scores[playerNumber]++;
		
		if (Reg.gameMode == 0)
		{
			var f:Float = Math.abs(Reg.scores[0]-Reg.scores[1]);
			var s = Std.int(f);
			_scores.members[0].text = addZeros(s,2);
			
			var p:Float = Math.abs(0 - playerNumber);
			var c = Std.int(p);

			if (Reg.scores[0] > Reg.scores[1])
			{
				_scores.members[0].color = FlxColor.RED;
			}
			else if (Reg.scores[0] == Reg.scores[1])
			{
				_scores.members[0].color = FlxColor.WHITE;
			}
			else
			{
				_scores.members[0].color = FlxColor.BLUE;
			}
		}
		else{
			_scores.members[playerNumber].text = addZeros(Reg.scores[playerNumber],2);
		}
		checkScore(playerNumber);
	}

	private function scorePosition():Void
	{
		if (_TTDcarrying)
		{
			_scores.x = _currentPlayers.members[_TDDPlayer].x;
			_scores.y = _currentPlayers.members[_TDDPlayer].y;
		}
		else{
			_scores.x = _TTD.x;
			_scores.y = _TTD.y;
		}
	}

	private function checkScore(playerNumber:Int):Void
	{
		var s:Int = 0;

		if (Reg.gameMode == 0)
		{
			var f:Float = Math.abs(Reg.scores[0]-Reg.scores[1]);
			s = Std.int(f);
			trace("Player: " + playerNumber + " Score: " + s);
	
		}
		else{
			s = Reg.scores[playerNumber];
		}

		if (s == Reg.winScore) 
		{
			gameEnd(playerNumber);
		}
	}

	private function gameEnd(player:Int):Void
	{
		trace("END GAME!!!!! Player " + player + " WINS");
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

	private function spawnPlayers(player:Int):Array<Int>
	{
		var p = Reg.playerSpawnLimtsEx[player];

		var n = FlxRandom.intRanged(p[0],p[1],ReplayData.previousPositions);
		ReplayData.previousPositions.push(n);

		var pX = Math.floor(n/1000);
		var pY = n - (pX*1000);

		var pos:Array<Int> = [pX,pY];

		if (ReplayData.playerStartPositions == null)
		{
			ReplayData.playerStartPositions = new Array();
		}

		if (ReplayData.playerStartPositions[Reg.level] == null)
		{
			ReplayData.playerStartPositions[Reg.level] = new Array();
		}

		ReplayData.playerStartPositions[Reg.level][player] = new Array();

		ReplayData.playerStartPositions[Reg.level][player][0] = pX;
		ReplayData.playerStartPositions[Reg.level][player][1] = pY;

		return pos;
	}

	// addZeros({inputNumber:1234, stringLength:6});
	private function addZeros(inputNumber:Int,stringLength:Int)
	{
	    var ret:String = Std.string(inputNumber);
	    while (ret.length < stringLength) {
	        ret = "0" + ret;
	    }
	    return ret;
	}

	private function generateTilemap(tileSize:Int, allOnes:Bool)
	{
	    // Set up the TILEMAP
		// var tileSize:Int = 25;
		var tileData:String = "";

		var tilesWidth = Math.ceil(FlxG.width/tileSize);
		var tilesHeight = Math.ceil(FlxG.height/tileSize);

		for (r in 0...tilesHeight)
		{
			if (r == 0 || r == tilesHeight-1 || allOnes) // top and bottom row
			{
				for (c in 0...tilesWidth)
				{
					if (c == 0)
					{
						tileData +=	"1,";
					}
					else if (c == tilesWidth-1)
					{
						tileData +=	"1\n";
					}
					else
					{
						tileData +=	"1,";
					}
				}
			}
			else //middle
			{
				for (c in 0...tilesWidth)
				{
					if (c == 0)
					{
						tileData +=	"1,";
					}
					else if (c == tilesWidth-1)
					{
						tileData +=	"1\n";
					}
					else
					{
						tileData +=	"0,";
					}
				}
			}
		}
		return tileData;
	}

}