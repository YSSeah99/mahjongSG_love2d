--[[
    Mahjong

    Util Class
]]


--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.
]]
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function GenerateBits(cuts)
    local tracks = cuts

    local audiosheet = {}

    for id = 1, tracks do
        audiosheet[id] = love.audio.newSource('sounds/discardTileNames/' .. tostring(id) .. '.ogg', 'static')
    end

    return audiosheet
end

function playDiscardTile(playerTrash)

    gSounds['discardedTileNames'][playerTrash[#playerTrash].id]:play()
        Timer.after(gSounds['discardedTileNames'][playerTrash[#playerTrash].id]:getDuration(), function()
            gSounds['discardedTileNames'][playerTrash[#playerTrash].id]:stop() end)

end

-- for dumping values of table (printing ONLY)
function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
    end
    return s .. '} '
    else
        return tostring(o)
    end
end