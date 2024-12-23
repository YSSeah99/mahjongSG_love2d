--[[
    Mahjong
]]

AIHandGUI = Class{}

function AIHandGUI:init(rightHand, oppoHand, leftHand)

    self.righthand = rightHand
    self.oppohand = oppoHand
    self.lefthand = leftHand

end

function AIHandGUI:update(dt)


end

function AIHandGUI:render()

    -- to eventually update with graphics

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gFonts['small'])

    -- Left AI
    love.graphics.printf(#self.lefthand, VIRTUAL_WIDTH * 0.2, VIRTUAL_HEIGHT * 0.5, VIRTUAL_WIDTH * 0.9, "left")

    -- Oppo AI
    love.graphics.printf(#self.oppohand, VIRTUAL_WIDTH * 0.5, VIRTUAL_HEIGHT * 0.275, VIRTUAL_WIDTH * 0.9, "left")

    -- Right AI
    love.graphics.printf(#self.righthand, VIRTUAL_WIDTH * 0.8, VIRTUAL_HEIGHT * 0.5, VIRTUAL_WIDTH * 0.9, "left")

    love.graphics.setColor(1, 1, 1, 1)

end