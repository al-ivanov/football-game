-- love shorthands
lg = love.graphics
lw = love.window
lk = love.keyboard
la = love.audio
le = love.event

-- general libraries
vec = require 'libs/vector'
colors = require 'libs/colors'

-- collision
bump = require 'libs/bump'
world = bump.newWorld()
-- sti = require 'libs/sti'

-- resolution
push = require 'libs/push'
gameW, gameH = 800, 450
local windowW, windowH = lw.getDesktopDimensions()
push:setupScreen(gameW, gameH, windowW * 0.5, windowH * 0.5)
lg.setDefaultFilter('nearest', 'nearest')

-- assets
assets = require('libs/cargo').init('assets')

-- classes
Class = require 'libs/class'
Entity = require 'classes/Entity'
Player = require 'classes/Player'
Ball = require 'classes/Ball'

-- states
gamestate = require 'libs/gamestate'
startScreen = require 'states.startScreen'
gameScreen = require 'states.gameScreen'

-- game vars
telekinesisRadius = 100
debug = true

function love.load()
    lw.setTitle('Telekinessball')
    
    lg.setFont(assets.fonts.courier_prime(48))
    
    gamestate.registerEvents()
    gamestate.switch(startScreen)
end

function love.keypressed(k)
    if (k == 'f') then
        push:switchFullscreen()
    elseif (k == 'q' or k == 'escape') then
        le.quit()
    elseif (k == 'm') then
    
    end
end