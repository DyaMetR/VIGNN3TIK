--[[------------------------------------------------------------------
  ARMOUR
  Vignette effects to reflect player's current suit battery level
]]--------------------------------------------------------------------

if CLIENT then

  -- Parameters
  local WIDTH, HEIGHT = 163, 41;
  local VIGNETTE_YELLOW = surface.GetTextureID("vighud/vignette_yellow");
  local VIGNETTE_BLUE = surface.GetTextureID("vighud/vignette_blue");
  local KEVLAR_ICON = Material("vighud/kevlar.png");
  local BATTERY_ICON = Material("vighud/battery.png");
  VGNTK.HEV_COLOUR = Color(255, 230, 10, 255);
  local ARMOUR_COLOUR = Color(0, 200, 255);
  local ARMOUR_ADD_COLOUR = Color(0, 133, 200);
  local ARMOUR_DMG_COLOUR = Color(215, 60, 10);
  local ARMOUR_BACKGROUND_COLOUR = Color(255, 255, 255, 6);
  local WHITE = Color(255, 255, 255);
  local SW, SH, SM = 9, 6, 5;
  local TIME = 4;
  local ARMOUR_DELAY = 1;
  local ARMOUR_SPEED = 2;

  -- Variables
  local lastap = 0;
  local apanim = 0;
  local maanim = 0;
  local nextap = 0;
  local new = 0;
  local aptime = 0;
  local apt = 0;
  local dmg = 0;
  local time = 0;
  local tick = 0;
  local armourFlash = false;

  local wasDead = false;

  -- Create scaled font
  surface.CreateFont( "vgntk_label", {
    font = "Verdana",
    size = math.Round(14 * VGNTK:GetScale()),
    weight = 1000,
    antialias = true
  });

  -- Internal function; animates the armour indicator
  local function Animate(armour, mode)
    -- Animate HEV monitor
    if (mode == 3 and armour > 0) then
      new = Lerp(FrameTime() * 2.4, new, 0);
    end

    -- Register as dead
    if (not LocalPlayer():Alive()) then wasDead = true; end

    -- Detect damage
    if lastap ~= armour then
			if lastap > armour then
				if armour > 0 and armour <= 20 and VGNTK:IsArmourVignetteEnabled() then
					apanim = 1; -- Activate effect
				elseif armour <= 0 and not wasDead and VGNTK:IsArmourDepleteFlashEnabled() then
					apt = 1;
					new = 1;
					maanim = 1;
				end -- Reset variables
        armourFlash = false;
      else
        if ((not armourFlash and armour >= 100) or armour >= 200) and VGNTK:IsArmourFullFlashEnabled() then
  				maanim = 1;
          armourFlash = true;
  			end -- Screen blink effect
			end -- trigger damage animation
      if (dmg == armour) then
        dmg = lastap;
      end -- update armour variant indicator
      time = CurTime() + ARMOUR_DELAY;
			aptime = CurTime() + TIME;
			lastap = armour;
      wasDead = false;
		end

    -- Fade in/out
    if (aptime > CurTime() or armour <= 20 or VGNTK:IsArmourAlwaysShown()) and armour > 0 then
			apt = Lerp(FrameTime() * 12, apt, 1);
		else
			apt = math.max(Lerp(FrameTime() * 8, apt, -0.02), 0);
		end

    -- Cool off
    apanim = math.max(Lerp(FrameTime(), apanim, -0.02), 0); -- Damage
    maanim = math.max(Lerp(FrameTime() * 3, maanim, -0.02), 0); -- 100%/0% effect

    -- Damage animation
    if (mode >= 1 and time < CurTime() and tick < CurTime()) then
      if (dmg > armour) then
        dmg = math.max(dmg - ARMOUR_SPEED, armour);
      elseif (dmg < armour) then
        dmg = math.min(dmg + ARMOUR_SPEED, armour);
      end
      tick = CurTime() + 0.01;
    end

    -- Display armour amount when pressed the key
    if (input.IsKeyDown(VGNTK:GetShowKey())) then
			aptime = CurTime() + TIME;
		end
  end

  -- Internal function; draws a aux power styled bar
  local function DrawBar(x, y, w, h, m, amount, value, col, a)
    -- Background
    for i=0, amount do
      draw.RoundedBox(0, x + math.Round((w + m) * VGNTK:GetScale()) * i, y, math.Round(w * VGNTK:GetScale()), math.Round(h * VGNTK:GetScale()), Color(col.r * 0.8, col.g * 0.8, col.b * 0.8, col.a * 0.4 * a));
    end

    -- Foreground
    if (value <= 0) then return; end
    for i=0, math.Round(value * amount) do
      draw.RoundedBox(0, x + math.Round((w + m) * VGNTK:GetScale()) * i, y, math.Round(w * VGNTK:GetScale()), math.Round(h * VGNTK:GetScale()), Color(col.r, col.g, col.b, col.a * a));
    end
  end

  -- Internal function; draws the HEV suit monitor
  local function DrawHEVMonitor(armour)
    draw.RoundedBox(6, 25 * VGNTK:GetScale(), ScrH() - (HEIGHT + 20) * VGNTK:GetScale(), WIDTH * VGNTK:GetScale(), HEIGHT * VGNTK:GetScale(), Color(VGNTK.HEV_COLOUR.r * new, VGNTK.HEV_COLOUR.g * new,VGNTK.HEV_COLOUR.b * new, (70 + 100 * new) * apt));
    draw.SimpleText("SUIT POWER", "vgntk_label", 38 * VGNTK:GetScale(), ScrH() - (HEIGHT + 15) * VGNTK:GetScale(), Color(VGNTK.HEV_COLOUR.r, VGNTK.HEV_COLOUR.g, VGNTK.HEV_COLOUR.b, VGNTK.HEV_COLOUR.a * apt));
    DrawBar(38 * VGNTK:GetScale(), ScrH() - (HEIGHT - 5) * VGNTK:GetScale(), SW, SH, SM, 9, armour * 0.01, VGNTK.HEV_COLOUR, apt);
  end

  -- Internal function; draws an icon representing the current armour level
  local function DrawArmourIcon(armour, mode, over100, damage)
    local w, h = 64 * VGNTK:GetScale(), 64 * VGNTK:GetScale();
    local x, y = (ScrW() * 0.2) - (32 * VGNTK:GetScale()), ScrH() - (20 * VGNTK:GetScale()) - h;
    if (VGNTK:IsArmourOnCorner()) then x = math.ceil(20 * VGNTK:GetScale()); end
    local alpha = 1;
    if (over100) then
      alpha = 0.5;
    end
    local a, d = armour * 0.01, damage * 0.01;
    local colour = ARMOUR_DMG_COLOUR;
    local aColour = VGNTK:GetArmourColour();
    local bright = VGNTK:GetArmourBackgroundBrightness();
    local bColour = Color(255 * bright, 255 * bright, 255 * bright, aColour.a * VGNTK:GetArmourBackgroundAlpha() * apt);

    if (armour > damage) then
      d = armour * 0.01;
      a = damage * 0.01;
      colour = ARMOUR_ADD_COLOUR;
    end -- detect if damage was taken

    aColour.a = aColour.a * apt * alpha;
    colour.a = aColour.a * 0.5 * alpha;

    render.PushFilterMag( TEXFILTER.ANISOTROPIC );
    render.PushFilterMin( TEXFILTER.ANISOTROPIC );

    if (mode == 1) then
      surface.SetMaterial(KEVLAR_ICON);
    else
      surface.SetMaterial(BATTERY_ICON);
    end
    -- Draw background
    render.SetScissorRect(x, y, x + w, y + h * (1 - a), true);
    surface.SetDrawColor(bColour);
    surface.DrawTexturedRect(x, y, w, h);
    -- Draw difference
    render.SetScissorRect(x, y + (h * math.abs(1 - d)), x + w, y + (h * (1 - a)), true);
    surface.SetDrawColor(colour);
    surface.DrawTexturedRect(x, y, w, h);
    -- Draw current level
    render.SetScissorRect(x, y + (h * (1 - a)), x + w, y + h, true);
    surface.SetDrawColor(aColour);
    surface.DrawTexturedRect(x, y, w, h);
    render.SetScissorRect(0, 0, 0, 0, false);

    render.PopFilterMag();
    render.PopFilterMin();
  end

  -- Internal function; draws the vignette and blinking effects
  local function DrawArmour(mode)
    local texture = VIGNETTE_BLUE;
    local colour = ARMOUR_COLOUR;

    if (mode == 3) then
      texture = VIGNETTE_YELLOW;
      colour = VGNTK.HEV_COLOUR;
    end

    -- Draw vignette
    surface.SetDrawColor(WHITE);
    surface.SetTexture(texture)
    surface.DrawTexturedRect(0 - (ScrW() * (1-apanim)), 0 - (ScrH() * (1-apanim)), ScrW() * (1 + 2 * (1-apanim)), ScrH() * (1 + 2 * (1-apanim)));

    -- Draw full screen flash
    draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(colour.r, colour.g, colour.b, 30 * maanim));
  end

  --[[------------------------------------------------------------------
    Draws the armour overlay
    @param {boolean} HEV mode
  ]]--------------------------------------------------------------------
  function VGNTK:DrawArmourOverlay(mode)
    if (not VGNTK:ShouldDrawHealth()) then return end
    local armour = LocalPlayer():Armor();
    Animate(armour, mode);
    DrawArmour(mode);
    if (mode >= 1 and mode < 3) then
      DrawArmourIcon(math.min(armour, 100), mode, armour > 100, math.min(dmg, 100));
      if (armour > 100) then DrawArmourIcon(math.min(armour - 100, 100), mode, nil, dmg - 100); end
    elseif (mode >= 3) then
      DrawHEVMonitor(armour);
    end
  end

end
