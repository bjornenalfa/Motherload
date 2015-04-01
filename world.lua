world = {}
local w = world

function addOre(n,m,d,v,multi)
  if multi == nil then multi = 1 end
  table.insert(w.ores,{name=n,image=image[n],mean=m,deviation=d,value=v,multi=multi})
end

w.ores = {}

--[[addOre("iron",0,20,15)
addOre("bronze",20,20,25)        -- 1.667       , 26
addOre("silver",40,20,50)        -- 2,     3.333, 45
addOre("gold",60,20,80)          -- 1.6,   3.2  , 78
addOre("platinum",80,20,120)     -- 1.5,   2.4  , 135
addOre("einsteinium",100,20,150) -- 1.25,  1.875, 234
addOre("emerald",120,20,200)     -- 1.333, 1.667, 405
addOre("mithril",140,20,250)     -- 1.25,  1.667, 701
addOre("ruby",160,20,330)        -- 1.32,  1.65 , 1215
addOre("adamant",180,20,420)     -- 1.272, 1.68 , 2104]]

--[[addOre("iron",0,30,15)
addOre("bronze",30,30,26)        -- 1.667       , 26
addOre("silver",60,30,45)        -- 2,     3.333, 45
addOre("gold",90,30,78)          -- 1.6,   3.2  , 78
addOre("platinum",120,30,135)     -- 1.5,   2.4  , 135
addOre("einsteinium",150,30,234) -- 1.25,  1.875, 234
addOre("emerald",180,30,405)     -- 1.333, 1.667, 405
addOre("mithril",210,30,701)     -- 1.25,  1.667, 701
addOre("ruby",240,30,1215)        -- 1.32,  1.65 , 1215
addOre("adamant",270,30,2104)     -- 1.272, 1.68 , 2104
addOre("diamond",300,30,3645)
addOre("wolfram",330,30,6312)
addOre("amazonite",360,30,10935)
addOre("galvorn",390,30,18936)
addOre("juvelium",420,30,32805)
addOre("death metal",450,30,56808)
addOre("silima",480,30,98415)
addOre("unobtainium",510,30,170424)
addOre("tilkal",540,30,295245)
addOre("legendarium",570,30,511272)]]

addOre("iron",0,30,13)
addOre("bronze",30,30,23)
addOre("silver",60,30,43)
addOre("gold",90,30,73)
addOre("platinum",120,30,131)
addOre("einsteinium",150,30,233)
addOre("emerald",180,30,401)
addOre("mithril",210,30,701)
addOre("ruby",240,30,1213)
addOre("adamant",270,30,2099)
addOre("diamond",300,30,3643)
addOre("wolfram",330,30,6311)
addOre("amazonite",360,30,10909)
addOre("galvorn",390,30,18919)
addOre("juvelium",420,30,32803)
addOre("death metal",450,30,56807)
addOre("silima",480,30,98411)
addOre("unobtainium",510,30,170413)
addOre("tilkal",540,30,295237)
addOre("legendarium",570,30,511261,0.9)
addOre("psykadelium",600,30,885530,0.1)

addOre("upgrade",0,0,0,0)

--UnObtainables
addOre("lava",600,150,0,9)
addOre("gaspocket",600,100,0,4)
addOre("stone",600,210,0,17)

w.nonOres = 4

w.probAcc = 100000

w.skyGradient = gradient.new({direction="horizontal", {78, 141, 227}, {78, 197, 227}})

w.stonevals = {math.random(-10,10),math.random(-10,10),math.random(-10,10),math.random(-10,10),math.random(-10,10),math.random(-10,10),math.random(-10,10)}

function normalDist(y,mean,deviation)
  return (1/deviation*2.50662827463)*math.exp(-((y-mean)^2)/(2*(deviation^2)))
end

