--[[
    Mahjong DiceRollingState

    1. Three dices is rolled to determine whose tiles are dealed
    2. The sum is then cut "graphically" and dealed to each player
]]

DiceRollingState = Class{__includes = BaseState}

function DiceRollingState:init(playerRoll, tileColor, jokerstring)
    
    self.diceAnimation = Animation {
        frames = {1, 2, 3, 4, 5, 6},
        interval = 0.1
    }
    self.diceAnimationTrigger = true
    
end

function DiceRollingState:enter(params)

    self.playerRoll = params.playerRoll
    self.tileColor = params.tileColor
    self.jokerstring = params.jokerstring
    self.roundDeck = Deck(self.jokerstring, self.tileColor)
    self.hands, self.drawWall = self.roundDeck:deal()
    
end

function DiceRollingState:update(dt)
    self.diceAnimation:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.diceAnimationTrigger = not self.diceAnimationTrigger
        diceOne = math.random(6)
        diceTwo = math.random(6)
        diceThree = math.random(6)
        diceSum = diceOne + diceTwo + diceThree
    end 
end

function DiceRollingState:rolldice()
    return diceSum
end

function DiceRollingState:render()

    -- background
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    -- dice rolling animation
    if self.diceAnimationTrigger then

        -- 1st dice
        love.graphics.draw(gTextures['dice'], 
        gFrames['dice'][self.diceAnimation:getCurrentFrame()],
        VIRTUAL_WIDTH / 2 - DICE_WIDTH / 4 * 3 - DICE_WIDTH,  
        VIRTUAL_HEIGHT / 2 - DICE_HEIGHT / 2,  
        0, 
        DICE_WIDTH / 51,
        DICE_HEIGHT / 52)
        
        -- middle dice (or 2nd)
        love.graphics.draw(gTextures['dice'], 
        gFrames['dice'][self.diceAnimation:getCurrentFrame()],
        VIRTUAL_WIDTH / 2 - DICE_WIDTH / 4 * 3,  
        VIRTUAL_HEIGHT / 2 - DICE_HEIGHT / 2,  
        0, 
        DICE_WIDTH / 51,
        DICE_HEIGHT / 52)

        -- third dice
        love.graphics.draw(gTextures['dice'], 
        gFrames['dice'][self.diceAnimation:getCurrentFrame()],
        VIRTUAL_WIDTH / 2 - DICE_WIDTH / 4 * 3 + DICE_WIDTH,  
        VIRTUAL_HEIGHT / 2 - DICE_HEIGHT / 2,  
        0, 
        DICE_WIDTH / 51,
        DICE_HEIGHT / 52)

        if self.playerRoll then

            love.graphics.setFont(gFonts['medium'])
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf("Press Enter To Roll!", 
            0, 
            VIRTUAL_HEIGHT / 2 + DICE_HEIGHT, 
            VIRTUAL_WIDTH, 'center')

        end

    else

        -- first dice
        love.graphics.draw(gTextures['dice'], 
        gFrames['dice'][diceOne],
        VIRTUAL_WIDTH / 2 - DICE_WIDTH / 4 * 3 - DICE_WIDTH,  
        VIRTUAL_HEIGHT / 2 - DICE_HEIGHT / 2, 
        0, 
        DICE_WIDTH / 51,
        DICE_HEIGHT / 52)

        -- second dice
        love.graphics.draw(gTextures['dice'], 
        gFrames['dice'][diceTwo],
        VIRTUAL_WIDTH / 2 - DICE_WIDTH / 4 * 3,  
        VIRTUAL_HEIGHT / 2 - DICE_HEIGHT / 2,  
        0, 
        DICE_WIDTH / 51,
        DICE_HEIGHT / 52)

        -- 3rd dice
        love.graphics.draw(gTextures['dice'], 
        gFrames['dice'][diceThree],
        VIRTUAL_WIDTH / 2 - DICE_WIDTH / 4 * 3 + DICE_WIDTH,  
        VIRTUAL_HEIGHT / 2 - DICE_HEIGHT / 2,  
        0, 
        DICE_WIDTH / 51,
        DICE_HEIGHT / 52)

        Timer.after(1, function()
            gStateMachine:change('playerDraw', {
                tileColor = self.tileColor,
                jokerstring = self.jokerstring,
                drawWall = self.drawWall,
                hands = self.hands,
                flowerWalls = {{}, {}, {}, {}},
                discardedTiles = {{}, {}, {}, {}}
            })
        end)
        
    end
end