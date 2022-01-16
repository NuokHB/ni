-------------------
-- Player functions for ni
local ni = ...

ni.player = {}

-- Localized functions
-- TODO: update with actual localized, or remove if none
local something

----------
-- Moves the player to the token or coordinates.
-- 
-- Parameters:
-- - **target** `token|guid`
-- 
-- Or
-- - **x** `number`
-- - **y** `number`
-- - **z** `number`
-- @param ...
function ni.player.move_to(...)
   return ni.backend.MoveTo(...)
end