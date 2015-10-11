package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxRandom;

class Player extends FlxSprite
{
	static private var OFFSET:Int = 16;

	private var _aim:Int;

	private var _replayData:String;
	private var _isReplay:Bool = false;
	private var _vcr:FlxReplayEx;

	private var _playerNumber:Int;

	private var _UP:String;
	private var _DOWN:String;
	private var _LEFT:String;
	private var _RIGHT:String;
	private var _PUNCH:String;

	private var SPRITE_DOWN:String;
	private var SPRITE_PUNCH:String;
	private var SPRITE_CARRY:String;
	private var SPRITE_UP:String;

	private var punchTimer:FlxTimer;
	private var isPunching:Bool = false;
	private var canPunch:Bool = true;

	/**
	 * This is the player object class.  Most of the comments I would put in here
	 * would be near duplicates of the Enemy class, so if you're confused at all
	 * I'd recommend checking that out for some ideas!
	 */
	public function new(X:Int, Y:Int, playerNumber:Int, ?isReplay:Bool, ?roundNumber:Int, ?replayData:String)
	{
		super(X, Y);

		_isReplay = isReplay;

		if (_isReplay) {
			_replayData = replayData;
			_vcr = new FlxReplayEx();
			_vcr.load(replayData);
		}

		_playerNumber = playerNumber;

		if (_playerNumber == 0)
		{
			_UP = "W";
			_DOWN = "S";
			_LEFT = "A";
			_RIGHT = "D";
			_PUNCH = "G";

			SPRITE_DOWN = AssetPaths.sP1_down__png;
			SPRITE_PUNCH = AssetPaths.sP1_punch__png;
			SPRITE_CARRY = AssetPaths.sP1_carry0__png;
			SPRITE_UP = AssetPaths.sP1_carry1__png;
		}
		else
		{
			_UP = "UP";
			_DOWN = "DOWN";
			_LEFT = "LEFT";
			_RIGHT = "RIGHT";
			_PUNCH = "L";

			SPRITE_DOWN = AssetPaths.sP2_down__png;
			SPRITE_PUNCH = AssetPaths.sP2_punch__png;
			SPRITE_CARRY = AssetPaths.sP2_carry0__png;
			SPRITE_UP = AssetPaths.sP2_carry1__png;
		}
		
		loadGraphic(SPRITE_DOWN, false, 80, 104);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		// Bounding box tweaks
		width = 80;
		height = 104;
		// offset.set(1, 1);
		
		// Basic player physics
		var runSpeed:Int = 300;
		drag.x = runSpeed * 4;
		drag.y = runSpeed * 4;
		// acceleration.y = 420;
		maxVelocity.set(runSpeed,runSpeed);
		
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update():Void
	{
		acceleration.x = 0;
		acceleration.y = 0;

		if (_isReplay)
		{
			if (!_vcr.finished) {
				_vcr.playNextFrame();
			}
		}

		if (FlxG.keys.anyPressed([_LEFT]))
		{
			moveLeft();
		}
		else if (FlxG.keys.anyPressed([_RIGHT]))
		{
			moveRight();
		}

		_aim = facing;

		if (FlxG.keys.anyPressed([_UP]))
		{
			moveUp();
		}
		else if (FlxG.keys.anyPressed([_DOWN]))
		{
			moveDown();
		}
		
		// PUNCH
		if (FlxG.keys.anyPressed([_PUNCH]))
		{
			punch();
		}
		
        super.update();
	}
	
	override public function hurt(Damage:Float):Void
	{
		Damage = 0;
		
		// FlxG.sound.play("Hurt");
		
		if (velocity.x > 0)
		{
			velocity.x = -maxVelocity.x;
		}
		else
		{
			velocity.x = maxVelocity.x;
		}
		
		super.hurt(Damage);
	}
	
	function moveLeft():Void
	{
		if (facing == FlxObject.RIGHT){
			x -= OFFSET;
		}
		facing = FlxObject.LEFT;
		acceleration.x -= drag.x;
		
	}
	
	function moveRight():Void
	{
		if (facing == FlxObject.LEFT){
			x += OFFSET;
		}
		facing = FlxObject.RIGHT;
		acceleration.x += drag.x;
		
	}
	
	function moveUp():Void
	{
		acceleration.y -= drag.y;
	}
	
	function moveDown():Void
	{
		acceleration.y += drag.y;
	}
	
	function punch():Void
	{
		// FlxG.sound.play("Punch");
		loadGraphic(SPRITE_PUNCH, false, 80, 104);

	}
}