import GLFW

include("KeyCode.jl")
include("MouseCode.jl")

function Input_IsKeyPressed(keycode::KeyCode)
  GLFW.GetKey(Window_GetNative(), Cint(keycode))
end

function Input_IsMouseButtonPressed(button::MouseCode)
  GLFW.GetMouseButton(Window_GetNative(), Cint(button))
end

function Input_GetMousePos()
  GLFW.GetCursorPos(Window_GetNative())
end

function Input_GetMouseX()
  x, _ = GLFW.GetCursorPos(Window_GetNative())
  x
end

function Input_GetMouseY()
  _, y = GLFW.GetCursorPos(Window_GetNative())
  y
end

export Input_IsKeyPressed, Input_IsMouseButtonPressed, Input_GetMousePos, Input_GetMouseX, Input_GetMouseY
