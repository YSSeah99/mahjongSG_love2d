--[[
    Mahjong SEA
    AIBehaviour - BackEnd (BRAIN)
    For the AI to decide what to discard & what state to transit to
]]

AIBehaviour = Class{}

function AIBehaviour:init(AIposition, AIowndeck, AIowntrash, decks, trashs)

    self.AIposition = AIposition
    if self.AIposition == 'right' then self.drawStatetoGO = 'oppoAIDraw' 
    elseif self.AIposition == 'oppo' then self.drawStatetoGO = 'leftAIDraw' 
    elseif self.AIposition == 'left' then self.drawStatetoGO = 'playerDraw' end
        
    self.AIdeck = AIowndeck.hands -- own hands
    self.AIownflowerWall = AIowndeck.flowerWall -- own flowerWall
    self.AIowntrash = AIowntrash -- own trash

    self.playerDeck = decks[1]
    self.trashs = trashs

    -- AI Untouchable Tiles -> All 4 player's flowerWall and trash

    -- string for drawState
    

end

function AIBehaviour:goDrawState(tileColor, jokerstring, drawWall, decks, discardedTiles)

    gStateMachine:change(self.drawStatetoGO,
    {
        tileColor = tileColor,
        jokerstring = jokerstring,
        drawWall = drawWall,
        decks = decks,
        discardedTiles = discardedTiles
    })

end

function AIBehaviour:determineTiletoDiscard()

    -- AI to determine what to discard (TEMP CODE)
    local x = math.random(1, 14)

    return x

end


function AIBehaviour:update(dt)

end

function AIBehaviour:render()
    

end

