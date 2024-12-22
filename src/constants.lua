--[[
    Mahjong

    -- constants --
]]

VIRTUAL_WIDTH = 576 -- 382 x 216
VIRTUAL_HEIGHT = 324

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

TILE_WIDTH = 28.5
TILE_HEIGHT = 36

PATTERN_WIDTH = 22.5
PATTERN_HEIGHT = 30

DICE_WIDTH = 20
DICE_HEIGHT = 20

TOP_PANEL_WIDTH = VIRTUAL_WIDTH * 0.175
TOP_PANEL_HEIGHT = VIRTUAL_HEIGHT * 0.05

BOTTOM_PANEL_WIDTH = VIRTUAL_WIDTH * 0.1
BOTTOM_PANEL_HEIGHT = VIRTUAL_HEIGHT * 0.05

-- generate HandPosn 
HandPosn = {}
for i = 0, 12 do
    table.insert(HandPosn, VIRTUAL_WIDTH * 0.12 + (i * TILE_WIDTH))
end
table.insert(HandPosn, VIRTUAL_WIDTH * 0.12 + (14 * TILE_WIDTH))

-- generate KangPosn
KangPosn = {}
local halfDistance = TILE_WIDTH / 2
for i = 5, 8 do
    table.insert(KangPosn, VIRTUAL_WIDTH * 0.12 + (i * TILE_WIDTH) + halfDistance)
end

-- generate bottomPanelPosn
bottomPanelPosn = {}
local horizontalCounter = VIRTUAL_WIDTH * 0.5 / 6
for i = 1, 5 do
    table.insert(bottomPanelPosn, (i * horizontalCounter + (i-1) * BOTTOM_PANEL_WIDTH))
end