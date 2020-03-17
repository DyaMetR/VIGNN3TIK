--[[------------------------------------------------------------------
  MENU
  Configuration menu options
]]--------------------------------------------------------------------

if CLIENT then

  hook.Add( "PopulateToolMenu", "vgntk_menu", function()
    spawnmenu.AddToolMenuOption( "Options", "DyaMetR", "vngtk", "VIGNN3TIK", nil, nil, function(panel)
      panel:ClearControls();

      panel:AddControl( "CheckBox", {
        Label = "Enabled",
        Command = "vgntk_enabled",
        }
      );

      panel:AddControl( "CheckBox", {
    		Label = "Health and armour enabled",
    		Command = "vgntk_draw_health",
    		}
    	);

      panel:AddControl( "CheckBox", {
    		Label = "Ammunition enabled",
    		Command = "vgntk_draw_ammo",
    		}
    	);

      panel:AddControl( "CheckBox", {
        Label = "Don't hide armour",
        Command = "vgntk_armour_always",
        }
      );

      panel:AddControl( "CheckBox", {
        Label = "Don't hide ammo",
        Command = "vgntk_ammo_always",
        }
      );

      panel:AddControl( "CheckBox", {
        Label = "Show ammo when low",
        Command = "vgntk_ammo_low",
        }
      );

      panel:AddControl( "CheckBox", {
        Label = "Snap armour icon to the corner",
        Command = "vgntk_armour_corner"
      });

      panel:AddControl( "CheckBox", {
    		Label = "Pain accumulation",
    		Command = "vgntk_pain",
    		}
    	);

      panel:AddControl( "CheckBox", {
        Label = "Full health flash",
        Command = "vgntk_health_flash",
        }
      );

      panel:AddControl( "CheckBox", {
        Label = "Full armour flash",
        Command = "vgntk_armour_flash_full",
        }
      );

      panel:AddControl( "CheckBox", {
        Label = "Armour depleted flash",
        Command = "vgntk_armour_flash_deplete",
        }
      );

      panel:AddControl( "CheckBox", {
        Label = "Armour damage effect",
        Command = "vgntk_armour_flash_damage",
        }
      );

      local combobox, label = panel:ComboBox("Greyscale mode", "vgntk_greyscale");
      combobox:AddChoice("Disabled", 0);
      combobox:AddChoice("Pain and low health", 1);
      combobox:AddChoice("Low health only", 2);
      combobox:AddChoice("Pain only", 3);

      panel:AddControl( "Slider", {
        Label = "Composition",
        Type = "Integer",
        Min = 0,
        Max = 7,
        Command = "vgntk_composition"}
      );

      local combobox, label = panel:ComboBox("Ammo visual style", "vgntk_ammo_style");
      combobox:AddChoice("Default", 0);
      combobox:AddChoice("HEV", 1);
      combobox:AddChoice("Classic", 2);

      local combobox, label = panel:ComboBox("Armour visual style", "vgntk_armour_style");
      combobox:AddChoice("Default", 0);
      combobox:AddChoice("Kevlar icon", 1);
      combobox:AddChoice("Battery icon", 2);
      combobox:AddChoice("HEV", 3);

      panel:AddControl( "Slider", {
        Label = "Numbers' background transparency",
        Type = "Float",
        Min = 0,
        Max = 1,
        Command = "vgntk_num_bg_a"}
      );

      panel:AddControl( "Slider", {
        Label = "Numbers' background brightness",
        Type = "Float",
        Min = 0,
        Max = 1,
        Command = "vgntk_num_bg_b"}
      );

      panel:AddControl( "Slider", {
        Label = "Armour background transparency",
        Type = "Float",
        Min = 0,
        Max = 1,
        Command = "vgntk_armour_bg_a"}
      );

      panel:AddControl( "Slider", {
        Label = "Armour background brightness",
        Type = "Float",
        Min = 0,
        Max = 1,
        Command = "vgntk_armour_bg_b"}
      );

      panel:AddControl( "TextBox", {
        Label = "Main font family",
        Command = "vgntk_font1"}
      );

      panel:AddControl( "Slider", {
        Label = "Primary font X",
        Type = "Integer",
        Min = -100,
        Max = 100,
        Command = "vgntk_font1_x"}
      );

      panel:AddControl( "Slider", {
        Label = "Primary font Y",
        Type = "Integer",
        Min = -100,
        Max = 100,
        Command = "vgntk_font1_y"}
      );

      panel:AddControl( "TextBox", {
        Label = "Secondary font family",
        Command = "vgntk_font2"}
      );

      panel:AddControl( "Slider", {
        Label = "Secondary font X",
        Type = "Integer",
        Min = -100,
        Max = 100,
        Command = "vgntk_font2_x"}
      );

      panel:AddControl( "Slider", {
        Label = "Secondary font Y",
        Type = "Integer",
        Min = -100,
        Max = 100,
        Command = "vgntk_font2_y"}
      );

      panel:AddControl( "Button", {
    		Label = "Reset fonts to default",
    		Command = "vgntk_reset_fonts",
    		}
    	);

      panel:AddControl( "Color", {
        Label = "Miscellaneous colour",
        Red = "vgntk_misc_col_r",
        Green = "vgntk_misc_col_g",
        Blue = "vgntk_misc_col_b",
        Alpha = "vgntk_misc_col_a"
        }
      );

      panel:AddControl( "Color", {
        Label = "Full ammo colour",
        Red = "vgntk_full_col_r",
        Green = "vgntk_full_col_g",
        Blue = "vgntk_full_col_b",
        Alpha = "vgntk_full_col_a"
        }
      );

      panel:AddControl( "Color", {
        Label = "Warn ammo colour",
        Red = "vgntk_warn_col_r",
        Green = "vgntk_warn_col_g",
        Blue = "vgntk_warn_col_b",
        Alpha = "vgntk_warn_col_a"
        }
      );

      panel:AddControl( "Color", {
        Label = "Crit ammo colour",
        Red = "vgntk_crit_col_r",
        Green = "vgntk_crit_col_g",
        Blue = "vgntk_crit_col_b",
        Alpha = "vgntk_crit_col_a"
        }
      );

      panel:AddControl( "Color", {
        Label = "Armour icon colour",
        Red = "vgntk_armour_col_r",
        Green = "vgntk_armour_col_g",
        Blue = "vgntk_armour_col_b",
        Alpha = "vgntk_armour_col_a"
        }
      );

      panel:AddControl( "Numpad", {
        Label = "Bring up the HUD",
        Command = "vgntk_show_key"
        }
      );

      panel:AddControl( "Button", {
    		Label = "Reset settings to default",
    		Command = "vgntk_reset",
    		}
    	);

      -- Credits
      panel:AddControl( "Label",  { Text = ""});
      panel:AddControl( "Label",  { Text = "Version " .. VGNTK.Version});
    end )
  end);

end