local multi = 1
w.width = 60 * multi
w.height = 600 * multi
w.scale = 40 / multi
w.terrain = {}
for x = 1,w.width do
  w.terrain[x] = {}
  for y = 1,w.height do
    w.terrain[x][y] = 0
  end
end

for y = 1,w.height do
  local dist = {}
  for _,v in pairs(w.ores) do
    table.insert(dist,normalDist(y,v.mean,v.deviation)*v.multi)
  end
  for x = 1,w.width do
    local terr = 0
    for _,v in pairs(dist) do
      if math.random(0,w.probAcc) < (math.floor(v*1000000)/1000000) * w.probAcc / 3 then
        terr = _
        break
      end
    end
    if terr == 0 and math.random(1,15) == 1 then
      terr = nil
    end
    if y == 1 then
      terr = 0
    elseif y == w.height then
      terr = #w.ores
    end
    w.terrain[x][y] = terr
  end
end

w.upgradeID = 0
for _,v in pairs(w.ores) do
  if v.name == "upgrade" then
    w.upgradeID = _
    break
  end
end
for i=1,7 do
  local x,y
  repeat
    x = math.random(1,w.width)
    y = math.random(300,w.height-1)
  until w.terrain[x][y] ~= w.upgradeID
  w.terrain[x][y] = w.upgradeID
end

function w.calcBitMask(x,y)
  num = 0
  pcall(function () 
      num = num + (w.terrain[x][y-1] and 1 or 0)
      num = num + (w.terrain[x+1][y] and 2 or 0)
      num = num + (w.terrain[x][y+1] and 4 or 0)
      num = num + (w.terrain[x-1][y] and 8 or 0)
  end)
  w.bitmask[x][y] = num
end

function w.updateBitMask(x,y)
  pcall(function ()
    w.calcBitMask(x,y)
    w.calcBitMask(x-1,y)
    w.calcBitMask(x+1,y)
    w.calcBitMask(x,y-1)
    w.calcBitMask(x,y+1)
  end)
end

w.bitmask = {}
for x = 1,w.width do
  w.bitmask[x] = {}
  for y = 1,w.height do
    w.calcBitMask(x,y)
  end
end

--[[w.terrain[2][2] = nil
w.terrain[3][2] = nil
w.terrain[3][3] = nil]]

local stars = {}
for i = 1,50 do
  local x,y = math.random(0,800), math.random(0,600)
  table.insert(stars,{x=x,y=y,l=math.sqrt(x^2+y^2),a=math.atan2(y,x),r=math.random(1,3)})
end

