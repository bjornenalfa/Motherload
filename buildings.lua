buildings = {}
local b = buildings

b.list = {}

b.UIopen = false
b.currentBuilding = 1
b.UIcooldown = 2

function buildings.add(name,x)
  local i = image[name]
  local bt = {name=name,image=i,x=x,y=-i:getHeight(),w=i:getWidth(),h=i:getHeight()}
  table.insert(b.list, bt)
  for x = math.ceil((x+0.00001)/world.scale), math.ceil((x+bt.w)/world.scale) do
    world.terrain[x][1] = #world.ores+1
  end
end

function buildings.load()
  b.add("fuelstore",240)
  b.add("orestore",680)
  b.add("upgradestore",1120)
  b.add("itemstore",1560)
  --table.insert(b.list,{name="sputnik",image=image.sputnik,x=1000,y=-500,w=200,h=150})
  --b.add("sputnik",1700)
end

function buildings.update(dt)
  if b.UIopen then
    b.UIcooldown = 0
  else
    if b.UIcooldown < 3 then
      b.UIcooldown = b.UIcooldown + dt
    else
      if p.y < 0 and p.y > -17 and math.floor(math.abs(p.xv)*2+0.5) == 0 then
        for _,v in pairs(b.list) do
          if p.x > v.x and p.x < v.x + v.w then
            print(v.name)
            b.openUI(v.name)
          end
        end
      end
    end
  end
end

function buildings.keypressed(key)
  if key == "escape" then
    b.closeUI()
  elseif key == " " or key == "return" then
    buildingsUI.performMainAction()
  end
end

function buildings.openUI(name)
  if name == "fuelstore" then
    b.currentBuilding = 1
  elseif name == "orestore" then
    b.currentBuilding = 2
  end
  b.UIopen = true
  buildingsUI.open(name)
end

function buildings.closeUI()
  b.UIopen = false
  b.UIcooldown = 0
  buildingsUI.close()
end

function buildings.draw()
  if camera.y < 0 then
    love.graphics.setColor(255,255,255)
    for _,v in pairs(b.list) do
      love.graphics.draw(v.image, v.x, v.y)
    end
  end
  if b.UIopen then
    --buildingsUI.draw()
  end
  --love.graphics.draw(image.sellspot,680,-120)
end