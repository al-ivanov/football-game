local startScreen = {}

local clText = {{
    colors.orange,
    'T', colors.aqua,
    'e', colors.orange,
    'l', colors.aqua,
    'e', colors.orange,
    'k', colors.aqua,
    'i', colors.orange,
    'n', colors.aqua,
    'e', colors.orange,
    's', colors.aqua,
    's', colors.orange,
    'b', colors.aqua,
    'a', colors.orange,
    'l', colors.aqua,
    'l'
},
{
    colors.aqua,
    'T', colors.orange,
    'e', colors.aqua,
    'l', colors.orange,
    'e', colors.aqua,
    'k', colors.orange,
    'i', colors.aqua,
    'n', colors.orange,
    'e', colors.aqua,
    's', colors.orange,
    's', colors.aqua,
    'b', colors.orange,
    'a', colors.aqua,
    'l', colors.orange,
    'l'
}
}

local clTextIndex = 1
local colorSwitchStartTime  = 0
local muteStartTime = 0 
local muted = false

function startScreen:enter()
    colorSwitchStartTime = lt.getTime()
    muteStartTime = lt.getTime()
    muted = false
    TEsound.volume('bgm', fullVol)
end

function startScreen:update(dt)
    TEsound.cleanup()
    canim:update(dt)
    p1input:update()
    p2input:update()
    
    if p1input:pressed('action') or p2input:pressed('action') then
        gamestate.switch(gameScreen)
    end
    
    if lt.getTime() - colorSwitchStartTime > 0.5 then
        clTextIndex =  (clTextIndex % 2) + 1
        colorSwitchStartTime = lt.getTime()
    end
    
    if lt.getTime() - muteStartTime > 60 and muted == false then
        TEsound.volume('bgm', 0)
        muted = true
    end
end

function startScreen:draw()
    push:start()
    
    effect(function()
    
    lg.setColor(colors.white)
    lg.draw(assets.sprites.field, 0, 0)
    canim:draw(csheet, 400 - 96 - 290, 320)
    canim:draw(csheet, 400 - 96 + 290, 320)

    lg.setFont(fontTitle)
    lg.printf(clText[clTextIndex], 0, 180, gameW, 'center')
    
    lg.setColor(colors.white)
    
    end)
    
    push:finish()
end



return startScreen