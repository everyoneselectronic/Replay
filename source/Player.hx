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
	
	/**
	 * This is the player object class.  Most of the comments I would put in here
	 * would be near duplicates of the Enemy class, so if you're confused at all
	 * I'd recommend checking that out for some ideas!
	 */
	public function new(X:Int, Y:Int, ?isReplay:Bool, ?replayData:String)
	{
		super(X, Y);

		_isReplay = isReplay;

		if (_isReplay) {
			_replayData = replayData;
			// trace(_replayData);
			_vcr = new FlxReplayEx();
			// _vcr.create(FlxRandom.globalSeed);
			_vcr.load(replayData);
		}
		
		loadGraphic(AssetPaths.sP1_down__png, false, 80, 104);
		
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

				if (FlxG.keys.anyPressed(["LEFT", "A"]))
				{
					moveLeft();
				}
				else if (FlxG.keys.anyPressed(["RIGHT", "D"]))
				{
					moveRight();
				}

				_aim = facing;

				if (FlxG.keys.anyPressed(["UP", "W"]))
				{
					moveUp();
				}
				else if (FlxG.keys.anyPressed(["DOWN", "S"]))
				{
					moveDown();
				}
				
				// PUNCH
				if (FlxG.keys.justPressed.X)
				{
					punch();
				}

			}
		}
		else
		{
			if (FlxG.keys.anyPressed(["LEFT", "A"]))
			{
				moveLeft();
			}
			else if (FlxG.keys.anyPressed(["RIGHT", "D"]))
			{
				moveRight();
			}

			_aim = facing;

			if (FlxG.keys.anyPressed(["UP", "W"]))
			{
				moveUp();
			}
			else if (FlxG.keys.anyPressed(["DOWN", "S"]))
			{
				moveDown();
			}
			
			// PUNCH
			if (FlxG.keys.justPressed.X)
			{
				punch();
			}
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
			x += OFFSET;
		}
		facing = FlxObject.LEFT;
		acceleration.x -= drag.x;
		
	}
	
	function moveRight():Void
	{
		if (facing == FlxObject.LEFT){
			x -= OFFSET;
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
		loadGraphic(AssetPaths.sP1_punch__png, false, 80, 104);

	}
}