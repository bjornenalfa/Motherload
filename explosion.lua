explosion = {}
local e = explosion

e.particles = love.graphics.newParticleSystem(image.explosion, 30)
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
ep:setOffset(image.explosion:getWidth()/2,image.explosion:getHeight()/2)
ep:setRelativeRotation(true)
ep:setBufferSize(10000)

function explosion.explode(a,b,r,round,ores)
  if round then
    local rsq = r*r
    for x = a-r,a+r do
      for y = b-r,b+r do
        if (a-x)*(a-x) + (b-y)*(b-y) <= rsq then
          pcall(function()
            if world.terrain[x][y] and world.terrain[x][y] ~= #world.ores+1 then
              if ores then
                local r
                repeat
                  r = math.random(0,#world.ores)
                until r ~= world.upgradeID
                world.terrain[x][y] = r
              else
                world.terrain[x][y] = nil
                world.updateBitMask(x,y)
              end
              e.particles:setPosition(x*40-20,y*40-20)
              e.particles:emit(10)
            end
          end)
        end
      end
    end
  else
    for x = a-r,a+r do
      for y = b-r,b+r do
        pcall(function()
          if world.terrain[x][y] and world.terrain[x][y] ~= #world.ores+1 then
            world.terrain[x][y] = nil
            world.updateBitMask(x,y)
            e.particles:setPosition(x*40-20,y*40-20)
            e.particles:emit(10)
          end
        end)
      end
    end
  end
end

function explosion.update(dt)
  e.particles:update(dt)
end

function explosion.draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(e.particles,0,0)
end