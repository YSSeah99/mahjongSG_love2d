--[[
    Mahjong
]]

playerHandGUI = Class{}

function playerHandGUI:init(hand, flowerWall, shift)

    self.hand = hand
    self.flowerWall = flowerWall

    self.shift = shift

end

function playerHandGUI:update(dt)


end

function playerHandGUI:render()

    --print(dump(self.hand))
    for p = 1, #self.hand do
        self.hand[p].position = p + self.shift
        self.hand[p]:render()
    end

    if self.flowerWall ~= nil then
        for q = 1, #self.flowerWall do
            self.flowerWall[#self.flowerWall - q + 1]:render()
        end
    end

end