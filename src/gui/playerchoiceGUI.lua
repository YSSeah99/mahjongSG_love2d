--[[
    panel

]]

playerchoiceGUI = Class{}

function playerchoiceGUI:init(discardTile, playerDeck)

    self.discardTile = discardTile
    self.playerDeck = playerDeck


end

function playerchoiceGUI:update(dt)

    self.playerDeck:checkPongKang(discardedTile)

end

function playerchoiceGUI:render()


    if self.playerDeck.canPong then
        gSounds['bell']:play()
        self.menu["PongUI"]["available"] = 1
    end

end