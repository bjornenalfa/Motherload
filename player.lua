player = {}
p = player

local warningcooldown = 0

p.x = 1250
p.y = -15
p.r = (world.scale-10)/2
p.xv = 0
p.yv = 0
p.basexacc = 2
p.baseyacc = 3
p.xacc = 2
p.yacc = 3
p.gravity = 3.5
p.resistance = 0.995

p.fuel = 60
p.tanksize = 60

p.health = 200
p.maxhealth = 200
p.radiator = 0

p.money = 100

p.points = 0

p.direction = 1

p.bounce = false

p.drillLevel = #world.ores-1
p.digReady = false
p.digReadyTimer = 0
p.ox = 0
p.oy = 0
p.digging = false
p.digDirection = 0
p.digStartX = 0
p.digStartY = 0
p.baseDigSpeed = 50
p.digSpeed = 50
p.digMA = 0.1
p.digDelay = 0.1

p.cargoSize = 0
p.cargoUsed = 0
p.cargo = {}
if debugMode then
  for i = 1,#world.ores do
    p.cargo[i] = 1
  end
else
  for i = 1,#world.ores do
    p.cargo[i] = 0
  end
end

p.dirtParticles = love.graphics.newParticleSystem(image.dirtParticle, 30)
local dp = p.dirtParticles
dp:stop()
dp:setDirection(0)
dp:setEmissionRate(20)
dp:setParticleLifetime(0.5,1)
dp:setRadialAcceleration(5,10)
dp:setSizes(0.5,1.5,1)
dp:setSpeed(20,50)
dp:setSpin(0,0)
dp:setSpinVariation(1)
dp:setSpread(math.pi*0.5)
dp:setLinearAcceleration(0,0.5)
dp:setColors(250,250,250)
dp:setOffset(image.dirtParticle:getWidth()/2,image.dirtParticle:getHeight()/2)
dp:setRelativeRotation(true)
p.pox = 0
p.poy = 0

function player.init()
  --[[for i = 1,7 do
    upgrades.purchase(i,1)
  end]]
end

