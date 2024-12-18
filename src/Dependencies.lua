--
-- libraries
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

require 'src/components/tile'
require 'src/components/deck'

require 'src/gui/Panel'
require 'src/gui/playerGUI'

require 'src/states/BaseState'
require 'src/states/MenuState'

require 'src/states/Singleplayer/SettingState'
require 'src/states/Singleplayer/DealerPickingState'
require 'src/states/Singleplayer/DiceRollingState'

require 'src/states/Singleplayer/PlayerDrawState'
require 'src/states/Singleplayer/PlayerDiscardState'

require 'src/states/Singleplayer/rightAIDrawState'
require 'src/states/Singleplayer/rightAIDiscardState'

gTextures = {
    ['background'] = love.graphics.newImage('graphics/mahjong_background.png'),
    ['tiles_colour'] = love.graphics.newImage('graphics/tile_colour.png'),
    ['pattern'] = love.graphics.newImage('graphics/patterns.png'),
    ['dice'] = love.graphics.newImage('graphics/dice_Sprite.png'),
    ['tiles'] = love.graphics.newImage('graphics/tiles_sg.png')
    --['tiles'] = love.graphics.newImage('graphics/image.png')
}

gFrames = {
    ['tiles_colour'] = GenerateQuads(gTextures['tiles_colour'], 190, 240),
    ['tiles'] = GenerateQuads(gTextures['tiles'], 150, 200),
    ['patterns'] = GenerateQuads(gTextures['pattern'], 150, 200),
    ['dice'] = GenerateQuads(gTextures['dice'], 51, 52)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 12),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 24),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 48)
}

gSounds = {
    ['tile-draw'] = love.audio.newSource('sounds/DrawTiles.ogg', 'static'),
    ['tile-discard'] = love.audio.newSource('sounds/DiscardTile.ogg', 'static'),
}