--[[
    Mahjong MenuState
]]

MenuState = Class{__includes = BaseState}

function MenuState:init()
    highlighted = 1
end

function MenuState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    highlighted = highlighted % 3

    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w') then
        highlighted = highlighted - 1
        --gSounds['']:play()
    end

    if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('s') then
        highlighted = highlighted + 1
        --gSounds['']:play()
    end

    --[[
    -- mouseOption depending on mouseY
    if mouseX and mouseY then
        if (mouseY <= (VIRTUAL_HEIGHT / 2 + 28)) then
            highlighted = 1
            --gSounds['']:play()
        elseif ((mouseY <= VIRTUAL_HEIGHT / 2 + 48)) then
            highlighted = 2
            --gSounds['']:play()
        else
            highlighted = 0
            --gSounds['']:play()
        end
    end
    ]]

    -- confirm highlighted option after enter key is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.mousepressed() == 1 then

        if highlighted == 0 then
            love.event.quit()

        elseif highlighted == 1 then
            gStateMachine:change('setting')

        elseif highlighted == 2 then
            print("Multiplayer Not Done")
        end
    end
end

function MenuState:render()
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    -- title
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(34/255, 34/255, 34/255, 1)
    love.graphics.printf('Mahjong SEA', 2, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(32/255, 60/255, 139/255, 1)
    love.graphics.printf('Mahjong SEA', 0, VIRTUAL_HEIGHT / 2 - 42, VIRTUAL_WIDTH, 'center')

    -- options
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1, 1, 1, 1)

    -- if we're highlighting 1, render that option red
    if highlighted == 1 then
        love.graphics.setColor(189/255, 44/255, 32/255, 1)
    end
    love.graphics.printf("Singleplayer", 0, VIRTUAL_HEIGHT / 2 + 20,
        VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    -- if we're highlighting 2, render that option red
    if highlighted == 2 then
        love.graphics.setColor(189/255, 44/255, 32/255, 1)
    end
    love.graphics.printf("Multiplayer", 0, VIRTUAL_HEIGHT / 2 + 40,
        VIRTUAL_WIDTH, 'center')
        
    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    -- if we're highlighting 0, render that option red
    if highlighted == 0 then
        love.graphics.setColor(189/255, 44/255, 32/255, 1)
    end
    love.graphics.printf("Exit Game", 0, VIRTUAL_HEIGHT / 2 + 60,
        VIRTUAL_WIDTH, 'center')
        
    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)
end