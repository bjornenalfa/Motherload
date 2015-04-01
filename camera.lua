camera = {}
local c = camera

c.width = love.window.getWidth()
c.height = love.window.getHeight()
c.x = 0
c.y = 0
c.edgeDis = world.scale*4

c.manual = false

function camera.move(arg1,arg2)
  if type(arg1) == "string" then
    if arg1 == "up" then
      c.y = c.y - arg2
    elseif arg1 == "down" then
      c.y = c.y + arg2
    elseif arg1 == "left" then
      c.x = c.x - arg2
    elseif arg1 == "right" then
      c.x = c.x + arg2
    end
  else
    --arg1,arg2 = arg1 * 0.1, arg2 * 0.1
    c.x = c.x + arg1
    c.y = c.y + arg2
  end
end

function camera.getBound(side)
  if side == "top" then
    return c.y
  elseif side == "left" then
    return c.x
  elseif side == "down" then
    return c.y + c.height
  elseif side == "right" then
    return c.x + c.width
  end
end

function camera.getBounds()
  return c.x, c.y, c.x + c.width, c.y + c.height
end

function camera.getBlockBounds()
  return math.ceil(c.x/world.scale), math.ceil(c.y/world.scale), math.ceil((c.x + c.width)/world.scale), math.ceil((c.y + c.height)/world.scale)
end

function camera.update(dt)
  if c.manual then
    if love.keyboard.isDown("a") then
      camera.move("left",1000*dt)
    end
    if love.keyboard.isDown("w") then
      camera.move("up",1000*dt)
    end
    if love.keyboard.isDown("d") then
      camera.move("right",1000*dt)
    end
    if love.keyboard.isDown("s") then
      camera.move("down",1000*dt)
    end
    c.x = math.max(math.min(math.max(math.min(c.x,world.width*world.scale-c.width),0),p.x-c.edgeDis),p.x-c.width+c.edgeDis)
    c.y = math.max(math.min(c.y,p.y-c.edgeDis),p.y-c.height+c.edgeDis)
    
    c.x = math.max(math.min(c.x,world.width*world.scale-c.width),0)
  else
    if p.x - c.x < c.edgeDis and c.x > 0 then
      camera.move(p.x - c.x - c.edgeDis,0)
    elseif p.x - c.x > c.width - c.edgeDis and c.x + c.width < world.width*world.scale then
      camera.move(p.x - c.x - c.width + c.edgeDis ,0)
    end
    if p.y - c.y < c.edgeDis --[[and c.y > 0]] then
      camera.move(0,p.y - c.y - c.edgeDis)
    elseif p.y - c.y > c.height - c.edgeDis and c.y + c.height < world.height*world.scale then
      camera.move(0,p.y - c.y - c.height + c.edgeDis)
    end
    
    c.x = math.max(math.min(c.x,world.width*world.scale-c.width),0)
    --c.y = math.max(math.min(c.y,world.height),0)
  end
end

function camera.draw()
  love.graphics.translate(-math.floor(c.x+.5),-math.floor(c.y+.5))
  love.graphics.setColor(130,130,20)
  love.graphics.rectangle("line",c.x,c.y,c.width,c.height)
  --love.graphics.print("x:"..c.x.."\ny:"..c.y,c.x,c.y)
end