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

class TDD extends FlxSprite
{
	
	private var _ready:Bool = true;
	private var _carried:Bool = false;
	private var _player:Int;

	private var _throwSpeed:Int = 600;

	/**
	 * This is the player object class.  Most of the comments I would put in here
	 * would be near duplicates of the Enemy class, so if you're confused at all
	 * I'd recommend checking that out for some ideas!
	 */
	public function new(X:Int, Y:Int)
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.ttd__png);
				
		// Basic player physics
		drag.x = _throwSpeed * 2;
		drag.y = _throwSpeed * 2;
		maxVelocity.set(_throwSpeed,_throwSpeed);
		
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update():Void
	{
		acceleration.x = 0;
		acceleration.y = 0;
		
        super.update();
	}
	
	public function pickUpTTD(playerNumber:Int):Void
	{
		if(_ready)
		{
			_carried = true;
			_ready = false;
			_player = playerNumber;

			kill();
		}
	}

	public function dropTTD():Void
	{
		_carried = false;
		_player = null;

		velocity.x = maxVelocity.x;
		velocity.y = maxVelocity.y;

		new FlxTimer(1.0, function(_) {_ready = true;}, 1);
	}

	public function getReady():Bool
	{
		return _ready;
	}

	public function getCarried():Bool
	{
		return _carried;
	}

	public function getPlayer():Int
	{
		return _player;
	}

	public function setReady(ready:Bool):Void
	{
		_ready = ready;
	}

	public function setCarried(carried:Bool):Void
	{
		_carried = carried;
	}

	public function setPlayer(player:Int):Void
	{
		_player = player;
	}

}