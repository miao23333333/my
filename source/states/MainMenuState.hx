package states;

import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;



class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1.0.4'; // This is also used for Discord RPC
	public static var curSelected:Int = 2;
	

	var menuLightGroup:FlxTypedGroup<FlxSprite>;
	var textGroup:FlxTypedGroup<FlxSprite>;
	textGroup = new FlxTypedGroup<FlxSprite>();
	add(textGroup);

	//Centered/Text options
	var optionShit:Array<String> = [
		'achievements',
		'freeplay',
		'story_mode',
		'options',
		'credits'
	];
	var light:Array<String> = [
	    'light0',
	    'light1',
	    'light2',
	    'light3',
	    'light4'
	];
	
	var menuText:Array<String> = [
	    'achievements',
		'freeplay',
		'story_mode',
		'options',
		'credits'
	
	];

    var canDo:Bool = false;
	
	var camFollow:FlxObject;

	static var showOutdatedWarning:Bool = false;
	override function create()
	{
		super.create();

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = 0.25;
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/bg'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		final accept:String = (controls.mobileC) ? "A" : "ACCEPT";
		final reject:String = (controls.mobileC) ? "B" : "BACK";

		menuLightGroup = new FlxTypedGroup<FlxSprite>();
		add(menuLightGroup);

		for (num => option in optionShit)
		{
			var menuLight:FlxSprite = createLight(option, 0, 0);
			
		}

		

		var psychVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		psychVer.scrollFactor.set();
		psychVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(psychVer);
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		fnfVer.scrollFactor.set();
		fnfVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);
		var theModVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "The Mod v0.5", 12);
		theModVer.scrollFactor.set();
		theModVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(theModVer);
		
		var textX:Array<Float> = [40, 77, 490, 911, 1071];
		var textY:Array<Float> = [266, 482, 611, 482, 266]
		//y:266,482,611  x:40,77,490,911,1071
		for (i in 0 ... menuText.length) {
		    var theText = menuText(menuText[i], textX[i], textY[i]);
		    textGroup.add(theText);
		}
		
		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		FlxG.camera.follow(camFollow, null, 0.15);
		canDo = true;
		
		addTouchPad('LEFT_FULL', 'A_B');
	}

	function createLight(name:String, x:Float, y:Float) {
	
	    var menuLight:FlxSprite = new FlxSprite(x, y).loadGraphic(Paths.image(name));
	    menuLight.antialiasing = ClientPrefs.data.antialiasing;
		menuLight.scrollFactor.set(0, 0);
		
		menuLight.updateHitbox();
		menuLight.screenCenter();
		menuLightGroup.add(menuLight);
		menuLight.alpha = 0.8;
		return menuLight;
	    
	
	}
	var selectedSomethin:Bool = false;

	var timeNotMoving:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		if (canDo) {
		    if (controls.UI_LEFT_P)
				changeItem(-1);

			if (controls.UI_RIGHT_P)
				changeItem(1);
		    
		    if (controls.ACCEPT) {
		        intoState();
		        canDo = false;
		    }
		    if (controls.BACK) {
		        canDo = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
				
			}

		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length - 1);
		FlxG.sound.play(Paths.sound('scrollMenu'));
		for (i in 0 ... menuLightGroup.length) {
		    if (i != curSelected) {
		        menuLightGroup[i].alpha = 0.8;
		        continue;
		    }
		    menuLightGroup[i].alpha = 1;
		}
	}
	
	function menuText(text:String, x:Float, y:Float, size:Int) {
	    var mtext:FlxText = new FlxText(x ,y, 0, text, size);
		mtext.font = Paths.font("vcr.ttf");
		mtext.color = FlxColor.BLACK;
		mtext.add();
		return mtext;
	}
	
	function intoState()
	{
	    FlxG.sound.play(Paths.sound('confirmMenu'));
	    if (ClientPrefs.data.flashing)
			
			
	    switch(curSelected) {
	        case 0:
	            FlxFlicker.flicker(menuLightGroup[0], 1, 0.06, false, false, function(flick:FlxFlicker)
				{
				    MusicBeatState.switchState(new AchievementsMenuState());
				});
		    case 1:
	            FlxFlicker.flicker(menuLightGroup[1], 1, 0.06, false, false, function(flick:FlxFlicker)
				{
				    MusicBeatState.switchState(new FreeplayState());
				});
		    case 2:
		        FlxFlicker.flicker(menuLightGroup[2], 1, 0.06, false, false, function(flick:FlxFlicker)
				{
				    MusicBeatState.switchState(new StoryMenuState());
				});
			case 3:
			    FlxFlicker.flicker(menuLightGroup[3], 1, 0.06, false, false, function(flick:FlxFlicker)
				{
				    MusicBeatState.switchState(new OptionsState());
				});
			case 4:
			    FlxFlicker.flicker(menuLightGroup[4], 1, 0.06, false, false, function(flick:FlxFlicker)
				{
				    MusicBeatState.switchState(new CreditsState());
				});
	    }
	
	}
}
