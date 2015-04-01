floattext = {}
local f = floattext

f.list = {}
f.killist = {}

function floattext.update(dt)
  for _,v in pairs(f.list) do
    v.y = v.y - 30*dt
    v.life = v.life + dt
    if v.life > 3 then
      table.insert(f.killist,_)
    end
  end
  for i = #f.killist,1,-1 do
    table.remove(f.list,f.killist[i])
  end
  f.killist = {}
end

function floattext.new(text,x,y,color,fon)
  if not color then color = {255,255,255} end
  if not fon then fon = font.x10 end
  table.insert(f.list,{text=text,x=x,y=y,color=color,font=fon,life=0})
end

function floattext.draw()
  for _,v in pairs(f.list) do
    love.graphics.setFont(v.font)
    love.graphics.setColor(v.color[1],v.color[2],v.color[3],(1-(v.life/3))*255)
    love.graphics.print(v.text,v.x-v.font:getWidth(v.text)/2,v.y)
  end
  love.graphics.setFont(font.normal)
end