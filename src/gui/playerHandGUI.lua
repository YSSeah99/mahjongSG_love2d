--[[
    Mahjong
]]

playerHandGUI = Class{}

function playerHandGUI:init(hand, flowerWall)

    self.hand = hand
    self.flowerWall = flowerWall

end

function playerHandGUI:update(dt)


end

function playerHandGUI:render()

    -- print(dump(self.hand))
    for p = 1, #self.hand do
        self.hand[p]:render()
    end

    if self.flowerWall ~= nil then
        for q = 1, #self.flowerWall do
            self.flowerWall[q]:render()
        end
    end

    --print(dump(self.flowerWall))

end