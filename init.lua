-- all functions below are optional and can be left out

--[[

function OnModPreInit()
	print("Mod - OnModPreInit()") -- First this is called for all mods
end

function OnModInit()
	print("Mod - OnModInit()") -- After that this is called for all mods
end

function OnModPostInit()
	print("Mod - OnModPostInit()") -- Then this is called for all mods
end

function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	GamePrint( "OnPlayerSpawned() - Player entity id: " .. tostring(player_entity) )
end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.
	GamePrint( "OnWorldInitialized() " .. tostring(GameGetFrameNum()) )
end

function OnWorldPreUpdate() -- This is called every time the game is about to start updating the world
	GamePrint( "Pre-update hook " .. tostring(GameGetFrameNum()) )
end

function OnWorldPostUpdate() -- This is called every time the game has finished updating the world
	GamePrint( "Post-update hook " .. tostring(GameGetFrameNum()) )
end

]]--

function OnMagicNumbersAndWorldSeedInitialized() -- this is the last point where the Mod* API is available. after this materials.xml will be loaded.
	local x = ProceduralRandom(0,0)
	print( "===================================== random " .. tostring(x) )
end


if ModIsEnabled("raksa") then
	if --[[ ModSettingGet("config_plug.Conjurer_AoD") == true and ]] ModIsEnabled("anvil_of_destiny") then
		ModLuaFileAppend(
			"mods/raksa/files/scripts/lists/material_categories.lua",
			"mods/config_plus/files/conjurer_plus/anvil_of_destiny/materials_AoD.lua"
		  )
		ModLuaFileAppend(
			"mods/raksa/files/scripts/lists/entity_categories.lua",
			"mods/config_plus/files/conjurer_plus/anvil_of_destiny/entities_AoD.lua"
		  )
	end
end

-- This code runs when all mods' filesystems are registered
--ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/example/files/actions.lua" ) -- Basically dofile("mods/example/files/actions.lua") will appear at the end of gun_actions.lua
--ModMagicNumbersFileAdd( "mods/example/files/magic_numbers.xml" ) -- Will override some magic numbers using the specified file
--ModRegisterAudioEventMappings( "mods/example/files/audio_events.txt" ) -- Use this to register custom fmod events. Event mapping files can be generated via File -> Export GUIDs in FMOD Studio.
--ModMaterialsFileAdd( "mods/example/files/materials_rainbow.xml" ) -- Adds a new 'rainbow' material to materials
--ModLuaFileAppend( "data/scripts/items/potion.lua", "mods/example/files/potion_appends.lua" )

--print("Example mod init done")