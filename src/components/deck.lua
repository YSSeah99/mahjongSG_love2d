--[[
    Mahjong SEA
    Includes Hands and FlowerWall - BackEnd

    Does the checks
]]

Deck = Class{}

function Deck:init(hands, flowerWall, areas)

    self.hands = hands
    self.handsCount = 13
    
    self.flowerWall = flowerWall
    self.areas = areas

    self.needtoDraw = false
    self.canPong = false
    self.canKang = false

end

function Deck:update(dt)

    self:checkFlower()
    self:sortDeck()

    -- draw tile
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

    end 
    
end

function Deck:render()
    
    playerHandGUI(self.hands, self.flowerWall):render()

end

function Deck:sortDeck()
    
    if #self.hands == self.handsCount then
        table.sort(self.hands, function (t1, t2) return t1.id < t2.id end)
        -- assign pos in hands after it is sorted
        for pos = 1, #self.hands do
            self.hands[pos].position = pos
        end
    end

end

function Deck:checkFlower()

    -- assign any bonus tile to playerFlowerHand
    local tilesToRemove = {}
    for pos = 1, #self.hands do
        if self.hands[pos].id >= 35 and self.hands[pos].id <= 46 then
            self.hands[pos].area = self.areas[2]
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

-- user decides to draw
function Deck:drawTile(draws)

    while (#self.hands ~= self.handsCount + 1) do
        gSounds['tile-draw']:play()
        draws[1].area = self.areas[1]
        draws[1].position = 14
        table.insert(self.hands, draws[1])
        table.remove(draws, 1)
        self:checkFlower()
    end

end

-- user decides to discard
function Deck:discardTile(posi, trash)

    if (#self.hands == self.handsCount + 1) then

        gSounds['tile-discard']:play()

        self.hands[posi].area = self.areas[3]
        table.insert(trash, self.hands[posi])
        self.hands[posi].position = #trash
        
        -- re-adjust playerHand
        table.remove(self.hands, posi)

        self:sortDeck()

    end

end

function Deck:checkPongKang(discardedTile)

    if (#self.hands == 13) then
        count = 0
        for i = 1, #self.hands do
            if (self.hands[i].id == discardedTile.id) then 
                count = count + 1 
            end
        end

        if count == 2 then self.canPong = true elseif count == 1 then self.canKang = true end -- to change count back to 2
            
    end

end