debugMode = false

math.randomseed(os.time())

require "functions"

require "LoveFrames" -- Copyright (c) 2012-2014 Kenny Shields
-- tabbutton, progressbar, list and Blue skin modified by ATii

require "image"
require "gradient"
require "world"
require "player"
require "camera"
require "buildings"
require "buildingsUI"
require "messages"
require "upgrades"
require "explosion"
require "font"
require "items"
require "keybindings"
require "UI"
require "floattext"
require "saves"
require "earthquake"

buildings.load()

--Smartism rekord 2452

width = love.window.getWidth()
height = love.window.getHeight()

consoleOpen = false
consoleText = ""

time = 0

recallx = 1000
recally = -15

noclip = false

consoleFrame = loveframes.Create("frame")
consoleFrame:SetSize(420,420)
consoleFrame:SetPos(190,90)
consoleFrame:SetName("Console")
consoleFrame:SetVisible(false)

consoleLogList = loveframes.Create("list", consoleFrame)
consoleLogList:SetSize(420,370)
consoleLogList:SetPos(0,25)

consoleLog = loveframes.Create("text")
--consoleLog:SetSize(420,370)
--consoleLog:SetPos(0,25)
consoleLog:SetMaxWidth(420)
consoleLogList:AddItem(consoleLog)

consoleTextinput = loveframes.Create("textinput",consoleFrame)
consoleTextinput:SetWidth(420)
consoleTextinput:SetPos(0,395)

