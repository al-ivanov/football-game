-- Central gameplay and layout constants.
local Config = {
    title = 'Telekinessball',

    gameW = 800,
    gameH = 450,
    windowScale = 0.7,

    telekinesisRadius = 80,
    smlTelekinesisRadius = 50,
    kickStr = 2,
    launchStr = 45,
    playerSpeed = 4,

    maxVolume = 0.3,
    maxScore = 5,
    maxIdleTime = 20,
    idleWarnLead = 6,

    spawnPoints = {
        [1] = {x = 224, y = 208, facing = 1},
        [2] = {x = 544, y = 208, facing = -1},
    },

    ballSpawns = {
        {400 - 24, 225 - 24},
        {400 - 24, 125 - 24},
        {400 - 24, 325 - 24},
    },
}

return Config
