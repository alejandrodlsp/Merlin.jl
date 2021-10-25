include("Event/Event.jl")
# include("Input.jl")

import GLFW
using ModernGL

function WindowInput_OnKeyCallback(eventContext::Function, window::GLFW.Window, key::GLFW.Key, scancode::Cint, action::GLFW.Action, mods::Cint)
    if (action == GLFW.PRESS)
        eventContext(KeyEventData(EventTypeKeyPressed, Cint(key), Cint(0)))
    elseif (action == GLFW.RELEASE)
        eventContext(KeyEventData(EventTypeKeyReleased, Cint(key), Cint(0)))
    end
end

function WindowInput_OnMouseMovedCallback(eventContext::Function, window::GLFW.Window, xpos::Cdouble, ypos::Cdouble)
    eventContext(MouseMovedEventData(Float64(xpos), Float64(ypos)))
end

function WindowInput_OnMouseButtonCallback(eventContext::Function, window::GLFW.Window, button::GLFW.MouseButton, action::GLFW.Action, mods::Cint)
    if (action == GLFW.PRESS)
        eventContext(MouseButtonEventData(EventTypeMouseButtonPressed, Cint(button)))
    else (action == GLFW.RELEASE)
        eventContext(MouseButtonEventData(EventTypeMouseButtonReleased, Cint(button)))
    end
end

function WindowInput_OnMouseScrollCallback(eventContext::Function, window::GLFW.Window, offsetX::Cdouble, offsetY::Cdouble)
    eventContext(MouseScrollEventData(Float64(offsetX), Float64(offsetY)))
end

function WindowInput_OnWindowCloseCallback(eventContext::Function, window::GLFW.Window)
    eventContext(WindowCloseEventData())
end

function WindowInput_OnWindowSizeCallback(eventContext::Function, window::GLFW.Window, width::Cint, height::Cint)
    glViewport(0, 0, width, height) # TODO: Move viewport resize call to renderer
    eventContext(WindowSizeEventData(width, height))
end

function WindowInput_OnWindowMovedCallback(eventContext::Function, window::GLFW.Window, posx::Cint, posy::Cint)
    eventContext(WindowMovedEventData(posx, posy))
end

function WindowInput_RegisterInputCallbacks(window::GLFW.Window, eventContext::Function)
    @debug "Registering window event callbacks"
    GLFW.SetKeyCallback(window, (w, k, s, a, m) -> WindowInput_OnKeyCallback(eventContext, w, k, s, a, m))
    GLFW.SetCursorPosCallback(window, (w, x, y) -> WindowInput_OnMouseMovedCallback(eventContext, w, x, y))
    GLFW.SetMouseButtonCallback(window, (w, b, a, m) -> WindowInput_OnMouseButtonCallback(eventContext, w, b, a, m))
    GLFW.SetScrollCallback(window, (w, x, y) -> WindowInput_OnMouseScrollCallback(eventContext, w, x, y))
    GLFW.SetWindowCloseCallback(window, (w) -> WindowInput_OnWindowCloseCallback(eventContext, w))
    GLFW.SetFramebufferSizeCallback(window, (w, wi, he) -> WindowInput_OnWindowSizeCallback(eventContext, w, wi, he))
    GLFW.SetWindowPosCallback(window, (w, x, y) -> WindowInput_OnWindowMovedCallback(eventContext, w, x, y))
end