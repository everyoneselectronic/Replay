package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxRandom;
import flixel.util.FlxColor;

import flixel.system.replay.FrameRecord;
import flixel.system.replay.CodeValuePair;

class Player extends FlxSprite
{
	static private var PUNCH_OFFSET:Int = 16;
	static private var CARRY_OFFSET:Int = 48;

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

	private var _punchTimer:FlxTimer;
	private var _punchRate:Float = 0.2;
	private var _isPunching:Bool = false;
	private var _canPunch:Bool = true;
	private var _punchDebounce:Bool = true;

	private var _hit:Bool = false;
	private var _hitTimer:FlxTimer;

	private var _carryingTTD:Bool = false;

	private var _runSpeed:Int = 300;

	private var _playState:PlayState;

	/**
	 * This is the player object class.  Most of the comments I would put in here
	 * would be near duplicates of the Enemy class, so if you're confused at all
	 * I'd recommend checking that out for some ideas!
	 */
	public function new(X:Int, Y:Int, playerNum:Int, playState:PlayState, ?isReplay:Bool, ?roundNumber:Int, ?replayData:String)
	{
		super(X, Y);

		_playState = playState;

		_isReplay = isReplay;

		if (_isReplay) {
			_vcr = new FlxReplayEx();
			_replayData = replayData;
			_vcr.load(replayData);
		}
		else
		{
			// _vcr.create(FlxRandom.globalSeed);
		}

		_playerNumber = playerNum;

		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

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

			facing = FlxObject.RIGHT;
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

			facing = FlxObject.LEFT;
		}
		
		loadGraphic(SPRITE_DOWN);
				
		// Basic player physics
		drag.x = _runSpeed * 4;
		drag.y = _runSpeed * 4;
		maxVelocity.set(_runSpeed,_runSpeed);
		
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update():Void
	{
		acceleration.x = 0;
		acceleration.y = 0;

		if (_isReplay) // recorded players
		{
			if (!_vcr.finished)
			{
				var frameRecord:FrameRecord = _vcr.playNextFrame();

				// trace(frameRecord);

				var LEFT:Bool = false;
				var	RIGHT:Bool = false;
				var	UP:Bool = false;
				var	DOWN:Bool = false;
				var PUNCH:Bool = false;

				// punch debounce
				if (frameRecord == null)
				{
					_punchDebounce = true;
				}

				if (frameRecord != null)
				{
					if (frameRecord.keys == null)
					{
						_punchDebounce = true;
					}
				}

				if (frameRecord != null)
				{
					if (frameRecord.keys != null)
					{
						var p:Bool = true;

						for (k in frameRecord.keys)
						{
							if (k.code == FlxG.keys.getKeyCode(_PUNCH))
							{
								p = false;
							}
						}
						if (p)
						{
							_punchDebounce = true;
						}
					}
				}


				if (frameRecord != null)
				{
					if (frameRecord.keys != null)
					{
						for (k in frameRecord.keys)
						{
							if (k.code == FlxG.keys.getKeyCode(_LEFT))
							{
								LEFT = true;
							}
							if (k.code == FlxG.keys.getKeyCode(_RIGHT))
							{
								RIGHT = true;
							}
							if (k.code == FlxG.keys.getKeyCode(_UP))
							{
								UP = true;
							}
							if (k.code == FlxG.keys.getKeyCode(_DOWN))
							{
								DOWN = true;
							}
							if (k.code == FlxG.keys.getKeyCode(_PUNCH))
							{
								PUNCH = true;
							}
						}
					}
				}

				if (LEFT)
				{
					moveLeft();
				}
				else if (RIGHT)
				{
					moveRight();
				}

				_aim = facing;

				if (UP)
				{
					moveUp();
				}
				else if (DOWN)
				{
					moveDown();
				}
				
				// PUNCH
				if (PUNCH && _punchDebounce)
				{
					_punchDebounce = false;
					// punch();
					actionKey();
				}
			}
		}
		else // current players
		{

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
			if (FlxG.keys.anyJustPressed([_PUNCH]))
			{
				actionKey();
				// punch();
			}

		}
		
        super.update();
	}
	
	function moveLeft():Void
	{
		if (_isPunching)
		{
			if (facing == FlxObject.RIGHT){
				x -= PUNCH_OFFSET;
			}
		}

		if (!_carryingTTD)
		{
			facing = FlxObject.LEFT;
		}

		acceleration.x -= drag.x;
	}
	
	function moveRight():Void
	{
		if (_isPunching)
		{
			if (facing == FlxObject.LEFT){
				x += PUNCH_OFFSET;
			}
		}

		if (!_carryingTTD)
		{
			facing = FlxObject.RIGHT;
		}

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

	function actionKey():Void
	{	
		if (_carryingTTD)
		{
			pressTTD();
		}
		else if (_canPunch)
		{
			punch();
		}
	}

	function pressTTD():Void
	{
		_playState.updateScore(_playerNumber);
	}

	function punch():Void
	{	
		if (_canPunch)
		{
			// trace("punch");
			_isPunching = true;
			_canPunch = false;

			_punchTimer = new FlxTimer(_punchRate, resetPunch, 1);

			if (facing == FlxObject.LEFT)
			{
					x -= PUNCH_OFFSET;
			}

			loadGraphic(SPRITE_PUNCH);
			// FlxG.sound.play("Punch");
		}
	}

	function resetPunch(Timer:FlxTimer):Void
	{
		_isPunching = false;
		_canPunch = true;

		if (facing == FlxObject.LEFT)
		{
				x += PUNCH_OFFSET;
		}

		loadGraphic(SPRITE_DOWN);
	}

	public function hasPunched():Void
	{
		_isPunching = false;
	}

	public function pickUpTTD():Void
	{
		// can pucnch timer if running
		if (_punchTimer != null)
		{
			if (_punchTimer.active)
			{
				_punchTimer.cancel();
			}
		}

		_carryingTTD = true;
		_isPunching = false;
		_canPunch = false;

		y -= CARRY_OFFSET;

		loadGraphic(SPRITE_CARRY);
	}

	function dropTTD():Void
	{
		// reset
		_carryingTTD = false;
		_isPunching = false;
		_canPunch = true;

		y += CARRY_OFFSET;
		loadGraphic(SPRITE_DOWN);
	}

	public function getCarryingTDD():Bool
	{
		return _carryingTTD;
	}

	public function checkIsPunching():Bool
	{
		return _isPunching;
	}

	public function hit(direction:Int):Void
	{
		_hit = true;

		if (direction == FlxObject.RIGHT)
		{
			maxVelocity.x = _runSpeed*10;
			velocity.x = maxVelocity.x;
			maxVelocity.x = _runSpeed;
		}
		else
		{
			maxVelocity.x = _runSpeed*10;
			velocity.x = -maxVelocity.x;
			maxVelocity.x = _runSpeed;
		}

		if (_carryingTTD)
		{
			dropTTD();
		}
		
		// FlxG.sound.play("Hurt");
	}

	public function getHit():Bool
	{
		return _hit;
	}

	public function getPlayerNum():Int
	{
		return _playerNumber;
	}
}