-- Loads BGM/SFX and exposes them for gameplay code.
-- Music: https://roccow.bandcamp.com/track/swingjeding
require 'libs/tesound'

local Audio = {}

function Audio.init(maxVolume)
    Audio.maxVolume = maxVolume
    Audio.volumeState = maxVolume

    Audio.bgm = love.sound.newSoundData('assets/audio/roccow.ogg')
    TEsound.playLooping(Audio.bgm, 'bgm')
    TEsound.volume('bgm', maxVolume)

    Audio.exp3 = love.sound.newSoundData('assets/audio/exp3.ogg')
    Audio.exp8 = love.sound.newSoundData('assets/audio/exp8.ogg')
    Audio.pow3 = love.sound.newSoundData('assets/audio/pow3.ogg')
    Audio.hit1 = love.sound.newSoundData('assets/audio/hit1.ogg')
    Audio.step1 = love.sound.newSoundData('assets/audio/stairs3.ogg')
    Audio.step2 = love.sound.newSoundData('assets/audio/stairs4.ogg')

    TEsound.playLooping(Audio.step1, 'step1')
    TEsound.playLooping(Audio.step2, 'step2')
    TEsound.volume('step1', 0)
    TEsound.volume('step2', 0)

    return Audio
end

function Audio.setBgmVolume(volume)
    Audio.volumeState = volume
    TEsound.volume('bgm', volume)
end

function Audio.toggleMute()
    if Audio.volumeState > 0 then
        Audio.setBgmVolume(0)
    else
        Audio.setBgmVolume(Audio.maxVolume)
    end
end

return Audio
