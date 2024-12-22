--[[
    Mahjong SEA
]]

Countdown = Class{}

function Countdown:init(time, visible)

    self.seconds = time
    self.dt = 0

    self.visible = visible

end

function Countdown:update(dt)

    self.dt = self.dt + dt
    if self.dt >= 1 then
        self.seconds = self.seconds - 1
        self.dt = 0
    end

end

function Countdown:render()

    if self.visible then

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setFont(gFonts['medium'])

        if self.seconds >= 0 then
            love.graphics.printf(self.seconds, VIRTUAL_WIDTH * 0.5, VIRTUAL_HEIGHT * 0.5, VIRTUAL_WIDTH * 0.5, "left")
        else
            love.graphics.printf("Yeet", VIRTUAL_WIDTH * 0.5, VIRTUAL_HEIGHT * 0.5, VIRTUAL_WIDTH * 0.5, "left")
        end

    end
    
end
