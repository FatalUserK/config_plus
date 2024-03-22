dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.



-- This file can't access other files from this or other mods in all circumstances.
-- Settings will be automatically saved.
-- Settings don't have access unsafe lua APIs.

-- Use ModSettingGet() in the game to query settings.
-- For some settings (for example those that affect world generation) you might want to retain the current value until a certain point, even
-- if the player has changed the setting while playing.
-- To make it easy to define settings like that, each setting has a "scope" (e.g. MOD_SETTING_SCOPE_NEW_GAME) that will define when the changes
-- will actually become visible via ModSettingGet(). In the case of MOD_SETTING_SCOPE_NEW_GAME the value at the start of the run will be visible
-- until the player starts a new game.
-- ModSettingSetNextValue() will set the buffered value, that will later become visible via ModSettingGet(), unless the setting scope is MOD_SETTING_SCOPE_RUNTIME.

function mod_setting_bool_custom( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	local text = setting.ui_name .. " - " .. GameTextGet( value and "$option_on" or "$option_off" )

	if GuiButton( gui, im_id, mod_setting_group_x_offset, 0, text ) then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

function mod_setting_change_callback( mod_id, gui, in_main_menu, setting, old_value, new_value  )
	print( tostring(new_value) )
end

local mod_id = "config_plus" -- This should match the name of your mod's folder.
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value. 
mod_settings = 
{
	{
		id = "_",
		ui_name = "YOOOOO ITS A MOD MENU!!!!!",
		not_setting = true,
	},

	{
		category_id = "vanilla_settings_plus",
		ui_name = "Vanilla Settings",
		ui_description = "Custom Settings that affect the base game",
		foldable = true,
		_folded = true,
		settings = {

			{
				id = "vanilla_settings_warning_plus",
				ui_name = "Warning: These settings may clash with other mods in unintended ways",
				ui_description = "If you notice such a case caused by this mod, please do not hesitate to let me know the details on the Noita Discord",
				not_setting = true,
			},


			--[[ {
				id = "vanilla_fungal_shift_material_items_plus",
				ui_name = "Fungal Shifts work with any material holder",
				ui_description = "Allows Fungal Shifts to shift materials in any held material container, not just flasks. This includes things like pouches and modded items",
				value_default = false,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					
					GuiLayoutBeginHorizontal( gui, x, y ); --this chunk of code was stole- *i mean "acquired"*, from Goki's things
					local left_click, right_click = GuiImageButton( gui, id, 0, 1, "", "mods/config_plus/files/mod_settings/checkbox" .. (value == true and "_fill" or "") .. ".png" );
					if value == false then
						GuiColorSetForNextWidget( gui, 0.60, 0.60, 0.60, 1.0 );
					end
					if lmb then
						ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
						mod_setting_handle_change_callback( mod_id, gui, in_main_menu, setting, value, not value )
					end
					if rmb then
						local new_value = setting.value_default or false
						ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), new_value, false )
						mod_setting_handle_change_callback( mod_id, gui, in_main_menu, setting, value, new_value )
					end
				GuiLayoutEnd( gui );
				end
					
			}, ]] --removed as this now already exists
			
			{
				id = "do_starting_crap",
				ui_name = "Random Shenanigans",
				ui_description = "If enabled, testing apparatus will appear at spawn.",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				ui_fn = function( mod_id, gui, in_main_menu, im_id, setting )
		
					GuiLayoutBeginHorizontal(gui, 0, 0, false, 0, 0)
						GuiColorSetForNextWidget(gui, 1.0, 1.0, 1.0, 0.5)
						GuiText(gui, mod_setting_group_x_offset, 0, "Random Shenanigans: ")
						local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
						local lmb, rmb = GuiButton(gui, im_id, 0, 0, value and "[Yes]" or "[No]")
						if lmb then
							ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
							mod_setting_handle_change_callback( mod_id, gui, in_main_menu, setting, value, not value )
						end
						if rmb then
							local new_value = setting.value_default or false
							ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), new_value, false )
							mod_setting_handle_change_callback( mod_id, gui, in_main_menu, setting, value, new_value )
						end
						mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
					GuiLayoutEnd(gui)
		
				end
			},
		},
	},
	
	{
        id = "warning",
        ui_name = "Warning!",
		ui_description = "Yeah it sucks, but I can't do much about it :/", -- apparently this doesnt show, lmao
        ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
            if in_main_menu then
                GuiLayoutBeginHorizontal(gui, 0, 0, false, 5, 5)
                GuiImage(gui, im_id, 0, 0, "data/ui_gfx/inventory/icon_warning.png", 1, 1, 1)
                GuiColorSetForNextWidget(gui, 0.9, 0.4, 0.4, 0.9)
                GuiText(gui, 0, 2, "It is recommended you edit settings in game to see only settings for enabled mods\nTo see all settings, use the toggle below.")
                GuiLayoutEnd(gui)
            end
        end
    },
	{
		id = "view_all_settings_plus",
		ui_name = "View all mod settings ",
		ui_description = "Will show all settings, including ones for mods that are not enabled",
		value_default = true,
	},
}

if ModIsEnabled( "Hydroxide" ) or ModSettingGet( "mod_config.view_all_settings_plus" ) then
	mod_settings[#mod_settings+1] = {
		category_id = "chemical_curiosities_plus",
		ui_name = "Chemical Curiosities",
		ui_description = "Settings for Chemical Curiosities",
		foldable = true,
		_folded = true,
		settings = {
			{
				category_id = "chemical_curiosities_materials_plus",
				ui_name = "MATERIALS",
				ui_description = "Configure Materials from Chemical Curiosities",
				foldable = true,
				_folded = true,
				settings = {
					{
						id = "hungry_slime_spawning_plus",
						ui_name = "World size 2",
						ui_description = "How much world do you want?",
						value_default = "small",
						values = { {"small","Small"}, {"medium","Medium"}, {"huge","Huge"} },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
						change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
					},
					{
						id = "difficulty2",
						ui_name = "Difficulty 2",
						ui_description = "Challenge amount.",
						value_default = "easy",
						values = { {"easy","Easy"}, {"normal","Normal"}, {"hard","Hard"} },
						scope = MOD_SETTING_SCOPE_RUNTIME,
					},
					{
						id = "minibosses_enabled2",
						ui_name = "Minibosses 2",
						ui_description = "Minibosses spawn occasionally.",
						value_default = true,
						scope = MOD_SETTING_SCOPE_RUNTIME,
					},
				},
			},
		},
	}
end
-- This function is called to ensure the correct setting values are visible to the game via ModSettingGet(). your mod's settings don't work if you don't have a function like this defined in settings.lua.
-- This function is called:
--		- when entering the mod settings menu (init_scope will be MOD_SETTINGS_SCOPE_ONLY_SET_DEFAULT)
-- 		- before mod initialization when starting a new game (init_scope will be MOD_SETTING_SCOPE_NEW_GAME)
--		- when entering the game after a restart (init_scope will be MOD_SETTING_SCOPE_RESTART)
--		- at the end of an update when mod settings have been changed via ModSettingsSetNextValue() and the game is unpaused (init_scope will be MOD_SETTINGS_SCOPE_RUNTIME)
function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end


