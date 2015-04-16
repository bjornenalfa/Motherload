UI = {}

UI.level = 0

UI.lowest = camera.height*0.1


function UI.draw()
  love.graphics.setColor(255,0,0)
  love.graphics.print("FPS:" .. love.timer.getFPS(),camera.width -55, 2)-- samai
  love.graphics.print("Points:" .. p.points,0,50)
  --love.graphics.print(love.timer.getFPS(),0,0)
  
  love.graphics.print(p.money,0,30)
  
  if UI.level >= 1 then -- Cargo bay meter with background. Here because draworder.
    love.graphics.setColor(100,100,100)
    love.graphics.rectangle("fill",75,7,100,34)
    love.graphics.setColor(10,10,10)
    love.graphics.rectangle("line",75,7,100,34)
    love.graphics.setColor(255,255,255)
    love.graphics.printf(p.cargoUsed.."/"..p.cargoSize,75,19,100,"center")
  end
  
  if UI.level >= 0 then -- Basic meters
    love.graphics.setColor(10,10,10)
    love.graphics.circle("fill",75,25,25)
    love.graphics.setColor(245,245,245)
    love.graphics.circle("fill",75,25,23)
    love.graphics.setColor(10,10,10)
    love.graphics.arc("fill",75,25,23,math.rad(140),math.rad(40))
    love.graphics.setColor(200,40,40)
    love.graphics.line(75,25,75+math.cos((p.fuel/p.tanksize)*math.rad(260)+math.rad(140))*21,25+math.sin((p.fuel/p.tanksize)*math.rad(260)+math.rad(140))*21)
    
    love.graphics.setColor(10,10,10)
    love.graphics.circle("fill",175,25,25)
    love.graphics.setColor(245,245,245)
    love.graphics.circle("fill",175,25,23)
    love.graphics.setColor(10,10,10)
    love.graphics.arc("fill",175,25,23,math.rad(140),math.rad(40))
    love.graphics.setColor(200,40,40)
    love.graphics.line(175,25,175+math.cos((p.health/p.maxhealth)*math.rad(260)+math.rad(140))*21,25+math.sin((p.health/p.maxhealth)*math.rad(260)+math.rad(140))*21)
  end
  if UI.level >= 1 then
    --Mini map
    if p.y < -300 then
      local div = (30/400)*600
      
      love.graphics.setColor(120,0,0)
      love.graphics.line(0,UI.lowest-((p.y+300)/div),40,UI.lowest-((p.y+300)/div))
      
      love.graphics.setColor(0,255,0)
      love.graphics.line(0,camera.height*0.1-((p.y+300)/div),40,camera.height*0.1-((p.y+300)/div))
      
      local rx = (p.x/(world.width*world.scale))*40
      local ry = (p.y/(world.height*world.scale))*camera.height*0.9+camera.height*0.1-((p.y+300)/div)
      love.graphics.setColor(0,0,0)
      love.graphics.setPointSize(5)
      love.graphics.point(rx,ry)
      love.graphics.setColor(255,255,255)
      love.graphics.setPointSize(3)
      love.graphics.point(rx,ry)
    else
      love.graphics.setColor(120,0,0)
      love.graphics.line(0,UI.lowest,40,UI.lowest)
      
      love.graphics.setColor(0,255,0)
      love.graphics.line(0,camera.height*0.1,40,camera.height*0.1)
      
      local rx = (p.x/(world.width*world.scale))*40
      local ry = (p.y/(world.height*world.scale))*camera.height*0.9+camera.height*0.1
      love.graphics.setColor(0,0,0)
      love.graphics.setPointSize(5)
      love.graphics.point(rx,ry)
      love.graphics.setColor(255,255,255)
      love.graphics.setPointSize(3)
      love.graphics.point(rx,ry)
      
      if ry > UI.lowest then
        UI.lowest = ry
      end
    end
  end
  if UI.level >= 2 then -- numerical values
    love.graphics.setColor(255,255,255)
    local fuel = tostring(math.floor(p.fuel+0.5))
    if #fuel == 3 then
      love.graphics.print(fuel,63,35)
    elseif #fuel == 2 then
      love.graphics.print(fuel,67,35)
    elseif #fuel == 1 then
      love.graphics.print(fuel,71,35)
    end
    local hull = tostring(math.floor(p.health+0.5))
    if #hull == 3 then
      love.graphics.print(hull,163,35)
    elseif #hull == 2 then
      love.graphics.print(hull,167,35)
    elseif #hull == 1 then
      love.graphics.print(hull,171,35)
    end
    love.graphics.printf(math.floor(p.digSpeed*10+0.5)/10,75,9,100,"center")
  end
  if UI.level >= 5 then
    local fuelneeded = (40/p.digSpeed)*0.15
    love.graphics.print(fuelneeded,0,200)
  end
  if UI.level >= 6 and p.y>0 then
    --[[local dt = 1/love.timer.getFPS()
    local res = (0.995 ^ (dt / (1 / 60)))
    local maxvps = p.yacc*((res^(10000*love.timer.getFPS())-1)/(res-1))
    local maxvpf = maxvps/love.timer.getFPS()
    local time = (p.y/maxvps)--+2*(maxvpf/math.abs(p.yv)) -- because of time to accelerate!
    local fuelneeded = time*0.15]]
    
    local FPS = love.timer.getFPS()
    local res = (0.995 ^ (60 / FPS))
    
    local frames = 0
    for i = 1,p.y do
      if ((p.yacc/FPS)*(((res*(res^(i-1)))/(res-1))-i))/(res-1)-3800 > p.y then -- yacc per sekund. yv per frame. res per frame.
        frames = i -- -3800 needs to be fixed. Investigate res^(i-1)
        break
      end
    end
    
    local fuelneeded = (frames/FPS)*0.15--((p.yacc/FPS)*(((res*(res^(frames-1)))/(res-1))-frames))/(res-1)-3700--(frames/FPS)*0.15
    
    --p.y=(p.yacc*(((res(res^(frames-1)))/(res-1))-frames))/(res-1)
    
    love.graphics.setColor(0,255,0)
    love.graphics.print(math.floor(fuelneeded*10+0.5)/10,50,100)
    
    --love.graphics.print(p.yv,50,120)
    --love.graphics.print(maxvps,50,132)
  end
end