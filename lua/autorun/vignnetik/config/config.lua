--[[------------------------------------------------------------------
  CONFIGURATION
  Console variables for user customization
]]--------------------------------------------------------------------

VGNTK:IncludeFile("menu.lua");

if CLIENT then

  -- Parameters
  local PREFIX = "vgntk_";
  local CONVARS = {
    ["enabled"] = 1,
    ["composition"] = 0,
    ["armour_style"] = 0,
    ["armour_corner"] = 0,
    ["ammo_style"] = 0,
    ["ammo_always"] = 0,
    ["armour_always"] = 0,
    ["pain"] = 1,
    ["greyscale"] = 1,
    ["draw_health"] = 1,
    ["draw_ammo"] = 1,
    ["ammo_low"] = 1,
    ["show_key"] = KEY_TAB,
    ["num_bg_a"] = 0.03,
    ["num_bg_b"] = 1,
    ["misc_col"] = Color(200, 200, 200, 175),
    ["full_col"] = Color(200, 200, 200, 175),
    ["warn_col"] = Color(220, 190, 144, 200),
    ["crit_col"] = Color(225, 60, 55, 225),
    ["armour_col"] = Color(200, 200, 200, 175),
    ["armour_bg_a"] = 0.03,
    ["armour_bg_b"] = 1,
    ["font1"] = "Roboto Light",
    ["font2"] = "Roboto Condensed Light",
    ["font1_x"] = 0,
    ["font1_y"] = 0,
    ["font2_x"] = 0,
    ["font2_y"] = 0,
    ["health_flash"] = 1,
    ["armour_flash_deplete"] = 1,
    ["armour_flash_damage"] = 1,
    ["armour_flash_full"] = 1
  }

  -- Generate convars
  for convar, default in pairs(CONVARS) do
    if (type(default) == "table") then
      CreateClientConVar(PREFIX .. convar .. "_r", default.r, true);
      CreateClientConVar(PREFIX .. convar .. "_g", default.g, true);
      CreateClientConVar(PREFIX .. convar .. "_b", default.b, true);
      CreateClientConVar(PREFIX .. convar .. "_a", default.a, true);
    else
      CreateClientConVar(PREFIX .. convar, default, true);
    end
  end

  -- Resets all configuration to default
  concommand.Add(PREFIX .. "reset", function(ply, com, args)
    for convar, default in pairs(CONVARS) do
      if (convar == "enabled") then continue end;
      if (type(default) == "table") then
        RunConsoleCommand(PREFIX .. convar .. "_r", default.r);
        RunConsoleCommand(PREFIX .. convar .. "_g", default.g);
        RunConsoleCommand(PREFIX .. convar .. "_b", default.b);
        RunConsoleCommand(PREFIX .. convar .. "_a", default.a);
      else
        RunConsoleCommand(PREFIX .. convar, default);
      end
    end
  end);

  -- Reset font family configuration
  concommand.Add(PREFIX .. "reset_fonts", function(ply, com, args)
    RunConsoleCommand(PREFIX .. "font1", CONVARS["font1"]);
    RunConsoleCommand(PREFIX .. "font2", CONVARS["font2"]);
  end);

  --[[------------------------------------------------------------------
    Gets the HUD scale
    @return {number} scale
  ]]--------------------------------------------------------------------
  function VGNTK:GetScale()
    return ScrH() / 768;
  end

  --[[------------------------------------------------------------------
    Whether the HUD is enabled
    @return {boolean} is enabled
  ]]--------------------------------------------------------------------
  function VGNTK:IsEnabled()
    return GetConVar(PREFIX .. "enabled"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Gets the selected greyscale
    @return {boolean} is enabled
  ]]--------------------------------------------------------------------
  function VGNTK:GetGreyscaleMode()
    return GetConVar(PREFIX .. "greyscale"):GetInt();
  end

  --[[------------------------------------------------------------------
    Whether the ammo counter never hides
    @return {boolean} is ammo never hidden
  ]]--------------------------------------------------------------------
  function VGNTK:IsAmmoAlwaysShown()
    return GetConVar(PREFIX .. "ammo_always"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the ammo counter should be shown when ammunition is low
    @return {boolean} is ammo shown when low
  ]]--------------------------------------------------------------------
  function VGNTK:ShowAmmoIfLow()
    return GetConVar(PREFIX .. "ammo_low"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the armour meter never hides
    @return {boolean} is armour never hidden
  ]]--------------------------------------------------------------------
  function VGNTK:IsArmourAlwaysShown()
    return GetConVar(PREFIX .. "armour_always"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Gets the selected armour style
    @return {number} armour style
  ]]--------------------------------------------------------------------
  function VGNTK:GetArmourStyle()
    return GetConVar(PREFIX .. "armour_style"):GetInt();
  end

  --[[------------------------------------------------------------------
    Whether the armour icon should snap to the corner
    @return {boolean} should be on corner
  ]]--------------------------------------------------------------------
  function VGNTK:IsArmourOnCorner()
    return GetConVar(PREFIX .. "armour_corner"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Gets the selected ammo style
    @return {boolean} is hev mode
  ]]--------------------------------------------------------------------
  function VGNTK:GetAmmoStyle()
    return GetConVar(PREFIX .. "ammo_style"):GetInt();
  end

  --[[------------------------------------------------------------------
    Gets the current ammunition composition mode
    @return {number} ammo composition mode
  ]]--------------------------------------------------------------------
  function VGNTK:GetCompositionMode()
    return GetConVar(PREFIX .. "composition"):GetInt();
  end

  --[[------------------------------------------------------------------
    Whether the pain effect should be reserved only for low health indication
    @return {boolean} is pain enabled
  ]]--------------------------------------------------------------------
  function VGNTK:IsPainEnabled()
    return GetConVar(PREFIX .. "pain"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the health and armour effects should be drawn
    @return {boolean} is health and armour enabled
  ]]--------------------------------------------------------------------
  function VGNTK:ShouldDrawHealth()
    return GetConVar(PREFIX .. "draw_health"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the ammunition indicator should be drawn
    @return {boolean} is ammo enabled
  ]]--------------------------------------------------------------------
  function VGNTK:ShouldDrawAmmo()
    return GetConVar(PREFIX .. "draw_ammo"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Gets the key that brings up the HUD
    @return {number} key
  ]]--------------------------------------------------------------------
  function VGNTK:GetShowKey()
    return GetConVar(PREFIX .. "show_key"):GetInt();
  end

  --[[------------------------------------------------------------------
    Gets the numbers' background alpha
    @return {number} alpha percentage
  ]]--------------------------------------------------------------------
  function VGNTK:GetNumberBackgroundAlpha()
    return GetConVar(PREFIX .. "num_bg_a"):GetFloat();
  end

  --[[------------------------------------------------------------------
    Gets the numbers' background brightness
    @return {number} brightness
  ]]--------------------------------------------------------------------
  function VGNTK:GetNumberBackgroundBrightness()
    return GetConVar(PREFIX .. "num_bg_b"):GetFloat();
  end

  --[[------------------------------------------------------------------
    Gets the armour icon background alpha
    @return {number} alpha percentage
  ]]--------------------------------------------------------------------
  function VGNTK:GetArmourBackgroundAlpha()
    return GetConVar(PREFIX .. "armour_bg_a"):GetFloat();
  end

  --[[------------------------------------------------------------------
    Gets the armour background brightness
    @return {number} brightness
  ]]--------------------------------------------------------------------
  function VGNTK:GetArmourBackgroundBrightness()
    return GetConVar(PREFIX .. "armour_bg_b"):GetFloat();
  end

  --[[------------------------------------------------------------------
    Gets the font family used in the clip indicator
    @return {string} font family
  ]]--------------------------------------------------------------------
  function VGNTK:GetPrimaryFontFamily()
    return GetConVar(PREFIX .. "font1"):GetString();
  end

  --[[------------------------------------------------------------------
    Gets the font family used in the reserve indicator
    @return {string} font family
  ]]--------------------------------------------------------------------
  function VGNTK:GetSecondaryFontFamily()
    return GetConVar(PREFIX .. "font2"):GetString();
  end

  --[[------------------------------------------------------------------
    Gets the x and y offset of the primary font
    @return {number} x
    @return {number} y
  ]]--------------------------------------------------------------------
  function VGNTK:GetPrimaryFontOffset()
    return GetConVar(PREFIX .. "font1_x"):GetInt(), GetConVar(PREFIX .. "font1_y"):GetInt();
  end

  --[[------------------------------------------------------------------
    Gets the x and y offset of the secondary font
    @return {number} x
    @return {number} y
  ]]--------------------------------------------------------------------
  function VGNTK:GetSecondaryFontOffset()
    return GetConVar(PREFIX .. "font2_x"):GetInt(), GetConVar(PREFIX .. "font2_y"):GetInt();
  end

  --[[------------------------------------------------------------------
    Whether the '100% health' flash is enabled
    @return {boolean} is enabled
  ]]--------------------------------------------------------------------
  function VGNTK:IsHealthFlashEnabled()
    return GetConVar(PREFIX .. "health_flash"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the armour depleting flash is enabled
    @return {boolean} is enabled
  ]]--------------------------------------------------------------------
  function VGNTK:IsArmourDepleteFlashEnabled()
    return GetConVar(PREFIX .. "armour_flash_deplete"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the armour vignette is displayed
    @return {boolean} is enabled
  ]]--------------------------------------------------------------------
  function VGNTK:IsArmourVignetteEnabled()
    return GetConVar(PREFIX .. "armour_flash_damage"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Whether the armour 100% flash is enabled
    @return {boolean} is enabled
  ]]--------------------------------------------------------------------
  function VGNTK:IsArmourFullFlashEnabled()
    return GetConVar(PREFIX .. "armour_flash_full"):GetInt() >= 1;
  end

  --[[------------------------------------------------------------------
    Gets the colour for miscellaneous elements
    @return {Color} colour
  ]]--------------------------------------------------------------------
  function VGNTK:GetMiscColour()
    return Color(
      GetConVar(PREFIX .. "misc_col_r"):GetInt(),
      GetConVar(PREFIX .. "misc_col_g"):GetInt(),
      GetConVar(PREFIX .. "misc_col_b"):GetInt(),
      GetConVar(PREFIX .. "misc_col_a"):GetInt()
    );
  end

  --[[------------------------------------------------------------------
    Gets the colour for full ammunition
    @return {Color} colour
  ]]--------------------------------------------------------------------
  function VGNTK:GetFullAmmoColour()
    return Color(
      GetConVar(PREFIX .. "full_col_r"):GetInt(),
      GetConVar(PREFIX .. "full_col_g"):GetInt(),
      GetConVar(PREFIX .. "full_col_b"):GetInt(),
      GetConVar(PREFIX .. "full_col_a"):GetInt()
    );
  end

  --[[------------------------------------------------------------------
    Gets the colour for ammunition when not full
    @return {Color} colour
  ]]--------------------------------------------------------------------
  function VGNTK:GetWarnAmmoColour()
    return Color(
      GetConVar(PREFIX .. "warn_col_r"):GetInt(),
      GetConVar(PREFIX .. "warn_col_g"):GetInt(),
      GetConVar(PREFIX .. "warn_col_b"):GetInt(),
      GetConVar(PREFIX .. "warn_col_a"):GetInt()
    );
  end

  --[[------------------------------------------------------------------
    Gets the colour for ammunition when critical
    @return {Color} colour
  ]]--------------------------------------------------------------------
  function VGNTK:GetCritAmmoColour()
    return Color(
      GetConVar(PREFIX .. "crit_col_r"):GetInt(),
      GetConVar(PREFIX .. "crit_col_g"):GetInt(),
      GetConVar(PREFIX .. "crit_col_b"):GetInt(),
      GetConVar(PREFIX .. "crit_col_a"):GetInt()
    );
  end

  --[[------------------------------------------------------------------
    Gets the colour for the armour icons
    @return {Color} colour
  ]]--------------------------------------------------------------------
  function VGNTK:GetArmourColour()
    return Color(
      GetConVar(PREFIX .. "armour_col_r"):GetInt(),
      GetConVar(PREFIX .. "armour_col_g"):GetInt(),
      GetConVar(PREFIX .. "armour_col_b"):GetInt(),
      GetConVar(PREFIX .. "armour_col_a"):GetInt()
    );
  end

end