function player.update(dt)
  warningcooldown = warningcooldown - dt
  p.fuel = p.fuel - 0.15*dt
  if p.fuel < 0 then
    p.health = p.health + p.fuel * 100
    p.fuel = 0
  end
  if p.fuel/p.tanksize <= 0.1 and warningcooldown <= 0 then
    floattext.new(math.floor((((p.fuel/p.tanksize)*100)+0.5)).."% fuel left",p.x,p.y,{255,0,0})
    warningcooldown = 1.5
  end
  if p.health/p.maxhealth <= 0.1 and warningcooldown <= 0 then
    floattext.new(math.floor((((p.health/p.maxhealth)*100)+0.5)).."% hull left",p.x,p.y,{255,0,0})
    warningcooldown = 1.5
  end
  if p.health <= 0 then
    p.health = 0
    if not debugMode then return end
  end
  if not p.digging then
    
    p.xacc = p.basexacc * ((p.basexacc+60)/(3.8+60))^p.cargoUsed
    p.yacc = p.baseyacc * ((p.baseyacc+60)/(3.8*2.05+60))^p.cargoUsed
    
    p.yv = p.yv * (p.resistance ^ (dt * 60))
    
    local xvchange = 0
    if love.keyboard.isDown("left") then
      xvchange = - p.xacc * dt
    end
    if love.keyboard.isDown("right") then
      xvchange = xvchange + p.xacc * dt
    end
    if love.keyboard.isDown("up") then
      p.yv = p.yv - (p.yacc+p.gravity) * dt
    end
    if love.keyboard.isDown("down") then
      p.yv = p.yv + (p.yacc+p.gravity) * dt * 0.4
    end
    p.xv = p.xv + xvchange
    if xvchange < 0 then
      p.direction = 0
    elseif xvchange > 0 then
      p.direction = 1
    end
    
    if debugMode then
      pcall(function()
        if love.keyboard.isDown("w") then
          world.terrain[math.ceil(p.x/world.scale)][math.ceil(p.y/world.scale)-1] = nil
        elseif love.keyboard.isDown("a") then
          world.terrain[math.ceil(p.x/world.scale)-1][math.ceil(p.y/world.scale)] = nil
        elseif love.keyboard.isDown("s") then
          world.terrain[math.ceil(p.x/world.scale)][math.ceil(p.y/world.scale)+1] = nil
        elseif love.keyboard.isDown("d") then
          world.terrain[math.ceil(p.x/world.scale)+1][math.ceil(p.y/world.scale)] = nil
        end
      end)
    end
    
    local s = world.scale
    local x = math.ceil(p.x/s)
    local y = math.ceil(p.y/s)
    
    p.x = p.x + p.xv * (dt * 60)
    p.y = p.y + p.yv * (dt * 60)
    
    --print(x..":"..time.."."..tostring(world.terrain[x]))
    if not noclip then
      if world.terrain[x][y] then
        p.checkFallDamage()
        p.x = p.x - p.xv * (dt * 60) * 2
        p.y = p.y - p.yv * (dt * 60) * 2
        p.xv = p.xv * -1
        p.yv = p.yv * -1
      end
    end
    
    if p.y < world.height * s and world.terrain[x][y+1] and p.y + p.r >= y*s then
      p.xv = p.xv * (0.98 ^ (dt * 60))
    else
      p.xv = p.xv * (0.9935 ^ (dt * 60))
      if not noclip then p.yv = p.yv + p.gravity*dt end
    end
    
    if p.x - p.r < 0 then
      p.x = p.r
      p.xv = p.bounce and -p.xv or 0
    elseif p.x + p.r > world.width * s then
      p.x = world.width * s - p.r
      p.xv = p.bounce and -p.xv or 0
    end
    --p.x = p.x%(world.width*40)
    --[[if p.y - p.r < 0 then
      p.y = p.r
    else]]if p.y + p.r > world.height * s then
      p.y = world.height * s - p.r
      p.yv = p.bounce and -p.yv or 0
    end
    
    local x = math.ceil(p.x/s)
    local y = math.ceil(p.y/s)
    
    if not noclip then
      if p.x < world.width * s -s and world.terrain[x+1][y] then
        if p.x + p.r > x*s then
          p.x = x*s - p.r
          p.xv = p.bounce and -p.xv or 0
        end
      end
      if p.x > s and world.terrain[x-1][y] then
        if p.x - p.r < x*s-s then
          p.x = x*s + p.r -s
          p.xv = p.bounce and -p.xv or 0
        end
      end
      if p.y < world.height * s and world.terrain[x][y+1] then
        if p.y + p.r > y*s then
          p.checkFallDamage()
          p.y = y*s - p.r
          p.yv = p.bounce and -p.yv or 0
        end
      end
      if p.y > s and world.terrain[x][y-1] then
        if p.y - p.r < y*s-s then
          p.y = y*s + p.r - s
          p.yv = p.bounce and -p.yv or 0
        end
      end
      
      if world.terrain[x][y+1] and math.floor(p.x*p.digMA)/p.digMA == p.ox and math.floor(p.y*p.digMA)/p.digMA == p.oy then
        p.digReadyTimer = p.digReadyTimer + dt
      else
        p.digReadyTimer = 0
        p.digReady = false
      end
      if p.digReadyTimer > p.digDelay then
        p.digReady = true
      end
    end
    
    p.dirtParticles:update(dt)
    
    p.ox = math.floor(p.x*p.digMA)/p.digMA
    p.oy = math.floor(p.y*p.digMA)/p.digMA
    if p.digReady and not noclip then
      pcall(function()
      if love.keyboard.isDown("left") and world.terrain[math.ceil((p.x+(s-p.r))/s)-1][y] <= p.drillLevel and p.yv == 0 then
        p.digDirection = 0
        p.digStartX = x
        p.startDigging()
      elseif love.keyboard.isDown("right") and world.terrain[math.ceil((p.x-(s-p.r-1))/s)+1][y] <= p.drillLevel and p.yv == 0 then
        p.digDirection = 1
        p.digStartX = x
        p.startDigging()
      --[[elseif love.keyboard.isDown("up") and world.terrain[x][y-1] <= p.drillLevel then
        p.digDirection = 2
        p.digStartY = y
        p.digging = true]]
      elseif love.keyboard.isDown("down") and world.terrain[x][math.ceil((p.y-(s-p.r-1))/s)+1] <= p.drillLevel then
        p.digDirection = 3
        p.digStartX = x
        p.digStartY = y
        p.startDigging()
      end
      end)
    end
  else
    p.fuel = p.fuel - 2.2*dt
    p.digSpeed = p.baseDigSpeed * (1 - (p.y / (world.height * 60)))
    
    p.dirtParticles:setPosition(p.x+p.pox,p.y+p.poy)
    p.dirtParticles:update(dt)
    if p.digDirection == 0 then
      p.x = p.x - p.digSpeed * dt
      if math.ceil((p.x+p.r)/world.scale) < p.digStartX then
        p.stopDigging()
        p.xv = -p.digSpeed*dt
      end
    end
    if p.digDirection == 1 then
      p.x = p.x + p.digSpeed * dt
      if math.ceil((p.x-p.r)/world.scale) > p.digStartX then
        p.stopDigging()
        p.xv = p.digSpeed*dt
      end
    end
    --[[if p.digDirection == 2 then
      p.y = p.y - p.digSpeed * dt
      if math.ceil((p.y+p.r)/world.scale) < p.digStartY then
        p.digging = false
        world.terrain[math.ceil(p.x/world.scale)][math.ceil(p.y/world.scale)] = nil
      end
    end]]
    if p.digDirection == 3 then 
      p.y = p.y + p.digSpeed * dt
      p.x = p.x + (p.digStartX*world.scale - 20 - p.x) * dt
      if math.ceil((p.y-p.r)/world.scale) > p.digStartY then
        p.stopDigging()
        p.yv = p.digSpeed*dt
      end
    end
  end
  --world.terrain[math.ceil(p.x/world.scale)][math.ceil(p.y/world.scale)] = 0
