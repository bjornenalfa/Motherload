saves = {}
local s = saves

s.menuOpen = false
s.UIelements = {}
s.saves = {}
s.cooldown = 0

local saveDir = love.filesystem.getSaveDirectory()

function saves.refreshSaveInfo()
  local exists = love.filesystem.exists("saveinfo")
  if not exists then
    print("No saveinfo, creating at "..saveDir)
    love.filesystem.write("saveinfo","")
    s.saves = {}
  else
    love.filesystem.load("saveinfo")()
  end
end
s.refreshSaveInfo()

function saves.addSave(name)
  s.saves[name] = {name=name,time=os.time()}
  love.filesystem.write("saveinfo",table.show(saves.saves,"saves.saves"))
end

function s.addElement(element)
  table.insert(s.UIelements,element)
end
local add = s.addElement
local new = loveframes.Create

function saves.openMenu()
  s.menuOpen = true
  
  local frame = new("frame")
  frame:SetPos(190,90)
  frame:SetSize(420,420)
  frame:SetName("Saves")
  frame:SetModal(true)
  frame.OnClose = saves.closeMenu
  
  local list = new("list", frame)
  list:SetSize(420,346)
  list:SetPos(0,25)
  
  for _,v in pairs(s.saves) do
    local panel = new("panel")
    panel:SetSize(420,50)
    list:AddItem(panel)
    
    local text = new("text",panel)
    text:SetText(v.name)
    text:SetPos(5,5)
    
    local button = new("button",panel)
    button:SetText("Save")
    button:SetPos(300,20)
    button.OnClick = function() saves.save(v.name) end
    
    local button = new("button",panel)
    button:SetText("Load")
    button:SetPos(200,20)
    button.OnClick = function() saves.load(v.name) end
    
    local button = new("button",panel)
    button:SetText("Remove")
    button:SetPos(100,20)
    button.OnClick = function()
      local frame = new("frame")
      frame:SetModal(true)
      frame:Center()
      local text = new("text",frame)
      text:SetText("Are you sure?")
      text:Center()
      local button = new("button",frame)
      button:SetText("Yes")
      button:Center()
      button:SetY(button.staticy+25)
      button.OnClick = function() saves.remove(v.name); frame:Remove(); saves.closeMenu(); saves.openMenu() end
    end
  end
  
  local panel = new("panel",frame)
  panel:SetSize(420,50)
  panel:SetPos(0,370)
  
  local textinput = new("textinput",panel)
  textinput:SetPos(10,10)
  textinput:SetSize(200,20)
  
  local button = new("button",panel)
  button:SetText("New save")
  button:SetPos(300,20)
  button.OnClick = function() saves.save(textinput:GetText()) saves.closeMenu() saves.openMenu() end
  
  s.addElement(frame)
end

function saves.closeMenu()
  for _,v in pairs(s.UIelements) do
    v:Remove()
  end
  s.UIelements = {}
  s.menuOpen = false
  s.cooldown = 5
end

function saves.remove(name)
  love.filesystem.remove(name..".save")
  saves.saves[name] = nil
  love.filesystem.write("saveinfo",table.show(saves.saves,"saves.saves"))
end

function saves.load(name)
  saves.loadedterrain = ""
  love.filesystem.load(name..".save")()
  for x = 1,world.width do
    for y = 1,world.height do
      --local b = tonumber(saves.loadedterrain:sub((x-1)*world.width+y,(x-1)*world.width+y+1))
      local b = saves.loadedterrain:sub(((x-1)*world.height+y),((x-1)*world.height+y))
      --print(saves.loadedterrain)
      local nilchar = string.char(255)
      if b == nilchar then
        world.terrain[x][y] = nil
      else
        world.terrain[x][y] = string.byte(b)-65
      end
    end
  end
  local fuel = p.fuel
  local health = p.health
  for i = 1,7 do
    for j = 1,9 do
      if upgrades.purchased[i][j] then
        upgrades.purchase(i,j,true)
      end
    end
  end
  p.fuel = fuel
  p.health = health
  
  world.bitmask = {}
  for x = 1,world.width do
    world.bitmask[x] = {}
    for y = 1,world.height do
      world.calcBitMask(x,y)
    end
  end
end

function saves.save(name)
  data = ""
  --TERRAIN
  data = data.."saves.loadedterrain = '"
  for x = 1,world.width do
    for y = 1,world.height do
      local b = world.terrain[x][y]
      if b == nil then
        data = data..string.char(255)
      --elseif b < 10 then
      --  data = data.."0"..b
      else
        data = data..string.char(b+65)
      end
    end
  end
  data = data.."';\n"
  --PLAYER
  data = data.."player.tanksize = "..p.tanksize..";\n"
  data = data.."player.fuel = "..p.fuel..";\n"
  data = data.."player.money = "..p.money..";\n"
  data = data.."player.maxhealth = "..p.maxhealth..";\n"
  data = data.."player.health = "..p.health..";\n"
  data = data.."player.radiator = "..p.radiator..";\n"
  data = data.."player.drillLevel = "..p.drillLevel..";\n"
  data = data.."player.baseDigSpeed = "..p.baseDigSpeed..";\n"
  data = data.."player.baseyacc = "..p.basexacc..";\n"
  data = data.."player.basexacc = "..p.basexacc..";\n"
  data = data.."player.cargoSize = "..p.cargoSize..";\n"
  data = data.."player.cargoUsed = "..p.cargoUsed..";\n"
  data = data.."player.x = "..p.x..";\n"
  data = data.."player.y = "..p.y..";\n"
  data = data..table.show(p.cargo,"player.cargo")
  --UPGRADES
  data = data..table.show(upgrades.purchased,"upgrades.purchased")
  data = data..table.show(upgrades.unlocked,"upgrades.unlocked")
  --ITEMS
  data = data..table.show(items.inventory,"items.inventory")
  --UI
  data = data.."UI.level = "..UI.level..";\n"
  data = data.."UI.lowest = "..UI.lowest..";\n"
  --EARTHQUAKE
  data = data.."earthquake.depthmod = "..earthquake.depthmod..";\n"
  --WRITE
  love.filesystem.write(name..".save", data)
  --ADD TO KNOWN SAVES
  saves.addSave(name)
  --love.filesystem.write(name, table.show(world.terrain, "world.terrain"))
end

function saves.keypressed(key)
  if key == "escape" then
    saves.closeMenu()
  end
end

function saves.update(dt)
  if s.cooldown > 0 then
    s.cooldown = s.cooldown - dt
  else
    if p.y < -190 and p.y > -235 and p.x > 915 and p.x < 960 then
      saves.openMenu()
    end
  end 
end

function saves.draw()
  if camera.y < -50 then
    love.graphics.setColor(functions.HSV(time*20,150,255))
    love.graphics.draw(image.sputnik,900,-300)
  end
  --love.graphics.draw(image.sputnik,(900-time*500)%(world.width*40+200)-200,-300,time*2)
end