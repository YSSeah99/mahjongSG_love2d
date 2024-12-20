--[[
    panel

]]

choiceGUI = Class{}

function choiceGUI:init(text, available)

    self.text = text
    
    self.available = available

end

function choiceGUI:update(dt)

end

function choiceGUI:render()

    love.graphics.setColor(1, 1, 1, 0.75)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 3)
    --love.graphics.setColor(56/255, 56/255, 56/255, 1)
    --love.graphics.rectangle('fill', self.x + 2, self.y + 2, self.width - 4, self.height - 4, 3)
    love.graphics.setFont(gFonts['small'])
    self.textHorizontalalignment = (self.height - gFonts['small']:getHeight(self.text)) / 2

    if self.available == 1 then
        
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf(self.text, self.x, self.y + self.textHorizontalalignment, self.width, "center") -- 382 x 216

    else

        love.graphics.setColor(0, 0, 0, 0.1)
        love.graphics.printf(self.text, self.x, self.y + self.textHorizontalalignment, self.width, "center") -- 382 x 216

    end

end

function choiceGUI:toggle()
    self.available = not self.available
end