--[[
    Mahjong SEA
]]

Countdown = Class{}

function Countdown:init(time)

    self.seconds = time
    self.dt = 0

    self.visible = false

end

function Countdown:update(dt)

    if self.visible == true then

        self.dt = self.dt + dt
        if self.dt >= 1 then
            self.seconds = self.seconds - 1
            self.dt = 0
        end

    else

        self.seconds = -1

    end

end

function Countdown:render(input, discardedTile)

    self.discardedTile = discardedTile

    if self.visible == true and self.discardedTile ~= nil then

        -- menu translucent rounded rectangle
        love.graphics.setColor(1, 1, 1, 0.25)
        love.graphics.rectangle("fill", VIRTUAL_WIDTH * 0.35, VIRTUAL_HEIGHT * 0.35, VIRTUAL_WIDTH * 0.3, VIRTUAL_HEIGHT * 0.3, 5, 5) 

        love.graphics.setColor(189/255, 44/255, 32/255, 1)
        love.graphics.setFont(gFonts['medium'])

        if self.seconds >= 0 then
            love.graphics.printf(self.seconds, 0, VIRTUAL_HEIGHT * 0.58, VIRTUAL_WIDTH, "center")
        end

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf(input, 0, VIRTUAL_HEIGHT * 0.352, VIRTUAL_WIDTH, "center")

        playerchoiceGUI:render(input, self.discardedTile)

    end
    
end
