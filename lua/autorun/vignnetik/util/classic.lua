--[[------------------------------------------------------------------
  CLASSIC AMMUNITION INDICATOR
  Classic style
]]--------------------------------------------------------------------

if CLIENT then

  --[[------------------------------------------------------------------
    Draws the classic style ammunition display
    @param {number} x
    @param {number} y
    @param {number} mode
    @param {Weapon} weapon
    @param {number} primary ammo type
    @param {number} secondary ammo type
    @param {number} numeric clip amount
    @param {number} bullet amount
    @param {number} reserve ammo
    @param {number} alternate fire ammo count
    @param {boolean} is the ammo displaying only alt ammo
  ]]--------------------------------------------------------------------
  function VGNTK:DrawClassicAmmo(x, y, mode, weapon, primary, secondary, clip, bullets1, resv, alt, altOnly)
    local icon = VGNTK:GetAmmoIcon(game.GetAmmoName(primary));
    y = y - (((icon.h * 8) - 65) * VGNTK:GetScale());
    local colour = VGNTK:GetColour();

    if (altOnly) then
      resv = alt;
    end -- replace reserve with alt in case of alt being the only ammo type

    if (mode <= 1 or (clip <= -1 and mode < 2) or altOnly) then
      if (clip > -1 and not altOnly) then
        resv = "x" .. math.ceil(resv / weapon:GetMaxClip1());
      else
        resv = "x" .. resv;
      end
    end -- get reserve ammo label

    -- Draw primary
    draw.SimpleText(resv, VGNTK.CLASSIC_RESV_FONT .. "_b", x, y, Color(colour.r, colour.g, colour.b, colour.a * 0.1), TEXT_ALIGN_LEFT);
    draw.SimpleText(resv, VGNTK.CLASSIC_RESV_FONT, x, y, colour, TEXT_ALIGN_LEFT);
    if (clip > -1 and not altOnly) then
      if (mode == 0 or mode == 2) then
        VGNTK:DrawBulletTray(x, y - (5 * VGNTK:GetScale()), primary, bullets1, (icon.h * 8) * VGNTK:GetScale(), colour, TEXT_ALIGN_RIGHT, nil, nil, nil, 2);
      else
        draw.SimpleText(clip, VGNTK.CLASSIC_CLIP_FONT .. "_b", x - (5 * VGNTK:GetScale()), y + (VGNTK:GetScale() * 4), Color(colour.r, colour.g, colour.b, colour.a * 0.1), TEXT_ALIGN_RIGHT);
        draw.SimpleText(clip, VGNTK.CLASSIC_CLIP_FONT, x - (5 * VGNTK:GetScale()), y + (VGNTK:GetScale() * 4), colour, TEXT_ALIGN_RIGHT);
      end
    end

    -- Draw secondary
    if (primary < 0 or secondary < 0) then return end
    colour = VGNTK:GetMiscColour();
    draw.SimpleText("x" .. alt, VGNTK.CLASSIC_RESV_FONT .. "_b", x, y + (33 * VGNTK:GetScale()), Color(colour.r, colour.g, colour.b, colour.a * 0.1), TEXT_ALIGN_LEFT);
    draw.SimpleText("x" .. alt, VGNTK.CLASSIC_RESV_FONT, x, y + (33 * VGNTK:GetScale()), colour, TEXT_ALIGN_LEFT);
  end

end
