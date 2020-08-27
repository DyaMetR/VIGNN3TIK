--[[-------------
    VIGNN3TIK
 Version 2.2.2
    27/08/20

By DyaMetR
]]---------------

VGNTK = {};
VGNTK.Version = "2.2.2";

--[[------------------------------------------------------------------
  Correctly includes a file
  @param {string} file
]]--------------------------------------------------------------------
function VGNTK:IncludeFile(file)
  if SERVER then
    include(file);
    AddCSLuaFile(file);
  end
  if CLIENT then
    include(file);
  end
end

VGNTK:IncludeFile("vignnetik/core.lua");