function world.draw()
  if camera.y < 0 then
    local shade = 255*0.99^(-p.y/100)
    if p.y > 29 then
      shade = 255
    end
    love.graphics.setColor(shade,shade,shade)
    gradient.drawinrect(w.skyGradient,camera.x,camera.y,width,height)
    
    if camera.y < -10000 then
      love.graphics.setColor(255,255,255,math.min(255,(10000+camera.y)*-0.01))
      for _,v in pairs(stars) do
        love.graphics.setPointSize(v.r)
        --local x,y = math.cos(v.a+time/60)*v.l, math.sin(v.a+time/60)*v.l
        --love.graphics.point(camera.x+(x-camera.x*0.01)%800,camera.y+(y-camera.y*0.003)%600)
        love.graphics.point(camera.x+(v.x-camera.x*0.01*v.r)%800,camera.y+(v.y-camera.y*0.003*v.r)%600)
      end
    end
  end
  if false then
    for x = 1,w.width do
      for y = 1,w.height do
        love.graphics.setPointSize(2)
        love.graphics.setPointStyle("rough")
        local v = w.terrain[x][y]
        if v == nil then
          love.graphics.setColor(100,70,60)
        elseif v == 0 then
          love.graphics.setColor(150,110,100)
        elseif v == 1 then
          love.graphics.setColor(150,150,150)
        elseif v == 2 then
          love.graphics.setColor(255,150,50)
        elseif v == 3 then
          love.graphics.setColor(210,210,210)
        elseif v == 4 then
          love.graphics.setColor(210,210,100)
        end
        love.graphics.point(x*2+0.5,y*2+0.5)
      end
    end
  else
    local a,b,c,d = camera.getBlockBounds()
    for x = a,c do
      for y = b,d do
        pcall(function()
          local terr = w.terrain[x][y]
          if terr then
            love.graphics.setColor(255,255,255)
            
            love.graphics.draw(image.dirt,image.dirtQuads[x%image.dirtScale+(y%image.dirtScale)*image.dirtScale+1],(x-1)*w.scale,(y-1)*w.scale)
            if ((x+w.stonevals[1])%5 + (x+w.stonevals[2])%13 - (x+w.stonevals[3])%2 - (y+w.stonevals[4])%3 + (y+w.stonevals[5])%7 + (y+w.stonevals[6])%11) == 0 then
              love.graphics.draw(image.stones,(x-1)*w.scale,(y-1)*w.scale)
            end
            if y == 1 then
              love.graphics.draw(image.grass,(x-1)*w.scale,(y-1)*w.scale)
            --elseif terr == 1 then
              --love.graphics.setColor(50,50,50)
              --love.graphics.rectangle("fill",(x-1)*w.scale,(y-1)*w.scale,w.scale,w.scale)
              --love.graphics.draw(image.dirt,image.dirtQuads[x%image.dirtScale+(y%image.dirtScale)*image.dirtScale+1],(x-1)*w.scale,(y-1)*w.scale)
              --love.graphics.setColor(70,70,70)
              --love.graphics.rectangle("line",(x-1)*w.scale,(y-1)*w.scale,w.scale,w.scale)
              --love.graphics.circle("fill",(x-1)*w.scale+w.scale/2,(y-1)*w.scale+w.scale/2,w.scale/2)
            else
              if terr == 21 then
                love.graphics.setColor(functions.HSV((time+x*89-y*71+p.x*0.01+p.y*0.01)*80,100,255))
              end
              love.graphics.draw(w.ores[terr].image,(x-1)*w.scale,(y-1)*w.scale)
              --gradient.drawinrect(w.ores[terr].image,(x-1)*w.scale,(y-1)*w.scale,w.scale,w.scale)
            end
          elseif y > 1 then
            love.graphics.setColor(100,100,100)
            love.graphics.draw(image.dirt,image.dirtQuads[x%image.dirtScale+(y%image.dirtScale)*image.dirtScale+1],(x-1)*w.scale,(y-1)*w.scale)
            love.graphics.setColor(255,255,255)
            love.graphics.draw(image.roundDirt[w.bitmask[x][y]],image.dirtQuads[x%image.dirtScale+(y%image.dirtScale)*image.dirtScale+1],(x-1)*w.scale,(y-1)*w.scale)
          elseif y == 1 then
            love.graphics.setColor(100,100,100)
            love.graphics.draw(image.dirt,image.dirtQuads[x%image.dirtScale+(y%image.dirtScale)*image.dirtScale+1],(x-1)*w.scale,(y-1)*w.scale)
            love.graphics.setColor(255,255,255)
            love.graphics.draw(image.roundDirt[w.bitmask[x][y]],image.dirtQuads[x%image.dirtScale+(y%image.dirtScale)*image.dirtScale+1],(x-1)*w.scale,(y-1)*w.scale)
            love.graphics.setColor(100,100,100)
            love.graphics.draw(image.grass,(x-1)*w.scale,(y-1)*w.scale)
            
          end
          --love.graphics.setColor(255,255,0)
          --love.graphics.print(w.bitmask[x][y],(x-1)*w.scale,(y-1)*w.scale)
        end)
        --[[pcall(function()
          love.graphics.setColor(255,255,0)
          love.graphics.print(w.bitmask[x][y],(x-1)*w.scale,(y-1)*w.scale)
        end)]]
      end
    end
  end
end