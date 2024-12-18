--[[
    playerGUI

]]

playerGUI = Class{}

function playerGUI:init(availableTable)

    self.availableTable = availableTable
    
    -- topPanel
    self.seeTopView = Panel(VIRTUAL_WIDTH * 0.8, VIRTUAL_HEIGHT * 0.1, TOP_PANEL_WIDTH, TOP_PANEL_HEIGHT, "See Top View", 1)

    -- bottomPanel
    self.DrawUI = Panel(bottomPanelPosn[1], VIRTUAL_HEIGHT * 0.9, BOTTOM_PANEL_WIDTH, BOTTOM_PANEL_HEIGHT, "Draw", self.availableTable[1])
    self.ChiUI = Panel(bottomPanelPosn[2], VIRTUAL_HEIGHT * 0.9, BOTTOM_PANEL_WIDTH, BOTTOM_PANEL_HEIGHT, "Chi", self.availableTable[2])
    self.PongUI = Panel(bottomPanelPosn[3], VIRTUAL_HEIGHT * 0.9, BOTTOM_PANEL_WIDTH, BOTTOM_PANEL_HEIGHT, "Pong", self.availableTable[3])
    self.KangUI = Panel(bottomPanelPosn[4], VIRTUAL_HEIGHT * 0.9, BOTTOM_PANEL_WIDTH, BOTTOM_PANEL_HEIGHT, "Kang", self.availableTable[4])
    self.FuUI = Panel(bottomPanelPosn[5], VIRTUAL_HEIGHT * 0.9, BOTTOM_PANEL_WIDTH, BOTTOM_PANEL_HEIGHT, "Fu", self.availableTable[5])

end

function playerGUI:update(dt)

end

function playerGUI:render()

    self.seeTopView:render()
    
    self.DrawUI:render()
    self.ChiUI:render()
    self.PongUI:render()
    self.KangUI:render()
    self.FuUI:render()

end

function playerGUI:toggle()
    self.visible = not self.visible
end