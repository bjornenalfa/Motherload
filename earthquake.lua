earthquake = {}
local e = earthquake

e.particles = love.graphics.newParticleSystem(image.dirtParticle, 30)
local ep = e.particles
--ep:stop()
ep:setDirection(0)
ep:setEmissionRate(0)
ep:setParticleLifetime(0.5,1)
ep:setRadialAcceleration(5,10)
ep:setSizes(0.5,1.5,1)
ep:setSpeed(20,50)
ep:setSpin(0,10)
ep:setSpinVariation(1)
ep:setSpread(math.pi*2)
ep:setLinearAcceleration(0,0)
ep:setColors(250,250,250)
ep:setOffset(image.dirtParticle:getWidth()/2,image.dirtParticle:getHeight()/2)
ep:setRelativeRotation(true)
ep:setBufferSize(10000)

e.shaking = false
e.time = 0
e.endResult = {}
e.pDepth = 0

function earthquake.start()
  e.shaking = true
  e.time = 3
  
  e.shuffle()
  for x = 1,world.width do
    e.endResult[x] = {}
    for y = 1,world.height do
      e.endResult[x][y] = world.terrain[x][y]
    end
  end
  
  floattext.new("!!!",camera.x+400,camera.y+260,{255,0,0},font.x40)
  floattext.new("EARTHQUAKE",camera.x+400,camera.y+300,{255,0,0},font.x40)
  floattext.new("!!!",camera.x+400,camera.y+340,{255,0,0},font.x40)
end

function earthquake.stop()
  e.shaking = false
  for x = 1,world.width do
    for y = 1,world.height do
      world.terrain[x][y] = e.endResult[x][y]
    end
  end
  world.bitmask = {}
  for x = 1,world.width do
    world.bitmask[x] = {}
    for y = 1,world.height do
      world.calcBitMask(x,y)
    end
  end
end

function earthquake.shuffle()
  for y = 2,world.height-1 do
    local dist = {}
    for _,v in pairs(world.ores) do
      table.insert(dist,normalDist(y,v.mean,v.deviation)*v.multi)
    end
    local rand = math.random(0,2)
    if rand == 0 then
      for x = 1,world.width-1 do
        world.terrain[x][y] = world.terrain[x+1][y]
      end
      local terr = 0
      for _,v in pairs(dist) do
        if math.random(0,world.probAcc) < (math.floor(v*1000000)/1000000) * world.probAcc / 3 then
          terr = _
          break
        end
      end
      if terr == 0 and math.random(1,15) == 1 then
        terr = nil
      end
      world.terrain[world.width][y] = terr
    elseif rand == 1 then
      for x = world.width,2,-1 do
        world.terrain[x][y] = world.terrain[x-1][y]
      end
      local terr = 0
      for _,v in pairs(dist) do
        if math.random(0,world.probAcc) < (math.floor(v*1000000)/1000000) * world.probAcc / 3 then
          terr = _
          break
        end
      end
      if terr == 0 and math.random(1,15) == 1 then
        terr = nil
      end
      world.terrain[1][y] = terr
    end
  end
  local a,b,c,d = camera.getBlockBounds()
  for x = a,c do
    for y = b,d do
      pcall(function()
        local terr = world.terrain[x][y]
        if terr then
          earthquake.particles:setPosition(x*40-20,y*40-20)
          earthquake.particles:emit(1)
        end
      end)
    end
  end
end

e.depthmod = 0

function earthquake.update(dt)
  earthquake.particles:update(dt)
  if p.y > e.pDepth then
    e.pDepth = p.y
  elseif p.y <= -15 and e.pDepth > 9000 then
    if math.random(0,world.height*40) < (e.pDepth+e.depthmod)*0.25 then
      e.depthmod = 0
      e.start()
    else
      e.depthmod = e.depthmod + e.pDepth * 1
    end
    e.pDepth = 0
  end
  if e.shaking then
    local dx,dy = math.random(-20,20)*(1.5^(e.time-1)),math.random(-20,20)*(1.5^(e.time-1))
    camera.move(dx,dy)
    local x,y = love.window.getPosition()
    --love.window.setPosition(x+dx,y+dy)
    e.time = e.time - dt
    if e.time <= 0 then
      e.stop()
    --elseif e.time >= 2.7 then
      --floattext.new("!!!",camera.x+400,camera.y+260,{255,0,0},font.x40)
      --floattext.new("EARTHQUAKE",camera.x+400,camera.y+300,{255,0,0},font.x40)
      --floattext.new("!!!",camera.x+400,camera.y+340,{255,0,0},font.x40)
    else
      e.shuffle()
    end
  end
end

function earthquake.draw()
  if e.shaking then
    --
    --love.graphics.translate(math.random(-20,20)*(1.5^(e.time-1)),math.random(-20,20)*(1.5^(e.time-1)))
    --love.graphics.setColor(255,0,0)
    --love.graphics.setFont(font.x20)
    --love.graphics.print("EARTHQUAKE!",200,200)
  end
  love.graphics.setColor(255,255,255)
  love.graphics.draw(earthquake.particles,0,0)
end