end

function player.checkFallDamage()
  if p.yv > 4 then
    p.health = p.health - ((p.yv-3)^2)*20
    print("Fall damage: "..(((p.yv-3)^2)*20).."yv: "..p.yv)
  end
end

function player.startDigging()
  p.digging = true
  if p.digDirection == 0 then
    p.direction = 0
    p.pox = -p.r*2
    p.poy = 0
    p.dirtParticles:setDirection(0)
  elseif p.digDirection == 1 then
    p.direction = 1
    p.pox = p.r*2
    p.poy = 0
    p.dirtParticles:setDirection(math.pi)
  elseif p.digDirection == 3 then
    p.pox = 0
    p.poy = p.r*2
    p.dirtParticles:setDirection(3*math.pi/2)
  end
  p.dirtParticles:start()
  --p.dirtParticles:emit(10)
end

function player.stopDigging()
  p.digging = false
  p.dirtParticles:stop()
  local x, y = math.ceil(p.x/world.scale), math.ceil(p.y/world.scale)
  local ore = world.terrain[x][y]
  if ore == nil then return floattext.new("how the fuck did you just dig air",p.x,p.y) end
  if ore == 0 then
    floattext.new("+"..50,p.x,p.y-12)
    p.points = p.points + 50
  else
    if ore ~= world.upgradeID then
      floattext.new(world.ores[ore].name,p.x,p.y)
    end
    if ore <= #world.ores-world.nonOres then
      floattext.new("+"..math.floor((ore^1.5)*100),p.x,p.y-12)
      p.points = p.points + math.floor((ore^1.5)*100)
      if p.cargoUsed < p.cargoSize then
        p.cargoUsed = p.cargoUsed + 1
        p.cargo[ore] = p.cargo[ore] + 1
        --floattext.new(world.ores[ore].name,p.x,p.y)
      end
      if p.cargoUsed >= p.cargoSize then
        local finito = math.random(0,100);--#YOLO @authhor(McGregor)
        if finito == 100 then 
          floattext.new("You derped and filled your cargo with junk",p.x,p.y-10,{255,21,84})
        else
          floattext.new("Cargo bay is full",p.x,p.y-10,{255,0,0})
        end
      end
    elseif ore == #world.ores-1 then
      explosion.explode(x,y,1,false)
      p.health = p.health - (80+math.random(0,40))*(1-(p.radiator*0.8))
      floattext.new("-5000",p.x,p.y-12)
      p.points = p.points - 5000
    elseif ore == #world.ores-2 then
      p.health = p.health - (100+math.random(0,60))*(1-p.radiator)
      floattext.new("-2500",p.x,p.y-12)
      p.points = p.points - 2500
    elseif ore == world.upgradeID then
      local upgradesLeft = {}
      for i = 1,7 do
        if upgrades.unlocked[i] == 8 then
          table.insert(upgradesLeft,i)
        end
      end
      local up = upgradesLeft[math.random(1,#upgradesLeft)]
      upgrades.unlocked[up] = 9
      floattext.new("Unlocked "..upgrades.list[up][9].name,p.x,p.y)
    end
  end
  world.terrain[x][y] = nil
  world.updateBitMask(x,y)
end

function player.keypressed(key)
  if key == "x" then
    --player.explode(1,false)
  elseif key == "c" then
    --player.explode(3,true)
  elseif key == "n" then
    --player.explode(10,true)
  --elseif key == "end" then
  --  player.explode(400,true)
  --elseif key == "b" and debugMode then
  --  p.bounce = not p.bounce
  end
end

function player.explode(r,round,o)
  local x, y = math.ceil(p.x/world.scale), math.ceil(p.y/world.scale)
  if not p.digging and world.terrain[x][math.ceil((p.y-(world.scale-p.r-1))/world.scale)+1] then
    explosion.explode(x,y,r,round,o)
    return true
  end
end

function player.draw()
  love.graphics.setColor(150,150,150)
  if p.digging then
    ox = math.random(-2,2)
    oy = math.random(-2,2)
    love.graphics.translate(ox,oy)
    --love.graphics.circle("fill",p.x+math.random(-2,2),p.y+math.random(-2,2),p.r)
  else
    --love.graphics.circle("fill",p.x,p.y,p.r)
  end
  --[[love.graphics.circle("fill",p.x,p.y,p.r)
  love.graphics.setColor(0,0,0)
  love.graphics.line(p.x,p.y-p.r,p.x,p.y+p.r)
  love.graphics.line(p.x-p.r,p.y,p.x+p.r,p.y)]]
  love.graphics.setColor(255,0,0)
  love.graphics.print("x: "..math.ceil(p.x).."\ny: "..math.ceil(p.y),camera.x,camera.y)
  --[[love.graphics.print("xv: "..p.xv.."\nyv: "..p.yv,camera.x,camera.y)
  love.graphics.print("digReadyTimer: "..p.digReadyTimer.."\ndigReady: "..tostring(p.digReady),camera.x,camera.y+30)
  love.graphics.print("digDirection: "..p.digDirection.."\ndigging: "..tostring(p.digging),camera.x,camera.y+60)
  love.graphics.print("x: "..math.ceil(p.x/world.scale).."\ny: "..math.ceil(p.y/world.scale),camera.x,camera.y+90)]]
  --love.graphics.circle("line",p.x+p.r,p.y+p.r,p.r)
  love.graphics.setColor(255,255,255)
  if p.digging and p.digDirection == 3 then
    love.graphics.draw(image.drill,p.x+p.r,p.y+p.r/2,math.pi/2)
  elseif p.direction == 0 then
    love.graphics.draw(image.drill,p.x-p.r/2,p.y+p.r,math.pi)
  else
    love.graphics.draw(image.drill,p.x+p.r/2,p.y-p.r)
  end
  
  if not p.digging and love.keyboard.isDown("up") and not love.keyboard.isDown("down") then
    love.graphics.draw(image.flame,p.x-p.r,p.y+p.r-5)
  end
  
  --love.graphics.setColor(255,255,255)
  if p.direction == 0 then
    love.graphics.draw(image.player,p.x+p.r,p.y-p.r,0,-1,1)
  else
    love.graphics.draw(image.player,p.x-p.r,p.y-p.r)
  end
  
  love.graphics.draw(image.bands[math.floor(p.x%8+1)],p.x-p.r-3,p.y-p.r)
  
  if p.digging then
    love.graphics.translate(-ox,-oy)
  end
  love.graphics.draw(p.dirtParticles,0,0)
  love.graphics.setColor(0,255,0)
  --love.graphics.print(normalDist(math.floor(p.y/world.scale),world.ores[1].mean,world.ores[1].deviation),camera.x+100,camera.y)
  --love.graphics.print(table.concat(p.cargo,"\n"),camera.x,camera.y+30)
end