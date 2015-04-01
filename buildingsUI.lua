buildingsUI = {}
local u = buildingsUI

u.currentBuilding = 0

u.fuelPrice = 0.5
u.hullPrice = 0.6

u.UIelements = {}

function u.addElement(element)
  table.insert(u.UIelements,element)
end
local add = u.addElement
local new = loveframes.Create

function buildingsUI.open(name)
  if name == "fuelstore" then
    u.currentBuilding = 1
    local frame = new("frame")
    frame:SetPos(190,90)
    frame:SetSize(420,420)
    frame:SetName("Fuel store")
    frame:SetModal(true)
    frame.OnClose = buildings.closeUI
    
    local button = new("button", frame)
    button:SetSize(200,50)
    button:SetText("Fill up on fuel ($"..(math.floor((p.tanksize - p.fuel) * u.fuelPrice + 0.5))..")")
    button:Center()
    button.OnClick = buildingsUI.performMainAction
    
    add(frame)
    --add(button)
  elseif name == "orestore" then
    u.currentBuilding = 2
    local frame = new("frame")
    frame:SetPos(190,90)
    frame:SetSize(420,420)
    frame:SetName("Ore store")
    frame:SetModal(true)
    frame.OnClose = buildings.closeUI
    local list = new("list", frame)
    list:SetPos(0,25)
    list:SetSize(420,370)
    
    local it = 1
    local sum = 0
    for i = 1,#p.cargo do
      if p.cargo[i] > 0 then
        local panel = new("panel")
        panel:SetHeight(40)
        list:AddItem(panel)
        --add(panel)
        local image = new("image", panel)
        image:SetImage(world.ores[i].image)
        --add(image)
        
        local text1 = new("text", panel)
        text1:SetFont(font.x18)
        text1:SetText(world.ores[i].name)
        text1:SetX(45)
        text1:CenterY()
        --add(text1)
        
        local text2 = new("text", panel)
        text2:SetFont(font.x18)
        text2:SetText(p.cargo[i])
        text2:SetX(190)
        text2:CenterY()
        --add(text2)
        
        local text3 = new("text", panel)
        text3:SetFont(font.x18)
        text3:SetText("x "..world.ores[i].value)
        text3:SetX(212)
        text3:CenterY()
        --add(text3)
        
        local text4 = new("text", panel)
        text4:SetFont(font.x18)
        text4:SetText("= "..world.ores[i].value * p.cargo[i])
        text4:SetX(300)
        text4:CenterY()
        --add(text4)
        
        sum = sum + world.ores[i].value * p.cargo[i]
      end
    end
    
    local text = new("text", frame)
    text:SetPos(10,395)
    text:SetSize(350,20)
    text:SetText("Total: "..sum..".")
    text:SetFont(font.x20)
    
    local button = new("button", frame)
    button:SetPos(320,394)
    button:SetSize(100,26)
    button:SetText("Sell all")
    button.OnClick = buildingsUI.performMainAction
    add(frame)
    --add(list)
  elseif name == "upgradestore" then
    u.currentBuilding = 3
    local frame = new("frame")
    frame:SetPos(190,90)
    frame:SetSize(420,420)
    frame:SetModal(true)
    frame.OnClose = buildings.closeUI
    
    local tabs = new("tabs", frame)
    tabs:SetPos(0, 0)
    tabs:SetSize(420, 420)
    tabs:SetClickBounds(0, 0, 390, 420)
    
    for i = 1,#upgrades.names do
      local panel = new("panel")
      tabs:AddTab(upgrades.names[i],panel)
      
      local panel2 = new("panel", panel)
      panel2:SetSize(410,171)
      
      local ownedNumber = 1
      for _ = 1,9 do
        if upgrades.purchased[i][_] then
          ownedNumber = _
        end
      end
      
      local owned = upgrades.list[i][ownedNumber]
      
      local currentImage = new("image", panel2)
      currentImage:SetSize(80,80)
      currentImage:SetPos(18,18)
      currentImage:SetImage(owned.image)
      
      local name = new("text", panel2)
      name:SetFont(font.x20)
      name:SetText(owned.name)--.." "..upgrades.names[i]:sub(1,#upgrades.names[i]-1))
      name:SetPos(18,116)
      
      local description = new("text", panel2)
      description:SetFont(font.x15)
      description:SetPos(116,18)
      description:SetMaxWidth(420-116-18)
      description:SetText(owned.description)
      
      local purchase = new("button", panel2)
      purchase:SetSize(120,25)
      purchase:SetPos(420-120-27,171-18-25)
      if upgrades.purchased[i][ownedNumber] then
        purchase:SetText("Currently using")
        purchase:SetClickable(false)
      else
        purchase:SetText("Purchase for "..owned.price)
        purchase:SetClickable(owned.price <= p.money)
      end
      purchase.OnClick = (function()
        purchase:SetText("Purchased")
        purchase:SetClickable(false)
        upgrades.purchase(i,ownedNumber)
      end)
      
      for t = 0,upgrades.unlocked[i]-1 do
        local panel2 = new("panel", panel)
        local backimage = new("image", panel2)
        local imagebutton = new("imagebutton", panel2)
        backimage:SetSize(80,80)
        backimage:SetPos(1,1)
        backimage:SetImage(image.backfill)
        if upgrades.purchased[i][t+1] then
          backimage:SetColor(100,255,100)
        else
          backimage:SetColor(255,255,255,0)
        end
        imagebutton:SetSize(80,80)
        imagebutton:SetPos(1,1)
        panel2:SetSize(82,82)
        panel2:SetPos(18+98*((t%4))-1,170+18+98*(math.floor(t/4))-1)
        imagebutton:SetImage(upgrades.list[i][t+1].image)
        imagebutton:SetText("")
        imagebutton.OnClick = (function ()
          local item = upgrades.list[i][t+1]
          currentImage:SetImage(item.image)
          name:SetText(item.name)--.." "..upgrades.names[i]:sub(1,#upgrades.names[i]-1))
          description:SetText(item.description.." "..upgrades.statName[i].." "..item.stat*upgrades.multiplier[i]..upgrades.statUnit[i])
          if upgrades.purchased[i][t+1] then
            local used = 1
            for _ = 1,9 do
              if upgrades.purchased[i][_] then
                used = _
              end
            end
            if used == t+1 then
              purchase:SetText("Currently using")
            else
              purchase:SetText("Already Purchased")
            end
            purchase:SetClickable(false)
          else
            purchase:SetText("Purchase for "..item.price)
            purchase:SetClickable(item.price <= p.money)
          end
          purchase.OnClick = (function()
            purchase:SetText("Purchased")
            purchase:SetClickable(false)
            upgrades.purchase(i,t+1)
            backimage:SetColor(100,255,100)
          end)
        end)
      end
    end
    add(frame)
  elseif name == "itemstore" then
    u.currentBuilding = 4
    local frame = new("frame")
    frame:SetPos(190,90)
    frame:SetSize(420,420)
    frame:SetName("Item store")
    frame:SetModal(true)
    frame.OnClose = buildings.closeUI
    
    -- HULL
    progressbar = new("progressbar", frame)
    progressbar:SetPos(10,35)
    progressbar:SetSize(290,25)
    progressbar:SetMin(0)
    progressbar:SetMax(p.maxhealth)
    progressbar:SetLerp(true)
    progressbar:SetLerpRate(p.maxhealth/1)
    progressbar:SetValue(math.floor(p.health+0.5))
    progressbar:SetATii(true)
    
    local button = new("button", frame)
    button:SetPos(310,35)
    button:SetSize(100,25)
    button:SetText("Repair hull ($"..(math.floor((p.maxhealth - p.health) * u.hullPrice + 0.5))..")")
    button.OnClick = buildingsUI.performMainAction
    
    -- ITEMS
    local selected = items.list[1]
    
    local panel = new("panel",frame)
    panel:SetSize(420,350)
    panel:SetPos(0,70)
    
    local currentImage = new("image", panel)
    currentImage:SetSize(80,80)
    currentImage:SetPos(10,10)
    currentImage:SetImage(image.placeholder)
    
    local owned = new("text", panel)
    owned:SetSize(80,15)
    owned:SetPos(10,90)
    owned:SetText("Owned: "..items.inventory[1])
    
    local name = new("text", panel)
    name:SetFont(font.x20)
    name:SetText(selected.name)
    name:SetPos(100,10)
    
    local description = new("text", panel)
    description:SetFont(font.x15)
    description:SetPos(100,30)
    description:SetMaxWidth(320)
    description:SetText(selected.description)
    
    local purchase = new("button", panel)
    purchase:SetSize(120,25)
    purchase:SetPos(290,75)
    purchase:SetText("Purchase for "..selected.price)
    purchase:SetClickable(selected.price <= p.money)
    
    purchase.OnClick = (function()
      items.purchase(1)
      purchase:SetClickable(selected.price <= p.money)
      owned:SetText("Owned: "..items.inventory[1])
    end)
    
    local list = new("list", panel)
    list:SetPos(0,110)
    list:SetSize(420,240)
    list:EnableHorizontalStacking(true)
    list:SetPadding(17)
    list:SetSpacing(17)
    
    for i = 1,#items.list do
      local item = items.list[i]
      local imagebutton = new("imagebutton")
      imagebutton.image = item.image
      imagebutton:SetSize(80,80)
      imagebutton:SetText(item.name)
      
      list:AddItem(imagebutton)
      
      imagebutton.OnClick = (function()
        currentImage:SetImage(item.image)
        owned:SetText("Owned: "..items.inventory[i])
        name:SetText(item.name)
        description:SetText(item.description)
        purchase:SetText("Purchase for "..item.price)
        purchase:SetClickable(item.price <= p.money)
        
        purchase.OnClick = (function()
          items.purchase(i)
          purchase:SetClickable(item.price <= p.money)
          owned:SetText("Owned: "..items.inventory[i])
        end)
      end)
    end
    
    add(frame)
  end
end

function buildingsUI.close()
  for _,v in pairs(u.UIelements) do
    v:Remove()
  end
  u.UIelements = {}
  --loveframes.util.RemoveAll()
end

function buildingsUI.performMainAction()
  if u.currentBuilding == 1 then
    local needed = math.floor((p.tanksize - p.fuel) * u.fuelPrice + 0.5)
    if needed <= p.money then
      p.fuel = p.tanksize
      p.money = p.money - needed
    else
      p.fuel = math.floor(p.fuel + p.money / u.fuelPrice + 0.5)
      p.money = 0
    end
  elseif u.currentBuilding == 2 then
    for i = 1,#p.cargo do
      p.money = p.money + p.cargo[i] * world.ores[i].value
      p.cargo[i] = 0
    end
    p.cargoUsed = 0
  elseif u.currentBuilding == 4 then
    local needed = math.floor((p.maxhealth - p.health) * u.hullPrice + 0.5)
    if needed <= p.money then
      p.health = p.maxhealth
      p.money = p.money - needed
    else
      p.health = math.floor(p.health + p.money / u.hullPrice + 0.5)
      p.money = 0
    end
    --p.health = p.health - 1
    progressbar:SetValue(p.health)
  end
  if u.currentBuilding ~= 4 then
    buildings.closeUI()
  end
end

--[[function buildingsUI.draw()
  --love.graphics.setFont(font.normal)
  if u.currentBuilding == 1 then
    love.graphics.setColor(190,190,190)
    love.graphics.rectangle("fill",camera.x+190,camera.y+90,420,420)
    love.graphics.setColor(90,90,90)
    love.graphics.rectangle("line",camera.x+190,camera.y+90,420,420)
    
    love.graphics.setColor(30,30,30)
    love.graphics.print("Press space to fill up on fuel, yo",camera.x+200,camera.y+100)
  elseif u.currentBuilding == 2 then
    love.graphics.setColor(190,190,190)
    love.graphics.rectangle("fill",camera.x+190,camera.y+90,420,420)
    love.graphics.setColor(90,90,90)
    love.graphics.rectangle("line",camera.x+190,camera.y+90,420,420)
    
    local it = 1
    local sum = 0
    for i = 1,#p.cargo do
      if p.cargo[i] > 0 then
        love.graphics.setColor(255,255,255)
        love.graphics.draw(world.ores[i].image,camera.x+200,camera.y+60+40*it)
        love.graphics.setColor(30,30,30)
        love.graphics.print(world.ores[i].name,camera.x+250,camera.y+60+40*it)
        love.graphics.print(p.cargo[i],camera.x+330,camera.y+60+40*it)
        love.graphics.print("x",camera.x+343,camera.y+60+40*it)
        love.graphics.print(world.ores[i].value,camera.x+350,camera.y+60+40*it)
        --world.ores[i].value
        it = it + 1
        sum = sum + world.ores[i].value * p.cargo[i]
      end
    end
    love.graphics.setColor(30,30,30)
    love.graphics.print("Total: "..sum..". Press space to confirm.", camera.x+200, camera.y+495)
  end
end]]