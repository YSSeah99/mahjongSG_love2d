--[[
    Mahjong SEA
]]

Set = Class{}

function Set:init(jokerTrue, tile_colour)

    self.tile_colour_back = tile_colour
    self.tile_colour_front = self.tile_colour_back - 6

    self:initialiseDeck()

end

function Set:initialiseDeck()
    
    self.deck = {}
    local suits = {"dots", "bamboo", "characters"}
    local winds = {"east", "south", "west", "north"}
    local dragons = {"red", "green", "white"}
    local flowers = {"plum", "orchid", "chrysanthemum", "bamboo"}
    local seasons = {"spring", "summer", "autumn", "winter"}
    local animals = {"cat", "mouse", "rooster", "worm"}

    -- generate all the suits and honours (4 times)
    for times = 1, 4 do

        -- for the suits
        for suitTypes = 1, 3 do
            -- generate for all the numbers from 1 to 9
            for number = 1, 9 do
                local tile = Tile {
                    id = (suitTypes - 1) * 9 + number,
                    area = 0,
                    tile_colour = {self.tile_colour_front, self.tile_colour_back},
                    class = "suits",
                    suit = suits[suitTypes],
                    number = number
                }
                table.insert(self.deck, tile)
            end
        end

        -- for the winds
        for windTypes = 1, 4 do
            local tile = Tile {
                id = 27 + windTypes,
                area = 0,
                tile_colour = {self.tile_colour_front, self.tile_colour_back},
                class = "honours",
                type = winds[windTypes],
                windNo = windTypes
            }
            table.insert(self.deck, tile)
        end

        -- for the dragons
        for dragonTypes = 1, 3 do
            local tile = Tile {
                id = 31 + dragonTypes,
                area = 0,
                tile_colour = {self.tile_colour_front, self.tile_colour_back},
                class = "honours",
                type = dragons[dragonTypes]
            }
            table.insert(self.deck, tile)
        end
    end

    -- generate all the bonuses

    -- for the flowers
    for flowersNo = 1, 4 do
        local tile = Tile {
            id = 34 + flowersNo,
            area = 0,
            tile_colour = {self.tile_colour_front, self.tile_colour_back},
            class = "bonus",
            type = flowers[flowersNo],
            number = flowersNo
        }
        table.insert(self.deck, tile)
    end

    -- for the seasons
    for seasonsNo = 1, 4 do
        local tile = Tile {
            id = 38 + seasonsNo,
            area = 0,
            tile_colour = {self.tile_colour_front, self.tile_colour_back},
            class = "bonus",
            type = seasons[seasonsNo],
            number = seasonsNo
        }
        table.insert(self.deck, tile)
    end

    -- for the animals
    for animalPairNo = 1, 4 do
        local tile = Tile {
            id = 42 + animalPairNo,
            area = 0,
            tile_colour = {self.tile_colour_front, self.tile_colour_back},
            class = "bonus",
            animal = animals[animalPairNo],
            animalPair = math.ceil(animalPairNo / 2)
        }
        table.insert(self.deck, tile)
    end

    if jokerTrue then
        for times = 1, 4 do
            local tile = Tile {
                id = 47,
                area = 0,
                tile_colour = {self.tile_colour_front, self.tile_colour_back},
                class = "bonus",
                type = "joker"
            }
            table.insert(self.deck, tile)
        end
    end

    local sortedDeck = {}

    for i, tile in ipairs(self.deck) do
        local pos = math.random(1, #sortedDeck+1)
        table.insert(sortedDeck, pos, tile)
    end

    self.deck = sortedDeck

end

function Set:deal()

    local handOne = {} -- dealer hand
    local handTwo = {}
    local handThree = {}
    local handFour = {}
    local drawWall = {}

    -- gives everyone 13 tile

    for pos = 1, 13 do
        table.insert(handOne, self.deck[pos])
        self.deck[pos].area = 1
    end

    for pos = 14, 26 do
        table.insert(handTwo, self.deck[pos])
        self.deck[pos].area = 4
    end

    for pos = 27, 39 do
        table.insert(handThree, self.deck[pos])
        self.deck[pos].area = 7
    end

    for pos = 40, 52 do
        table.insert(handFour, self.deck[pos])
        self.deck[pos].area = 10
    end

    for pos = 53, #self.deck do
        table.insert(drawWall, self.deck[pos])
    end

    return {handOne, handTwo, handThree, handFour}, drawWall

end

function Set:update(dt) 

end

function Set:render() 

    for p = 1, #self.deck do
        self.deck[p]:render()
    end

end

function Set:flowerCheck(handDeck) -- return #handDeck and index or false?

    local flowerWall = {}
    local toBeRemoved = {}
    for i = 1, #handDeck do
        --if self.playerHand[i] ~= nil then
        if handDeck[i].id >= 35 and handDeck[i].id <= 46 then -- if flower or seasons or animals
            table.insert(flowerWall, handDeck[i])              -- insert to flowerwall
            table.insert(toBeRemoved, i)
        end
    end
    if #toBeRemoved ~= 0 then
        for i = 1, #toBeRemoved do
            table.remove(handDeck, toBeRemoved[i])
        end
    end

    --print(#handDeck, #flowerWall)

    return handDeck, flowerWall

end