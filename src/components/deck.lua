--[[
    Mahjong SEA
    Includes Hands and FlowerWall - BackEnd
]]

Deck = Class{}

function Deck:init(hands, flowerWall)

    self.hands = hands
    self.flowerWall = flowerWall

    self.needtoDraw = false

end

function Deck:update(dt)

    self:flowerCheck()

    if #self.hands == 13 then
        table.sort(self.hands, function (t1, t2) return t1.id < t2.id end)
        -- assign pos in hands after it is sorted
        for pos = 1, #self.hands do
            self.hands[pos].position = pos
        end
    end

end

function Deck:render()
    
    playerHandGUI(self.hands, self.flowerWall):render()

end

function Deck:flowerCheck()

    -- assign any bonus tile to playerFlowerHand
    local tilesToRemove = {}
    for pos = 1, #self.hands do
        if self.hands[pos].id >= 35 and self.hands[pos].id <= 46 then
            self.hands[pos].area = 2
            table.insert(self.flowerWall, self.hands[pos])
            table.insert(tilesToRemove, pos)
            self.hands[pos].position = #self.flowerWall
        end
    end
    if tilesToRemove ~= nil then
        for pos = 1, #tilesToRemove do
            table.remove(self.hands, tilesToRemove[#tilesToRemove- pos + 1])
        end
    end

end

function Deck:drawTile(draws)

    while (#self.hands ~= 14) do
        gSounds['tile-draw']:play()
        draws[1].area = 1
        draws[1].position = 14
        table.insert(self.hands, draws[1])
        table.remove(draws, 1)
    end

end