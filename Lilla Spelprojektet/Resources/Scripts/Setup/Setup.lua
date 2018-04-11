require ("/Resources/Scripts/Setup/Input")

setResolution(1280, 720)
setFramerate(60)

bindKeyboard("quit", keyboard.Escape, keyboard.None)
bindKeyboard("moveRight", keyboard.D, keyboard.A)
bindKeyboard("jump", keyboard.Space, keyboard.None)

push("Resources/Scripts/LuaStates/gameState.lua")