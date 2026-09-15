local mod = RegisterMod("P5R Menu Music", 1)
function mod:startGame()
  if SoundtrackSongList then
    AddSoundtrackToMenu("P5R")
  end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.startGame)
