--[[------------------------------------------------------------------
  HALF-LIFE 2 STYLED AMMUNITION INDICATOR
  HEV style
]]--------------------------------------------------------------------

if CLIENT then

  -- Parameters
  local TIME = 4;
  local BLUR_SPEED_IN = 0.25;
  local BLUR_SPEED_OUT = 0.011;

  -- Variables
  local hBlink = 0;
  local hGlitch = 0;
  local hGTick = 0;
  local tick = 0;

  local hBlur = {
    ["clip"] = {doBlur = false, blur = 0},
    ["resv"] = {doBlur = false, blur = 0},
    ["alt"] = {doBlur = false, blur = 0}
  }; -- Half-Life 2 blur animation

  -- Internal function; animates the panels
  local function Animate()
    local clip = -1;
    local weapon = LocalPlayer():GetActiveWeapon();
    if (IsValid(weapon)) then
      local primary = weapon:GetPrimaryAmmoType();
      local secondary = weapon:GetSecondaryAmmoType();
      if (primary > 0) then
        if (weapon:Clip1() > -1) then
          clip = weapon:Clip1();
        else
          clip = LocalPlayer():GetAmmoCount(primary);
        end
      elseif (primary <= 0 and secondary > 0) then
        clip = LocalPlayer():GetAmmoCount(secondary);
      end
    end

    -- Blinking
    hBlink = Lerp(FrameTime() * 2.4, hBlink, 0);
    if (clip > 0 and VGNTK.IsAmmoLow) then
      if (hGTick > CurTime()) then
        hGlitch = math.random(0.1, 0.36);
      end
    else
      hGlitch = 0;
    end

    -- Blur
    if (tick < CurTime()) then
      for i, blur in pairs(hBlur) do
        if (blur.doBlur) then
          if (blur.blur < 1) then
            hBlur[i].blur = math.min(blur.blur + BLUR_SPEED_IN, 1);
          else
            hBlur[i].doBlur = false;
          end
        else
          hBlur[i].blur = math.max(blur.blur - BLUR_SPEED_OUT, 0);
        end
      end
      tick = CurTime() + 0.01;
    end
  end

  --[[------------------------------------------------------------------
    Triggers an ammo counter to blink
    @param {number} was a shot fired
  ]]--------------------------------------------------------------------
  function VGNTK:UpdateHEVCounter(counter, fired)
    if (fired) then hGTick = CurTime() + 0.5; end
    hBlur[counter].doBlur = true;
  end

  --[[------------------------------------------------------------------
    Resets HEV styled panels' animations
    @void
  ]]--------------------------------------------------------------------
  function VGNTK:ResetHEVPanels()
    hBlink = 1;
    time = CurTime() + TIME;
  end

  --[[------------------------------------------------------------------
    Returns a specific blur amount
    @param {string} blur
    @return {number} amount
  ]]--------------------------------------------------------------------
  function VGNTK:GetHEVBlur(blur)
    return hBlur[blur].blur;
  end

  --[[------------------------------------------------------------------
    Returns the HEV glitch amount
    @return {number} amount
  ]]--------------------------------------------------------------------
  function VGNTK:GetHEVGlitch()
    return hGlitch;
  end

  --[[------------------------------------------------------------------
    Draws the HEV styled ammunition indicator
    @param {number} mode
    @param {Weapon} weapon
    @param {number} primary ammo type
    @param {number} secondary ammo type
    @param {number} numeric clip amount
    @param {number} bullets amount
    @param {number} reserve ammo amount
    @param {number} alternate fire ammo amount
    @param {boolean} whether is alt ammo only
  ]]--------------------------------------------------------------------
  local BASE, SPACE, TRAY_SIZE = 27, 11, 50;
  function VGNTK:DrawHEVAmmo(mode, weapon, primary, secondary, clip, bullets1, resv, alt, altOnly)
    local a, b = math.Round(27 * VGNTK:GetScale()), 20 * VGNTK:GetScale();
    local bgCol = Color(VGNTK.HEV_COLOUR.r * hBlink, VGNTK.HEV_COLOUR.g * hBlink, VGNTK.HEV_COLOUR.b * hBlink, 70 + (100 * hBlink));
    local max = weapon:GetMaxClip1();

    -- Animate
    Animate();

    -- Secondary
    local x, y = 0, 0;
    local u, v = 0, 0;
    if (secondary > 0 and primary > 0) then
      u, v = (77 + (23 * math.max(math.floor(math.log10(alt)), 0))) * VGNTK:GetScale(), 57 * VGNTK:GetScale();
      x, y = ScrW() - a - u, ScrH() - b - v;
      draw.RoundedBox(7, x, y, u, v, bgCol);
      draw.SimpleText("ALT", "vgntk_label", x + (13 * VGNTK:GetScale()), y + v - (9 * VGNTK:GetScale()), VGNTK.HEV_COLOUR, nil, TEXT_ALIGN_BOTTOM);
      draw.SimpleText(alt, VGNTK.HL2_CLIP_FONT .. "_b", x + (43 * VGNTK:GetScale()), y + (3 * VGNTK:GetScale()), Color(VGNTK.HEV_COLOUR.r, VGNTK.HEV_COLOUR.g, VGNTK.HEV_COLOUR.b, 400 * hBlur["alt"].blur));
      draw.SimpleText(alt, VGNTK.HL2_CLIP_FONT, x + (43 * VGNTK:GetScale()), y + (3 * VGNTK:GetScale()), VGNTK.HEV_COLOUR);
    end

    -- Check if is reserve only
    if (primary <= 0 and secondary > 0) then
      clip = alt;
      bullets1 = alt;
      resv = -1;
    else
      if (clip <= -1) then
        clip = resv;
        bullets1 = clip;
        resv = -1;
      end
    end

    if (altOnly) then primary = secondary; end -- Change primary ammo type

    -- Resize and relocate HUD
    local w, h = 115, 57 * VGNTK:GetScale();
    local offset = 0;
    local clip0a = 2;
    local resv0a = 3;

    if (resv > -1) then
      if (mode <= 0) then
        clip = math.ceil(resv/max);
      elseif (mode == 1 or mode == 5) then
        resv = math.ceil(resv/max);
        resv0a = 2;
      elseif (mode == 3) then
        clip = resv;
        clip0a = 3;
      elseif (mode == 4 or mode == 7) then
        clip = clip + resv;
        clip0a = 3;
      end
    else
      max = clip;
      clip0a = 3;
    end

    local icon = VGNTK:GetAmmoIcon(game.GetAmmoName(primary));
    local clip0 = math.max(math.floor(math.log10(max) + 1), clip0a);
    local resv0 = math.max(math.floor(math.log10(resv) + 1), resv0a);
    local size1 = (clip0 * 18) + (5 * (clip0 - 1));
    local size2 = (resv0 * 9) + (4 * (resv0 - 1));
    local traySize = icon.w;

    if (mode <= 0) then
      w = BASE + icon.w - 10;
      if (resv > -1) then w = w + size1 + 10; end
    elseif ((mode >= 1 and mode <= 2) or (mode >= 5 and mode <= 6)) then
      w = BASE + size1;
      if (resv > -1) then w = w + SPACE + size2; end
      if (mode < 5) then w = w + icon.w; end
      offset = w - 16;
    else
      w = BASE + size1;
      if (mode >= 3 and mode <= 4) then w = w + icon.w; end
    end

    -- Draw primary
    w = math.floor(w * VGNTK:GetScale());
    x, y = ScrW() - a - w, ScrH() - b - h;
    if (secondary > 0 and primary > 0) then x = x - u - (13 * VGNTK:GetScale()); end
    draw.RoundedBox(7, x, y, w, h, bgCol);
    render.SetScissorRect(x, y, x + w, y + h, true);
      local colour = VGNTK:GetColour(true);
      if (mode < 5) then
        VGNTK:DrawBulletTray(x + ((3 + traySize) * VGNTK:GetScale()), y - 8 * VGNTK:GetScale(), primary, bullets1, 37 * VGNTK:GetScale(), colour, TEXT_ALIGN_RIGHT, nil, nil, nil, 1);
      else
        traySize = 0;
      end
      local blur = hBlur["clip"].blur;
      if (mode <= 0 or mode == 3) then blur = hBlur["resv"].blur; end
      local blurCol = Color(colour.r, colour.g, colour.b, 400 * blur * (1 - hGlitch));
      if (not (mode <= 0 and resv <= -1)) then
        draw.SimpleText(clip, VGNTK.HL2_CLIP_FONT .. "_b", x + math.Round((10 + traySize) * VGNTK:GetScale()), y + (3 * VGNTK:GetScale()), blurCol);
        draw.SimpleText(clip, VGNTK.HL2_CLIP_FONT, x + math.Round((10 + traySize) * VGNTK:GetScale()), y + (3 * VGNTK:GetScale()), colour);
      end -- Draw main number
      if (((mode > 0 and mode < 3) or (mode >= 5 and mode <= 6)) and resv > -1) then
        draw.SimpleText(resv, VGNTK.HL2_RESV_FONT, x + math.floor(offset * VGNTK:GetScale()), y + h - (8 * VGNTK:GetScale()), colour, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM);
      end -- Draw secondary number
    render.SetScissorRect(0, 0, 0, 0, false);
  end

end
