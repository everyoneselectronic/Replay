package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import flixel.group.FlxTypedGroup;

class MenuState extends FlxState
{
	// gameMode		
	// winScore		
	// loopTime		
	// pastInteraction	
	// friendlyFire

	private var menuNames:Array<String> = ["gameMode", "winScore", "loopTime", "pastInteraction", "friendlyFire", "startGame"];

	private var menuActive:Int = 0;

	private var menuText:FlxTypedGroup<FlxText>;

	private var textGameMode:FlxText;		
	private var textWinScore:FlxText;		
	private var textLoopTime:FlxText;		
	private var textPastInteraction:FlxText;	
	private var textFriendlyFire:FlxText;
	private var textStartGame:FlxText;


	override public function create():Void
	{
		FlxG.mouse.visible = false;

		var textx = 100;
		var texty = 100;

		var fontsize = 30;

		menuText = new FlxTypedGroup<FlxText>(menuNames.length);

		textGameMode = new FlxText(textx+0, texty+0, 0, Std.string(Reg.gameModeName[Reg.gameMode]), fontsize);
		textWinScore = new FlxText(textx+0, texty+50, 0, Std.string(Reg.winScore), fontsize);
		textLoopTime = new FlxText(textx+0, texty+100, 0, Std.string(Reg.loopTime), fontsize);
		textPastInteraction = new FlxText(textx+0, texty+150, 0, Std.string(Reg.pastInteraction), fontsize);
		textFriendlyFire = new FlxText(textx+0, texty+200, 0, Std.string(Reg.friendlyFire), fontsize);

		textStartGame = new FlxText(textx+0, texty+300, 0, "START GAME", fontsize);


		menuText.add(textGameMode);
		menuText.add(textWinScore);
		menuText.add(textLoopTime);
		menuText.add(textPastInteraction);
		menuText.add(textFriendlyFire);
		menuText.add(textStartGame);

		add(menuText);
		menuText.members[menuActive].color = FlxColor.RED;

		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		if (FlxG.keys.justPressed.UP)
		{
			menuNavigation(-1);
		}
		else if (FlxG.keys.justPressed.DOWN)
		{
			menuNavigation(1);
		}

		
		if (menuActive == 1 || menuActive == 2)
		{
			if (FlxG.keys.pressed.LEFT)
			{
				changeValue(-1);
			}
			else if (FlxG.keys.pressed.RIGHT)
			{
				changeValue(1);
			}
		}
		else
		{
			if (FlxG.keys.justPressed.LEFT)
			{
				changeValue(-1);
			}
			else if (FlxG.keys.justPressed.RIGHT)
			{
				changeValue(1);
			}
		}


		if (menuActive == 5)
		{
			if (FlxG.keys.justPressed.ENTER)
			{
				startGame();
			}
		}


		super.update();
	}

	private function menuNavigation(direction:Int):Void
	{
		menuText.members[menuActive].color = FlxColor.WHITE;
		
		menuActive = menuActive + direction;

		if  (menuActive > menuNames.length-1)
		{
			menuActive = 0;
		}
		else if (menuActive < 0)
		{
			menuActive = menuNames.length-1;
		}

		menuText.members[menuActive].color = FlxColor.RED;

	}

	private function changeValue(direction:Int):Void
	{
		// switch case
		switch (menuActive) {

			case 0:
				changeGameMode(direction);

			case 1:
				changeWinScore(direction);

			case 2:
				changeLoopTime(direction);

			case 3:
				changePastInteraction();

			case 4:
				changeFriendlyFire();
		}
	}

	private function changeGameMode(direction:Int):Void
	{
		// loop length of Reg.gameModeName
		Reg.gameMode = Reg.gameMode + direction;

		if  (Reg.gameMode > Reg.gameModeName.length-1)
		{
			Reg.gameMode = 0;
		}
		else if (Reg.gameMode < 0)
		{
			Reg.gameMode = Reg.gameModeName.length-1;
		}

		menuText.members[menuActive].text = Std.string(Reg.gameModeName[Reg.gameMode]);
	}

	private function changeWinScore(direction:Int):Void
	{
		// 50 -1000
		var maxWinScore = 500;
		var minWinScore = 50;

		Reg.winScore = Reg.winScore + direction;

		if  (Reg.winScore > maxWinScore)
		{
			Reg.winScore = maxWinScore;
		}
		else if (Reg.winScore < minWinScore)
		{
			Reg.winScore = minWinScore;
		}

		menuText.members[menuActive].text = Std.string(Reg.winScore);
	}

	private function changeLoopTime(direction:Int):Void
	{
		// 5 sec - 0 sec
		var maxLoopTime = 30;
		var minLoopTime = 5;

		Reg.loopTime = Reg.loopTime + direction;

		if  (Reg.loopTime > maxLoopTime)
		{
			Reg.loopTime = maxLoopTime;
		}
		else if (Reg.loopTime < minLoopTime)
		{
			Reg.loopTime = minLoopTime;
		}
		menuText.members[menuActive].text = Std.string(Reg.loopTime);
		
	}

	private function changePastInteraction():Void
	{
		// true/false
		Reg.pastInteraction = !Reg.pastInteraction;
		menuText.members[menuActive].text = Std.string(Reg.pastInteraction);
	}

	private function changeFriendlyFire():Void
	{
		// true/false
		Reg.friendlyFire = !Reg.friendlyFire;
		menuText.members[menuActive].text = Std.string(Reg.friendlyFire);
	}

	private function startGame():Void
	{
		Reg.scores = [Reg.winScore, Reg.winScore];
		FlxG.switchState(new PlayState());
	}

}