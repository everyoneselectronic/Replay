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

using flixel.util.FlxSpriteUtil;

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
	private var _roundTime:Float = 100.0;

	private var _startGame = true;

	private var _scores:FlxTypedGroup<FlxText>;

	private var _cameraTest:FlxSprite;
	
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
					var player = new Player(100, 200, 0, this, true, i, ReplayData.replays[i]);
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
		_camera.follow(_playersCenterPoint);
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

		// var h = Std.int(distance);
		// var w  = Std.int((4/3) * _cameraTest.height);
		
		// _cameraTest.makeGraphic(w,h);

		// update centerpoint
		var xM = (p0x + p1x)/2;
		var yM = (p0y + p1y)/2;

		// _cameraTest.x = xM - (_cameraTest.width/2);
		// _cameraTest.y = yM - (_cameraTest.height/2);

		_playersCenterPoint.x = xM;// - (_playersCenterPoint.width/2);
		_playersCenterPoint.y = yM;// - (_playersCenterPoint.height/2);

		// update camera zoom
		var z = FlxG.height/distance;

		if (z < 1)
		{
			_camera.zoom = 1;
		}
		else if (z > 6)
		{
			_camera.zoom = 6;
		}
		else
		{
			_camera.zoom = z;
		}

	}


	/**
	 * 
	 * @param	n initial value
	 * @param	min1 the minimum number of the source
	 * @param	max1 the maximum number of the source
	 * @param	min2 the minimum number of the destination
	 * @param	max2 the maximum number of the destination
	 * @return	Float the mapped value
	 */
	private static function map(n:Float, min1:Float, max1:Float, min2:Float, max2:Float):Float
	{
		return lerp(norm(n, min1, max1), min2, max2);
	}

	private static function lerp(norm:Float, min:Float, max:Float):Float
	{
		return (max - min) * norm + min;
	}

	public static function norm(n:Float, min:Float, max:Float):Float
	{
		return (n - min) / (max - min);
	}
}