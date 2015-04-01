items = {}
local i = items

items.list = {
  {name="Dynamite",description="Will blow up all blocks within a radius of 1 block.",price=250,image=image.placeholder},
  {name="C4",description="Will blow up all blocks within a radius of 3 blocks.",price=1000,image=image.placeholder},
  {name="Nanobots",description="Use these to do repair 200 hull points.",price=3000,image=image.placeholder},
  {name="Emergency Fuel",description="Use this to restore 30 liters of fuel.",price=3000,image=image.placeholder},
  {name="Nuke",description="Will blow up all blocks within a radius of 10 blocks.",price=9001,image=image.placeholder},
  {name="Quantum Teleporter",description="Returns you safely to the surface.",price=80000,image=image.placeholder},
  {name="Ores generator",description="Make all the ores everywhere.",price=10000001,image=image.placeholder},
  {name="",description="",price=0,image=image.placeholder},
  {name="",description="",price=0,image=image.placeholder},
  {name="",description="",price=0,image=image.placeholder},
  {name="",description="",price=0,image=image.placeholder},
  {name="Money",description="Got to make a profit somehow",price=100000,image=image.placeholder},
  {name="",description="",price=0,image=image.placeholder},
  {name="",description="",price=0,image=image.placeholder},
  {name="",description="",price=0,image=image.placeholder},
  {name="",description="",price=0,image=image.placeholder}

  }

function items.init()
  for j = 1,#items.list do
    i.inventory[j] = 0
  end
end

i.inventory = {}

function items.purchase(a)
  local item = items.list[a]
  if item.price <= p.money then
    p.money = p.money - item.price
    i.inventory[a] = i.inventory[a] + 1
  end
end

function items.use(a)
  if i.inventory[a] > 0 then
    if items.activate(a) then
      floattext.new("Used "..items.list[a].name,p.x,p.y)
      i.inventory[a] = i.inventory[a] - 1
    else
      floattext.new("Failed to use "..items.list[a].name,p.x,p.y)
    end
  else
    floattext.new("You have no "..items.list[a].name,p.x,p.y)
  end
end

function items.activate(a)
  if a == 1 then
    return player.explode(1,false)
  elseif a == 2 then
    return player.explode(3,true)
  elseif a == 3 then
    p.health = p.health + 200 > p.maxhealth and p.maxhealth or p.health + 200
    return true
  elseif a == 4 then
    p.fuel = p.fuel + 30 > p.tanksize and p.tanksize or p.fuel + 30
    return true
  elseif a == 5 then
    return player.explode(10,true)
  elseif a == 6 then
    if not player.digging then
      p.x = 340
      p.y = -15
      p.xv = 0
      p.yv = 0
      return true
    else
      return false
    end
  elseif a == 7 then
    return player.explode(10,true,true)
  end
end