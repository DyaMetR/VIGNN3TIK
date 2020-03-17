--[[------------------------------------------------------------------
  AMMUNITION
  Ammunition indicator
]]--------------------------------------------------------------------

VGNTK:IncludeFile("util/classic.lua");
VGNTK:IncludeFile("util/hev.lua");

if CLIENT then

  -- Parameters
  local CLIP_ZEROES = "000";
  local RESV_ZEROES = "0000";
  local MIN_ZEROES = "00";
  local BULLET_SPEED = 0.2;
  local TIME = 4;
  local RELOAD_SPEED = 0.04;
  local COLOUR_SPEED = 0.04;
  local HEV_FULL_COLOUR = Color(255 * 0.7, 238 * 0.7, 23 * 0.7);
  local HEV_RED_COLOUR = Color(220, 0, 0);

  -- Variables
  local tick = 0;
  local anim1 = 1;
  local anim2 = 1;
  local move1 = false;
  local move2 = false;
  local lastClip = -1;
  local lastAlt = -1;
  local lastResv = -1;
  local lastWep = "";
  local anim = 0;
  local time = 0;
  local _bullet1 = 1;
  local _bullet2 = 1;
  local colour1 = 0;

  VGNTK.IsAmmoLow = false;

  -- Internal function; intersects two values
  local function Intersect(a, b, value)
		return (a * value) + (b * (1-value));
	end

	-- Internal function; intersects two colours
	local function IntersectColour(a, b, value)
		return Color(Intersect(a.r, b.r, value), Intersect(a.g, b.g, value), Intersect(a.b, b.b, value), Intersect(a.a, b.a, value));
	end

  --[[------------------------------------------------------------------
    Whether the current weapon has low ammunition left
    @param {number} current ammo
    @param {number} maximum ammo
    @param {boolean|nil} current ammo max is the same as convar
    @return {boolean} is weapon low on ammo
  ]]--------------------------------------------------------------------
  local function IsAmmoLow(clip, max, sameAsConVar)
    --[[if (isHevMode) then
      return (clip/max <= 0.25 and not sameAsConVar) or (sameAsConVar and clip <= 0);
    end]]
    return (not sameAsConVar and clip <= max * 0.25) or (sameAsConVar and clip < 10);
  end

  -- Internal function; animates the colour
  local function AnimateColour(clip, max, sameAsConVar, isHevMode)
    if (isHevMode) then
      if (VGNTK.IsAmmoLow) then
        local i = 1.26;
        if (clip <= 0) then i = 2; end
        colour1 = math.min(colour1 + COLOUR_SPEED, i);
      else
        if (clip >= max) then
          colour1 = math.max(colour1 - COLOUR_SPEED, 0);
        else
          colour1 = math.min(colour1 + COLOUR_SPEED, 1);
        end
      end
    else
      if ((clip < max and not sameAsConVar) or (sameAsConVar and clip < 10)) then
        if (VGNTK.IsAmmoLow) then
          colour1 = math.min(colour1 + COLOUR_SPEED, 2);
        else
          if (colour1 > 1) then
            colour1 = math.max(colour1 - COLOUR_SPEED, 1);
          else
            colour1 = math.min(colour1 + COLOUR_SPEED, 1);
          end
        end
      else
        colour1 = math.max(colour1 - COLOUR_SPEED, 0);
      end
    end
  end

  --[[------------------------------------------------------------------
    Gets the current ammo colour
    @param {boolean|nil} is it HEV styled
  ]]--------------------------------------------------------------------
  function VGNTK:GetColour(isHev)
    if (isHev) then
      if (colour1 <= 1) then
        return IntersectColour(VGNTK.HEV_COLOUR, HEV_FULL_COLOUR, colour1);
      else
        return IntersectColour(HEV_RED_COLOUR, VGNTK.HEV_COLOUR, colour1 - 1);
      end
    else
      if (colour1 <= 1) then
        return IntersectColour(VGNTK:GetWarnAmmoColour(), VGNTK:GetFullAmmoColour(), colour1);
      else
        return IntersectColour(VGNTK:GetCritAmmoColour(), VGNTK:GetWarnAmmoColour(), colour1 - 1);
      end
    end
  end

  --[[------------------------------------------------------------------
    Animates most of the HUD
    @void
  ]]--------------------------------------------------------------------
  local function Animate(isHevMode)
    local weapon = LocalPlayer():GetActiveWeapon();
    local clip = -1;
    local alt = -1;
    local max = -1;
    local resv = -1;
    local sameAsConVar = false;
    if (IsValid(weapon)) then
      local primary = weapon:GetPrimaryAmmoType();
      local secondary = weapon:GetSecondaryAmmoType();
      clip = weapon:Clip1();
      max = weapon:GetMaxClip1();
      resv = LocalPlayer():GetAmmoCount(primary);
      if (weapon:GetPrimaryAmmoType() <= 0 and weapon:GetSecondaryAmmoType() > 0) then
        clip = LocalPlayer():GetAmmoCount(secondary);
        max = game.GetAmmoMax(secondary);
        sameAsConVar = max == GetConVar("gmod_maxammo"):GetInt() or max <= 0;
      else
        if (clip <= -1) then
          clip = resv;
          max = game.GetAmmoMax(primary);
          sameAsConVar = max == GetConVar("gmod_maxammo"):GetInt() or max <= 0;
        end
        alt = LocalPlayer():GetAmmoCount(secondary);
      end
      VGNTK.IsAmmoLow = IsAmmoLow(clip, max, sameAsConVar);
    end

    -- Detect special keys
    if (input.IsKeyDown(VGNTK:GetShowKey()) or LocalPlayer():KeyDown(IN_RELOAD) or (LocalPlayer():KeyDown(IN_ATTACK) and clip <= 0)) then
      time = CurTime() + TIME;
    end

    -- Detect clip emptying
    if (clip ~= lastClip) then
      if (clip < lastClip) then
        move1 = true;
        anim1 = 0;
        _bullet1 = 0;

      else
        if (clip - lastClip > 1) then
          _bullet1 = 1;
        end
        move1 = false;
        anim1 = 0;
      end
      VGNTK:UpdateHEVCounter("clip", clip < lastClip);
      time = CurTime() + TIME;
      lastClip = clip;
    end

    if (alt ~= lastAlt) then
      if (alt < lastAlt) then
        move2 = true;
      else
        move2 = false;
        anim2 = 0;
      end
      VGNTK:UpdateHEVCounter("alt");
      time = CurTime() + TIME;
      lastAlt = alt;
    end

    if (resv ~= lastResv) then
      lastResv = resv;
      time = CurTime() + TIME;
      VGNTK:UpdateHEVCounter("resv");
    end

    if (lastWep ~= weapon:GetClass()) then
      _bullet1 = 1;
      _bullet2 = 1;
      time = CurTime() + TIME;
      hBlink = 1;
      lastWep = weapon:GetClass();
    end -- Switch weapon

    -- Tick based animations
    if (tick < CurTime()) then
      if (move1) then
        if (anim1 < 1) then
          anim1 = math.min(anim1 + BULLET_SPEED, 1);
        else
          if (clip > 0) then
            anim1 = 0;
          end
          move1 = false;
        end
      end -- Primary bullet

      if (move2) then
        if (anim2 < 1) then
          anim2 = math.min(anim2 + BULLET_SPEED, 1);
        else
          if (alt > 0) then
            anim2 = 0;
          end
          move2 = false;
        end
      end -- Alt bullet

      if (time > CurTime() or VGNTK:IsAmmoAlwaysShown() or (VGNTK:ShowAmmoIfLow() and VGNTK.IsAmmoLow)) then
        anim = math.min(anim + 0.08, 1);
      else
        anim = math.max(anim - 0.03, 0);
      end -- Show based on config or time to show

      _bullet1 = math.max(_bullet1 - RELOAD_SPEED, 0);
      _bullet2 = math.max(_bullet2 - RELOAD_SPEED, 0);

      AnimateColour(clip, max, sameAsConVar, isHevMode);

      tick = CurTime() + 0.0001;
    end
  end

  -- Internal function; draws a number with a background
  local function DrawNumber(x, y, font, value, col, zeroes, align)
    zeroes = zeroes or CLIP_ZEROES;
    align = align or TEXT_ALIGN_RIGHT;
    local b = VGNTK:GetNumberBackgroundBrightness();
    draw.SimpleText(zeroes, font, x, y, Color(255 * b, 255 * b, 255 * b, col.a * VGNTK:GetNumberBackgroundAlpha()), align);
    local offset = 0;
    if (align ~= TEXT_ALIGN_RIGHT) then
      surface.SetFont(font);
      offset = surface.GetTextSize(zeroes);
    end
    draw.SimpleText(value, font .. "_b", x + offset, y, Color(col.r, col.g, col.b, col.a * 0.1), TEXT_ALIGN_RIGHT);
    draw.SimpleText(value, font, x + offset, y, col, TEXT_ALIGN_RIGHT);
  end

  --[[------------------------------------------------------------------
    Returns the original font or the HL2:DM variant based on icon
    @param {table} icon data
    @param {string} initial font
    @return {string} final font
  ]]--------------------------------------------------------------------
  function VGNTK:GetAmmoFont(icon, font)
    if (icon.isDM) then return font .. "_dm"; end
    return font;
  end

  -- Internal function; draws an ammunition icon
  local function DrawAmmoIcon(x, y, icon, col, align, font, blur)
    align = align or TEXT_ALIGN_RIGHT;
    font = font or VGNTK.ICON_FONT;
    blur = blur or 0.1;
    draw.SimpleText(icon, font .. "_b", x, y, Color(col.r, col.g, col.b, col.a * blur), align, TEXT_ALIGN_CENTER);
    draw.SimpleText(icon, font, x, y, col, align, TEXT_ALIGN_CENTER);
  end

  --[[------------------------------------------------------------------
    Draws an animated bullet tray
    @param {number} x
    @param {number} y
    @param {number} ammunition type
    @param {number} size where the bullets are concealed
    @param {Color} colour
    @param {number} alignment
    @param {number|nil} fire animation
    @param {number|nil} next bullet animation
    @param {number|nil} vertical alignment
    @param {number|nil} style
  ]]--------------------------------------------------------------------
  function VGNTK:DrawBulletTray(x, y, ammoType, amount, max, col, align, anim, bulletAnim, vAlign, style)
    style = style or 0;
    anim = anim or anim1;
    bulletAnim = bulletAnim or _bullet1;
    vAlign = vAlign or TEXT_ALIGN_TOP;
    y = y + (23 * VGNTK:GetScale());

    local icon = VGNTK:GetAmmoIcon(game.GetAmmoName(ammoType));
    local h = icon.h * VGNTK:GetScale();

    -- Font and blur based on style
    local font = VGNTK:GetAmmoFont(icon, VGNTK.ICON_FONT);
    local blur = nil;
    if (style == 1) then
      font = VGNTK:GetAmmoFont(icon, VGNTK.HL2_ICON_FONT);
      blur = VGNTK:GetHEVBlur("clip") * (1 - VGNTK:GetHEVGlitch());
    elseif (style > 1) then
      font = VGNTK:GetAmmoFont(icon, VGNTK.CLASSIC_ICON_FONT);
      h = h * 2;
    end

    -- Get maximum amount of bullets
    max = math.ceil(max/h);

    -- Align
    if (vAlign == TEXT_ALIGN_CENTER) then
      y = y - (h * (max - 1) * 0.5);
    elseif (vAlign == TEXT_ALIGN_BOTTOM) then
      y = y - (h * max);
    end
    -- Draw
    if (bulletAnim <= 0) then
      DrawAmmoIcon(x, y - (h * anim) + (icon.offset * VGNTK:GetScale()), icon.icon, Color(col.r, col.g, col.b, col.a * ((1 - anim) * 0.76)), align, font, blur);
    end
    if (amount <= 0) then return end
    for i=math.floor(1 - bulletAnim) + (max * bulletAnim), math.min(amount - math.floor(1 - bulletAnim), max) + math.ceil(anim) + ((max - 1) * bulletAnim) do
      local a = (max - (i - anim))/max;
      if (style == 1) then a = 1; end
      DrawAmmoIcon(x, y + (i * h) - (h * anim) + (icon.offset * VGNTK:GetScale()), icon.icon, Color(col.r, col.g, col.b, col.a * a * 0.76), align, font, blur);
    end
  end

  -- Internal function; draws the default ammo counter
  local function DrawDefault(x, y, mode, weapon, primary, secondary, clip, bullets1, resv, alt, altOnly)
    -- Get values based on configuration
    local zeroes = CLIP_ZEROES;
    if (clip <= -1 or altOnly) then -- Is weapon not clip based?
      if (altOnly) then
        primary = secondary;
        resv = alt;
        clip = -1;
      end
      bullets1 = resv;
      if (mode <= 0) then
        zeroes = MIN_ZEROES;
      else
        clip = resv;
      end
    else
      if (mode <= 0) then
        clip = math.ceil(resv / weapon:GetMaxClip1());
        if (clip <= 100) then zeroes = MIN_ZEROES; end
      elseif (mode == 1 or mode == 2 or mode == 5 or mode == 6) then
        if (clip >= 1000) then zeroes = RESV_ZEROES; end
        local resvZeroes = RESV_ZEROES;
        if (mode == 1 or mode == 5) then
          resv = math.ceil(resv / weapon:GetMaxClip1());
          resvZeroes = MIN_ZEROES;
          if (resv >= 100) then resvZeroes = CLIP_ZEROES; end
        end
        local a, b = VGNTK:GetSecondaryFontOffset();
        DrawNumber(x + ((2 + a) * VGNTK:GetScale()), y + ((1 + b) * VGNTK:GetScale()), VGNTK.RESV_FONT, resv, VGNTK:GetFullAmmoColour(), resvZeroes, TEXT_ALIGN_LEFT);
      else
        if (mode == 4 or mode == 7) then
          clip = clip + resv;
        elseif (mode == 3) then
          clip = resv;
        end
        if (clip >= 1000) then zeroes = RESV_ZEROES; end
      end
    end

    local a, b = VGNTK:GetPrimaryFontOffset();
    local col = VGNTK:GetColour();
    -- Draw clip
    if (clip > -1) then -- Don't draw if it doesn't use clips
      DrawNumber(x + (a * VGNTK:GetScale()), y + (b * VGNTK:GetScale()), VGNTK.CLIP_FONT, clip, col, zeroes);
    end

    surface.SetFont(VGNTK.CLIP_FONT);
    local w = surface.GetTextSize(zeroes);
    local h = 60 * VGNTK:GetScale();
    if (mode < 5) then
      VGNTK:DrawBulletTray(x - w - (VGNTK:GetScale() * 3), y - (6 * VGNTK:GetScale()), primary, bullets1, h, col, nil, nil, nil, nil, style);
    end

    -- Draw secondary
    if (secondary <= 0 or altOnly) then return end
    local icon = VGNTK:GetAmmoIcon(primary);
    surface.SetFont(VGNTK:GetAmmoFont(icon, VGNTK.ICON_FONT));
    w = w + surface.GetTextSize(icon.icon) + (VGNTK:GetScale() * 33);
    local altZeroes = MIN_ZEROES;
    if (alt >= 100 and alt < 1000) then
      altZeroes = CLIP_ZEROES;
    elseif (alt >= 1000) then
      altZeroes = RESV_ZEROES;
    end -- Get zeroes
    DrawNumber(x - w + (a * VGNTK:GetScale()), y + (b * VGNTK:GetScale()), VGNTK.CLIP_FONT, alt, VGNTK:GetMiscColour(), altZeroes);
    surface.SetFont(VGNTK.CLIP_FONT);

    if (mode < 5) then
      VGNTK:DrawBulletTray(x - w - surface.GetTextSize(altZeroes) - (3 * VGNTK:GetScale()), y - (6 * VGNTK:GetScale()), secondary, alt, h, VGNTK:GetFullAmmoColour(), nil, anim2, _bullet2, nil, style);
    end
  end

  --[[------------------------------------------------------------------
    Draws the ammunition display
    @param {number} x
    @param {number} y
    @param {number} mode
    @param {number} style
  ]]--------------------------------------------------------------------
  function VGNTK:DrawAmmo(x, y, mode, style)
    if (not VGNTK:ShouldDrawAmmo()) then return end
    y = y - (80 * VGNTK:GetScale());
    local weapon = LocalPlayer():GetActiveWeapon();
    if (not IsValid(weapon)) then return end
    local primary = weapon:GetPrimaryAmmoType();
    local secondary = weapon:GetSecondaryAmmoType();
    if (primary <= 0 and secondary <= 0) then VGNTK:ResetHEVPanels(); return end
    local clip = weapon:Clip1();
    local bullets1 = clip;
    local resv = LocalPlayer():GetAmmoCount(primary);
    local alt = LocalPlayer():GetAmmoCount(secondary);
    local altOnly = primary <= 0 and secondary > 0;

    -- Animate
    Animate(style == 1);

    local oldAlpha = surface.GetAlphaMultiplier();
    surface.SetAlphaMultiplier(oldAlpha * anim); -- Set alpha

    if (style <= 0) then
      DrawDefault(x, y, mode, weapon, primary, secondary, clip, bullets1, resv, alt, altOnly);
    elseif (style == 1) then
      VGNTK:DrawHEVAmmo(mode, weapon, primary, secondary, clip, bullets1, resv, alt, altOnly);
    else
      VGNTK:DrawClassicAmmo(x, y, mode, weapon, primary, secondary, clip, bullets1, resv, alt, altOnly);
    end

    surface.SetAlphaMultiplier(oldAlpha); -- Get back the old alpha
  end

end
