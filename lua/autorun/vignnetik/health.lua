--[[------------------------------------------------------------------
  HEALTH
  Vignette effects to reflect player's current health level
]]--------------------------------------------------------------------

if CLIENT then

  -- Parameters
  local WHITE = Color(255, 255, 255);
  local BLACK_VIGNETTE = surface.GetTextureID("vighud/vignette");
  local MAROON_VIGNETTE = Material("vighud/vignette_maroon.png");
  local RED_VIGNETTE = Material("vighud/vignette_blink.png");
  local PAIN_VIGNETTE = surface.GetTextureID("vighud/vignette_red");
  local CRIT_COLOUR = Color(255, 100, 100, 100);

  -- Variables
	local hpanim = 0;
	local critanim = 0;

	local lasthp = 100;
	local accum = 0;
	local dcanim = 0;
	local time = 0;

	local nextblink = 0;
	local blink = 0;
	local blinked = false;

	local dmg = 0;

	local heal = 0;
	local nextheal = 0;

  local wasDead = false;

  -- Internal function; animates the overlay
  local function Animate(health, isPainEnabled)
    critanim = math.max(Lerp(FrameTime() * 10, critanim, math.Clamp(health - 10,0,10) / 10), 0);

    -- Register as dead
    if (not LocalPlayer():Alive()) then wasDead = true; end

		-- Damage/Heal timers
		if lasthp ~= health then
			if lasthp > health then
        if (health <= 50) then
				  dmg = 1;
        end
				accum = accum + (lasthp - health);
				time = CurTime() + 3 + 3 * (1 - (health / 100));
			else
				if health >= LocalPlayer():GetMaxHealth() then
          if not wasDead then
  					time = 0;
            heal = 1;
          else
            accum = 0;
            hpanim = 0;
            critanim = 0;
            dcanim = 0;
            blink = 0;
            wasDead = false;
  				end
        end
			end
			lasthp = health;
		end

		-- Pain effect
		if (time > CurTime() and isPainEnabled) or (not isPainEnabled and health <= 20) then
      if (not isPainEnabled) then accum = 20; end
			dcanim = Lerp(FrameTime() * 8, dcanim, math.min(accum, 15) / 15);
			if accum >= 20 or not isPainEnabled then
				if blinked then
					if blink > 0.01 then
						blink = Lerp(FrameTime() * 10, blink, 0);
					else
						blinked = false;
            blink = 0;
					end
				else
					if blink < 0.99 then
						blink = Lerp(FrameTime() * 10, blink, 1);
					else
						blinked = true;
					end
				end
			end
		else
      -- Cool off
			dcanim = math.max(Lerp(FrameTime() * 2, dcanim, -0.02), 0);
      -- Reset blink animation
			blink = math.max(Lerp(FrameTime() * 20, blink, -0.02), 0);
      -- Reset accumulated damage
			accum = 0;
		end

    -- Move black vignette based on pain
		hpanim = math.max(Lerp(FrameTime() * 10, hpanim, (math.Clamp(health - 20,0,40) / 40) - dcanim), 0);

    -- Low health pain
    dmg = math.max(Lerp(FrameTime() * 1, dmg, -0.02), 0);

    -- Healed to 100%
    if heal > 0 then
			if nextheal < CurTime() then
				heal = math.max(heal - 0.03, 0);
				nextheal = CurTime() + 0.01;
			end
		end
  end

  -- Internal function; draws black vignette
  local function DrawHealth(health, isPainEnabled)
    -- Draw black vignette
    if hpanim < 0.9 then
			surface.SetDrawColor(WHITE);
			surface.SetTexture(BLACK_VIGNETTE);
			surface.DrawTexturedRect(0 - (ScrW() * hpanim), 0 - (ScrH() * hpanim), ScrW() * (1 + 2 * hpanim), ScrH() * (1 + 2 * hpanim));
		end

    -- Draw maroon vignette
    if critanim < 0.9 and isPainEnabled then
      surface.SetDrawColor(CRIT_COLOUR);
      surface.SetMaterial(MAROON_VIGNETTE);
      surface.DrawTexturedRect(0 - (ScrW() * (0.1 + (0.9 * critanim))), 0 - (ScrH() * (0.1 + (0.9 * critanim))), ScrW() * (1.2 + (1.8 * critanim)), ScrH() * (1.5 + (1.5 * critanim)));
    end

    -- Healing effect
    if (heal > 0 and VGNTK:IsHealthFlashEnabled()) then
      draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 255, 0, 30 * heal));
    end
  end

  -- Internal function; draws the red blinking vignette
  local function DrawPain(health, isPainEnabled)
    -- Extreme pain effect
    if blink > 0 then
			surface.SetDrawColor(Color(255, 255, 255, 255 * blink));
			surface.SetMaterial(RED_VIGNETTE);
			surface.DrawTexturedRect(0 - (ScrW() * dcanim), 0 - (ScrH() * dcanim), ScrW() * (1 + 2 * dcanim), ScrH() * (1 + 2 * dcanim));
		end

    -- Low health pain effect
    if dmg > 0.01 and isPainEnabled then
      surface.SetDrawColor(WHITE)
      surface.SetTexture(PAIN_VIGNETTE)
      surface.DrawTexturedRect(0 - (ScrW() * (1 - dmg)), 0 - (ScrH() * (1 - dmg)), ScrW()*(1 + 2 * (1 - dmg)), ScrH() * (1 + 2 * (1 - dmg)));
    end
  end

  --[[------------------------------------------------------------------
    Draws the health overlay
    @param {boolean} pain effect as health
  ]]--------------------------------------------------------------------
  function VGNTK:DrawHealthOverlay(isPainEnabled)
    if (not VGNTK:ShouldDrawHealth()) then return end
    local health = LocalPlayer():Health();
    Animate(health, isPainEnabled);
    if (not LocalPlayer():Alive()) then return end
    DrawHealth(health, isPainEnabled);
    DrawPain(health, isPainEnabled);
  end

  -- Render greyscaling
  local tab = {
  	["$pp_colour_addr"] = 0,
  	["$pp_colour_addg"] = 0,
  	["$pp_colour_addb"] = 0,
  	["$pp_colour_brightness"] = 0,
  	["$pp_colour_contrast"] = 1,
  	["$pp_colour_colour"] = 1,
  	["$pp_colour_mulr"] = 0,
  	["$pp_colour_mulg"] = 0,
  	["$pp_colour_mulb"] = 0
  };

  hook.Add("RenderScreenspaceEffects", "vgntk_greyscale", function()
    local weapon = LocalPlayer():GetActiveWeapon();
    if (not VGNTK:IsEnabled() or not VGNTK:ShouldDrawHealth() or not LocalPlayer():Alive() or (IsValid(weapon) and weapon:GetClass() == "gmod_camera")) then return end
    local mode = VGNTK:GetGreyscaleMode();
    if (mode <= 0) then return end
    if (mode == 1) then
      tab["$pp_colour_colour"] = hpanim;
    elseif (mode == 2) then
      tab["$pp_colour_colour"] = math.Clamp((LocalPlayer():Health() - 20) / 40, 0, 1);
    elseif (mode >= 3) then
      tab["$pp_colour_colour"] = 1 - dcanim;
    end
    DrawColorModify( tab );
  end);

end
