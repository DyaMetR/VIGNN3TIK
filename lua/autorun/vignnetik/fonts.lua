
if CLIENT then

  -- Parameters
  VGNTK.CLIP_FONT = "vgntk_ammo_clip";
  VGNTK.RESV_FONT = "vgntk_ammo_resv";
  VGNTK.ICON_FONT = "vgntk_ammo_icon";
  VGNTK.ICON_FONT_DM = "vgntk_ammo_icon_dm";
  VGNTK.HL2_CLIP_FONT = "vgntk_hl2_clip";
  VGNTK.HL2_RESV_FONT = "vgntk_hl2_resv";
  VGNTK.HL2_ICON_FONT = "vgntk_hl2_icon";
  VGNTK.HL2_ICON_FONT_DM = "vgntk_hl2_icon_dm";
  VGNTK.CLASSIC_ICON_FONT = "vgntk_classic_icon";
  VGNTK.CLASSIC_ICON_FONT_DM = "vgntk_classic_icon_dm";
  VGNTK.CLASSIC_CLIP_FONT = "vgntk_classic_clip";
  VGNTK.CLASSIC_RESV_FONT = "vgntk_classic_resv";

  -- Creates HEV styled fonts
  local function CreateHL2Fonts()
    surface.CreateFont( VGNTK.HL2_CLIP_FONT .. "_b", {
      font = "HalfLife2",
      size = math.Round(50 * VGNTK:GetScale()),
      weight = 0,
      antialias = true,
      additive = false,
      scanlines = 3,
      blursize = 10
    });
    surface.CreateFont( VGNTK.HL2_CLIP_FONT, {
      font = "HalfLife2",
      size = math.Round(50 * VGNTK:GetScale()),
      weight = 0,
      antialias = true,
      additive = true
    });
    surface.CreateFont( VGNTK.HL2_RESV_FONT, {
      font = "HalfLife2",
      size = math.Round(24 * VGNTK:GetScale()),
      weight = 1000,
      antialias = true,
      additive = true
    });
    surface.CreateFont( VGNTK.HL2_ICON_FONT, {
      font = "HalfLife2",
      size = math.Round(50 * VGNTK:GetScale()),
      weight = 0,
      antialias = true,
      additive = true
    });
    surface.CreateFont( VGNTK.HL2_ICON_FONT .. "_b", {
      font = "HalfLife2",
      size = math.Round(50 * VGNTK:GetScale()),
      weight = 0,
      blursize = 8,
      scanlines = 3,
      antialias = true,
      additive = true
    });
    surface.CreateFont( VGNTK.HL2_ICON_FONT_DM, {
      font = "HL2MP",
      size = math.Round(50 * VGNTK:GetScale()),
      weight = 0,
      antialias = true,
      additive = true
    });
    surface.CreateFont( VGNTK.HL2_ICON_FONT_DM .. "_b", {
      font = "HL2MP",
      size = math.Round(50 * VGNTK:GetScale()),
      weight = 0,
      blursize = 8,
      scanlines = 3,
      antialias = true,
      additive = true
    });
  end

  -- Internal function; creates a font with it's bright variant
  local function CreateFont(font, family, size, weight, blursize, scanlines)
    weight = weight or 0;
    blursize = blursize or 4;
    scanlines = scanlines or 0;
    surface.CreateFont( font, {
      font = family,
      size = math.Round(size * VGNTK:GetScale()),
      weight = weight,
      antialias = true
    });
    surface.CreateFont( font .. "_b", {
      font = family,
      size = math.Round(size * VGNTK:GetScale()),
      weight = weight,
      antialias = true,
      blursize = blursize,
      scanlines = scanlines
    });
  end

  -- Internal function; regenerates primary fonts
  local function GenerateFonts()
    CreateFont(VGNTK.CLIP_FONT, VGNTK:GetPrimaryFontFamily(), 40);
    CreateFont(VGNTK.RESV_FONT, VGNTK:GetSecondaryFontFamily(), 30);
  end

  -- Create fonts
  GenerateFonts();
  CreateFont(VGNTK.ICON_FONT, "HalfLife2", 50);
  CreateFont(VGNTK.ICON_FONT_DM, "HL2MP", 50);
  CreateHL2Fonts();
  CreateFont(VGNTK.CLASSIC_ICON_FONT, "HalfLife2", 100);
  CreateFont(VGNTK.CLASSIC_CLIP_FONT, "Roboto", 60, 500);
  CreateFont(VGNTK.CLASSIC_RESV_FONT, "Roboto", 45, 500);
  CreateFont(VGNTK.CLASSIC_ICON_FONT_DM, "HL2MP", 100);

  -- Add callback for convars to regenerate fonts
  cvars.AddChangeCallback("vgntk_font1", function() GenerateFonts(); end);
  cvars.AddChangeCallback("vgntk_font2", function() GenerateFonts(); end);

end
