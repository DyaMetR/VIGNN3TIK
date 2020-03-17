--[[------------------------------------------------------------------
  AMMUNITION ICONS
  Icons representing an ammunition type
]]--------------------------------------------------------------------

if CLIENT then

  -- Parameters
  local DEFAULT_ICON = { icon = "r", h = 10, w = 50, offset = 0, isDM = false };

  -- Table
  VGNTK.AmmoIcons = {};

  --[[------------------------------------------------------------------
    Adds an ammunition type icon
    @param {string} ammunition type
    @param {string} character
    @param {number} height
    @param {number|nil} width
    @param {number|nil} vertical offset
    @param {boolean|nil} whether it uses Half-Life 2 DM font
  ]]--------------------------------------------------------------------
  function VGNTK:AddAmmoIcon(ammoType, char, h, w, offset, isDM)
    w = w or 50;
    h = h or 10;
    offset = offset or 0;
    VGNTK.AmmoIcons[ammoType] = { icon = char, h = h, w = w, offset = offset, isDM = isDM };
  end

  --[[------------------------------------------------------------------
    Gets the ammunition type icon
    @param {string} ammunition type
    @return {string} character
  ]]--------------------------------------------------------------------
  function VGNTK:GetAmmoIcon(ammoType)
    return VGNTK.AmmoIcons[ammoType] or DEFAULT_ICON;
  end

end