--/************Exit Confimation frame and stuff samai****************
confirmFrame = loveframes.Create("frame")
confirmFrame:SetSize(420,420)
confirmFrame:SetPos(190,90)
confirmFrame:SetName("Do you really want to exit? yes/no")
confirmFrame:SetVisible(false)

confirmLogList = loveframes.Create("list", confirmFrame)
confirmLogList:SetSize(420,370)
confirmLogList:SetPos(0,25)

confirmLog = loveframes.Create("text")
confirmLog:SetMaxWidth(420)
confirmLogList:AddItem(confirmLog)

confirmTextinput = loveframes.Create("textinput",confirmFrame)
confirmTextinput:SetWidth(420)
confirmTextinput:SetPos(0,395)

confirmOnEnter = function(object, str)
  local confirmText = "Do you really want to exit? yes/no"
  confirmLog:SetText(confirmText);
  if (str == "exit") or (str == "y")or (str == "yes") or (str == "Yes") then
    love.event.quit()
  elseif str == "YES" then
    love.event.quit()
  else
    confirmFrame:SetVisible(false)
    return
  end
end
confirmTextinput.OnEnter = confirmOnEnter

--/****************************



consoleOnEnter = function(object, str)
  consoleText = ">"..str.."\n"..consoleText
  consoleLog:SetText(consoleText)
  if str:sub(1,5) == "code:" then
    loadstring(str:sub(6))()
  else
    if str == "exit" then
      consoleFrame:SetVisible(false)
      consoleOpen = false
    elseif str == "clear" then
      consoleText = ""
      consoleLog:SetText("")
    elseif str == "setrecall" then
      recallx = p.x
      recally = p.y
    elseif str == "recall" then
      p.x = recallx
      p.y = recally
    elseif str == "noclip" then
      noclip = not noclip
    elseif str == "sv_cheats 1" then
      debugMode = true
    elseif str == "sv_cheats 0" then
      debugMode = false
    elseif str == "bounce" then
      p.bounce = not p.bounce
    elseif str == "end" then
      player.explode(400,true)
    end
  end
end
consoleTextinput.OnEnter = consoleOnEnter

function love.load()
  love.graphics.setBackgroundColor(101,191,213)
  player.init()
  upgrades.init()
  items.init()
end

function love.mousepressed(x, y, button)
  loveframes.mousepressed(x ,y ,button)
end

function love.mousereleased(x, y, button)
  loveframes.mousereleased(x ,y ,button)
end

function love.textinput(text)
  loveframes.textinput(text)
end

local function error_printer(msg, layer)
    print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end

function love.errhand(msg) -- default with additions
  
  local date = string.gsub(os.date(), ":", "-")
  pcall(function()
  saves.save("error_"..date)
  end)
  
    msg = tostring(msg)

    error_printer(msg, 2)

    if not love.window or not love.graphics or not love.event then
        return
    end

    if not love.graphics.isCreated() or not love.window.isCreated() then
        if not pcall(love.window.setMode, 800, 600) then
            return
        end
    end

    -- Reset state.
    if love.mouse then
        love.mouse.setVisible(true)
        love.mouse.setGrabbed(false)
    end
    if love.joystick then
        for i,v in ipairs(love.joystick.getJoysticks()) do
            v:setVibration() -- Stop all joystick vibrations.
        end
    end
    if love.audio then love.audio.stop() end
    love.graphics.reset()
    love.graphics.setBackgroundColor(89, 157, 220)
    local font = love.graphics.setNewFont(14)

    love.graphics.setColor(255, 255, 255, 255)

    local trace = debug.traceback()

    love.graphics.clear()
    love.graphics.origin()

    local err = {}

    table.insert(err, "Error\n")
    table.insert(err, msg.."\n\n")

    for l in string.gmatch(trace, "(.-)\n") do
        if not string.match(l, "boot.lua") then
            l = string.gsub(l, "stack traceback:", "Traceback\n")
            table.insert(err, l)
        end
    end

    local p = table.concat(err, "\n")

    p = string.gsub(p, "\t", "")
    p = string.gsub(p, "%[string \"(.-)\"%]", "%1")

    local function draw()
        love.graphics.clear()
        love.graphics.setColor(255,150,150)
        love.graphics.print("The game crashed! ^^ \nA save with the name 'error_"..date.."' has been automatically created.",70,30)
        love.graphics.setColor(255,255,255)
        love.graphics.printf(p, 70, 70, love.graphics.getWidth() - 70)
        love.graphics.present()
    end

    while true do
        love.event.pump()

        for e, a, b, c in love.event.poll() do
            if e == "quit" then
                return
            end
            if e == "keypressed" and a == "escape" then
                return
            end
        end

        draw()

        if love.timer then
            love.timer.sleep(0.1)
        end
    end

end

function love.keypressed(key)
  loveframes.keypressed(key)
  if consoleOpen then
    if key == "escape" then
      consoleFrame:SetVisible(false)
      consoleOpen = false
      consoleTextinput:SetFocus(false)
    elseif key == "lctrl" then
      if not consoleTextinput:GetFocus() then
        consoleTextinput:SetFocus(true)
      end
    end
  else
    if buildings.UIopen then
      buildings.keypressed(key)
    elseif messages.open then
      messages.keypressed(key)
    elseif saves.menuOpen then
      saves.keypressed(key)
    else
      if key == "escape" then
        love.event.quit()-- samai
        --confirmFrame:SetVisible(true)-- decomment this to get a confirmwindow when quitting -- Samai
      elseif key == "g" then
        if player.yacc == 4 then
          player.yacc = 2
        else
          player.yacc=4
        end
      elseif key == "y" then
        if UI.level >= 7 then
          camera.manual = not camera.manual
        end
      elseif key == "-" then
        consoleFrame:SetVisible(true)
        consoleOpen = true
        --consoleTextinput:SetFocus(true)
        --consoleTextinput:SelectAll()
      end
      player.keypressed(key)
      keybindings.keypressed(key)
    end
  end
end

function love.keyreleased(key)
  loveframes.keyreleased(key)
end

function love.update(dt)
  time = time + dt
  if not (buildings.UIopen or messages.open or saves.menuOpen or earthquake.shaking) then
    player.update(dt)
    saves.update(dt)
    --camera.update(dt)
    --explosion.update(dt)
  end
  earthquake.update(dt)
  explosion.update(dt)
  buildings.update(dt)
  camera.update(dt)
  floattext.update(dt)
  messages.update(dt)
  
  loveframes.update(dt)
end

function love.draw()
  camera.draw()
  world.draw()
  buildings.draw()
  saves.draw()
  player.draw()
  explosion.draw()
  earthquake.draw()
  floattext.draw()
  
  love.graphics.origin()
  --love.graphics.print(table.concat({love.getVersion()},"."),300,300)
  UI.draw()
  loveframes.draw()
end