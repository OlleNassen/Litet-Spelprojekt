require ("/Resources/Scripts/Setup/Input")

setResolution(1280, 720)
setFramerate(60)

bindKeyboard("moveUp", keyboard.W, keyboard.S)
bindKeyboard("moveRight", keyboard.D, keyboard.A)
bindKeyboard("jump", keyboard.Space, keyboard.None)
bindKeyboard("quit", keyboard.Escape, keyboard.None)
bindKeyboard("select", keyboard.Return, keyboard.None)
bindKeyboard("selectEditor", keyboard.RShift, keyboard.None)
bindMouse("mouseLeft", mouse.Left, mouse.None)
bindKeyboard("key1", keyboard.Num1, keyboard.None)
bindKeyboard("key2", keyboard.Num2, keyboard.None)
bindKeyboard("key3", keyboard.Num3, keyboard.None)
bindKeyboard("save", keyboard.K, keyboard.None)

push("Resources/Scripts/LuaStates/menuState.lua")