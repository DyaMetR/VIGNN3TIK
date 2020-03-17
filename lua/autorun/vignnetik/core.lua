--[[------------------------------------------------------------------
  CORE
  Include all required files and run main hooks
]]--------------------------------------------------------------------

VGNTK:IncludeFile("config/config.lua");
VGNTK:IncludeFile("config/menu.lua");
VGNTK:IncludeFile("armour.lua");
VGNTK:IncludeFile("health.lua");
VGNTK:IncludeFile("fonts.lua");
VGNTK:IncludeFile("icons.lua");
VGNTK:IncludeFile("ammo.lua");

VGNTK:IncludeFile("data/ammo.lua");

-- Load add-ons
local files, directories = file.Find("autorun/vignnetik/add-ons/*.lua", "LUA");
for _, file in pairs(files) do
  VGNTK:IncludeFile("add-ons/"..file);
end

if CLIENT then

  hook.Add("HUDPaint", "vgntk_draw", function()
    if (not VGNTK:IsEnabled()) then return end
    VGNTK:DrawHealthOverlay(VGNTK:IsPainEnabled());
    VGNTK:DrawArmourOverlay(VGNTK:GetArmourStyle());
    VGNTK:DrawAmmo(ScrW() * 0.8, ScrH(), VGNTK:GetCompositionMode(), VGNTK:GetAmmoStyle());
  end);

  local hide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true
  };
  hook.Add("HUDShouldDraw", "vgntk_hide", function(name)
    if (not VGNTK:IsEnabled()) then return end
    hide["CHudHealth"] = VGNTK:ShouldDrawHealth();
    hide["CHudBattery"] = VGNTK:ShouldDrawHealth();
    hide["CHudAmmo"] = VGNTK:ShouldDrawAmmo();
    hide["CHudSecondaryAmmo"] = VGNTK:ShouldDrawAmmo();
    if (hide[name]) then return false; end
  end);

end
