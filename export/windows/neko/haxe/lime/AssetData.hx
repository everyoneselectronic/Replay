package lime;


import lime.utils.Assets;


class AssetData {

	private static var initialized:Bool = false;
	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();	
	
	public static function initialize():Void {
		
		if (!initialized) {
			
			path.set ("assets/all - Copy.png", "assets/all - Copy.png");
			type.set ("assets/all - Copy.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/all.png", "assets/all.png");
			type.set ("assets/all.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/audio/drawKnife1.ogg", "assets/audio/drawKnife1.ogg");
			type.set ("assets/audio/drawKnife1.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/audio/drawKnife2.ogg", "assets/audio/drawKnife2.ogg");
			type.set ("assets/audio/drawKnife2.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/audio/footstep08.ogg", "assets/audio/footstep08.ogg");
			type.set ("assets/audio/footstep08.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/audio/music.ogg", "assets/audio/music.ogg");
			type.set ("assets/audio/music.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/bg.csv", "assets/bg.csv");
			type.set ("assets/bg.csv", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/cave.png", "assets/cave.png");
			type.set ("assets/cave.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/indoor.png", "assets/indoor.png");
			type.set ("assets/indoor.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/outside.png", "assets/outside.png");
			type.set ("assets/outside.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/simpleMap.csv", "assets/simpleMap.csv");
			type.set ("assets/simpleMap.csv", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/sprites_small/sP1_carry0.png", "assets/sprites_small/sP1_carry0.png");
			type.set ("assets/sprites_small/sP1_carry0.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/sprites_small/sP1_carry1.png", "assets/sprites_small/sP1_carry1.png");
			type.set ("assets/sprites_small/sP1_carry1.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/sprites_small/sP1_down.png", "assets/sprites_small/sP1_down.png");
			type.set ("assets/sprites_small/sP1_down.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/sprites_small/sP1_punch.png", "assets/sprites_small/sP1_punch.png");
			type.set ("assets/sprites_small/sP1_punch.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/sprites_small/sP2_carry0.png", "assets/sprites_small/sP2_carry0.png");
			type.set ("assets/sprites_small/sP2_carry0.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/sprites_small/sP2_carry1.png", "assets/sprites_small/sP2_carry1.png");
			type.set ("assets/sprites_small/sP2_carry1.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/sprites_small/sP2_down.png", "assets/sprites_small/sP2_down.png");
			type.set ("assets/sprites_small/sP2_down.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/sprites_small/sP2_punch.png", "assets/sprites_small/sP2_punch.png");
			type.set ("assets/sprites_small/sP2_punch.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/sprites_small/ttd.png", "assets/sprites_small/ttd.png");
			type.set ("assets/sprites_small/ttd.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/test.csv", "assets/test.csv");
			type.set ("assets/test.csv", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/tile.png", "assets/tile.png");
			type.set ("assets/tile.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/tiles.png", "assets/tiles.png");
			type.set ("assets/tiles.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/sounds/beep.ogg", "assets/sounds/beep.ogg");
			type.set ("assets/sounds/beep.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/flixel.ogg", "assets/sounds/flixel.ogg");
			type.set ("assets/sounds/flixel.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/fonts/nokiafc22.ttf", "assets/fonts/nokiafc22.ttf");
			type.set ("assets/fonts/nokiafc22.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			path.set ("assets/fonts/arial.ttf", "assets/fonts/arial.ttf");
			type.set ("assets/fonts/arial.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			
			
			initialized = true;
			
		} //!initialized
		
	} //initialize
	
	
} //AssetData
