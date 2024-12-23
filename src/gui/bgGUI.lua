--[[
    Mahjong
]]

bgGUI = Class{}

function bgGUI:init()

end

function bgGUI:update(dt)

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

end

function bgGUI:render()

    -- background
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
    VIRTUAL_WIDTH / gTextures['background']:getWidth(),
    VIRTUAL_HEIGHT / gTextures['background']:getHeight())

end