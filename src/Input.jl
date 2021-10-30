import GLFW

include("KeyCode.jl")
include("MouseCode.jl")

function Input_IsKeyPressed(keycode::KeyCode)
    GLFW.GetKey(WINDOW_DATA, Cint(keycode))
end

function Input_IsMouseButtonPressed(button::MouseCode)
    GLFW.GetMouseButton(WINDOW_DATA, Cint(button))
end

function Input_GetMousePos()
    GLFW.GetCursorPos(WINDOW_DATA)
end

function Input_GetMouseX()
    x, _ = GLFW.GetCursorPos(WINDOW_DATA)
    x
end

function Input_GetMouseY()
    _, y = GLFW.GetCursorPos(WINDOW_DATA)
    y
end

export Input_IsKeyPressed, Input_IsMouseButtonPressed, Input_GetMousePos, Input_GetMouseX, Input_GetMouseY
