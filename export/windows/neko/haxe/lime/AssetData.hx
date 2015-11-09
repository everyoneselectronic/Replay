package lime;


import lime.utils.Assets;


class AssetData {

	private static var initialized:Bool = false;
	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();	
	
	public static function initialize():Void {
		
		if (!initialized) {
			
			path.set ("assets/bg.csv", "assets/bg.csv");
			type.set ("assets/bg.csv", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/out - Copy.png", "assets/out - Copy.png");
			type.set ("assets/out - Copy.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/out.png", "assets/out.png");
			type.set ("assets/out.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/sheet.png", "assets/sheet.png");
			type.set ("assets/sheet.png", Reflect.field (AssetType, "image".toUpperCase ()));
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
