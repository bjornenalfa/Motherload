upgrades = {}
local u = upgrades

function u.init()
  if debugMode then
    p.money = 100000000
    for i = 1,7 do
      u.purchase(i,9)
    end
  else
    for i = 1,7 do
      u.purchase(i,1)
    end
  end
end

u.list = {
  --HULLS =============================================================================================================
  { {name="Iron Hull",description="The standard mining rig hull made of iron. Not very durable.",price=0,stat=200,image=image.hulls.iron},
    {name="Angmallen Hull",description="Apparently blending some gold with the iron makes it slightly stronger. And a whole lot more expensive.",price=750,stat=220,image=image.hulls.angmallen},
    {name="Mithril Hull",description="Apparently Middle Earth is Mars.",price=1299,stat=250,image=image.hulls.mithril},
    {name="Diamond Hull",description="As it turns out, Minecraft is realistic.",price=0,stat=290,image=image.hulls.diamond},
    {name="Unobtainium Hull",description="Nobody knew that this was so strong. Probably because nobody had obtained it before.",price=0,stat=340,image=image.hulls.unobtainium},
    {name="Galvorn Hull",description="A shiny black metal which seems impossible to penetrate.",price=0,stat=400,image=image.hulls.galvorn},
    {name="Death Metal Hull",description="Death Metal seems like some kind of hard rock.",price=0,stat=470,image=image.hulls.deathmetal},
    {name="Silima Hull",description="Feanor claimed that it was indesctructible. He was almost right.",price=0,stat=550,image=image.hulls.silima},
    {name="Force Field Hull",description="Who would have thought that you could use force fields to protect something? And they regenerate over time too!",price=0,stat=640,image=image.hulls.forcefield}},
  -- DRILLS =============================================================================================================
  { {name="Iron Drill",description="The standard mining rig drill made of iron. Not very fast.",price=0,stat=50,image=image.drills.iron},
    {name="Gold Drill",description="Somehow a drill made of gold drills faster than one made of iron.",price=750,stat=55,image=image.drills.gold},
    {name="Emerald Drill",description="When this drill spins, your face will get the same colour as its material.",price=1299,stat=60,image=image.drills.emerald},
    {name="Adamant Drill",description="This drill is like Wolverine, just keeps on going.",price=0,stat=65,image=image.drills.adamant},
    {name="Amazonite Drill",description="With the speed and beauty of an Amazon.",price=0,stat=70,image=image.drills.amazonite},
    {name="Juvelium Drill",description="If you need some bling-bling.",price=0,stat=80,image=image.drills.juvelium},
    {name="Silima Drill",description="Almost the hardest material known to us.",price=0,stat=90,image=image.drills.silima},
    {name="Tilkal Drill",description="Combine all the other drills and you get this...thing...",price=0,stat=100,image=image.drills.tilkal},
    {name="Atomic Dissasembler",description="> See that rock there? \n> What rock? \n> Precisely.",price=0,stat=120,image=image.drills.atomic}},
  -- ENGINES =============================================================================================================
  { {name="Standard Engine",description="The standard mining rig engine. Not very fast.",price=0,stat=2,image=image.placeholder},
    {name="Discombobulator engine",description="Solves all your problems. In an easy way.",price=750,stat=2.1,image=image.placeholder},
    {name="Siege engine",description="Excellent for breaking down walls.",price=0,stat=2.25,image=image.placeholder},
    {name="Lawnmower engine",description="Or you could just buy a lawnmower...",price=0,stat=2.4,image=image.placeholder},
    {name="OMFG-42",description="Something something... I don't need a manual!",price=0,stat=2.55,image=image.placeholder},
    {name="Steam engine",description="For the more oldschool gentleman.",price=0,stat=2.7,image=image.placeholder},
    {name="V-6 SUPERTURBO",description="Because a Ferrari isn't fast enough.",price=0,stat=2.75,image=image.placeholder},
    {name="Epsylon Zeta 731",description="Still only a prototype, don't ask how we got it.",price=0,stat=3,image=image.placeholder},
    {name="Warp Drive",description="Rumoured to be able to move a spaceship at several light years per second. From what we can tell these rumours are not true.",price=0,stat=3.8,image=image.placeholder}},
  -- RADIATORS =============================================================================================================
  { {name="No Radiator",description="I could have sworn I had a radiator yesterday...",price=0,stat=0,image=image.placeholder},
    {name="Rusty Fan",description="There isn't really much point in buying this...",price=750,stat=0.11,image=image.placeholder},
    {name="Cheap Radiator",description="It is cheap, therefore buy it!",price=0,stat=0.22,image=image.placeholder},
    {name="Average Radiator",description="Well, it is average at least...",price=0,stat=0.33,image=image.placeholder},
    {name="Water Cooler",description="Because if it works in computers...",price=0,stat=0.44,image=image.placeholder},
    {name="Fridge Radiator",description="Fits good with the barreltank.",price=0,stat=0.55,image=image.placeholder},
    {name="Freezer Radiator",description="If you would like to add som ice.",price=0,stat=0.66,image=image.placeholder},
    {name="Car Radiator",description="I admit, it came with the V-6 engine... But no more!",price=0,stat=0.77,image=image.placeholder},
    {name="Standard Radiator",description="I knew I lost this somewhere!",price=0,stat=0.88,image=image.placeholder}},
  --FUEL TANKS =============================================================================================================
  { {name="Standard Fuel Tank",description="The standard mining rig fuel tank. Not very big.",price=0,stat=30,image=image.placeholder},
    {name="Truck Fuel Tank",description="Trucks were a way to transport things on Earth in the early 2000s.",price=750,stat=45,image=image.placeholder},
    {name="Double standard",description="Don't ask me how I got these.",price=0,stat=60,image=image.placeholder},
    {name="Dwarf barrel",description="What is a hobbit doing in here?",price=0,stat=75,image=image.placeholder},
    {name="Half-a-barrel",description="Party time!",price=0,stat=90,image=image.placeholder},
    {name="Barrel",description="If you want to invite a few friends...",price=0,stat=105,image=image.placeholder},
    {name="T-34",description="Not sure how this one got here...",price=0,stat=120,image=image.placeholder},
    {name="Tiger II",description="Okay, this makes no sense whatsoever!",price=0,stat=150,image=image.placeholder},
    {name="Living Algae Tank",description="This tank comes with genetically modified algae that are able to produce fuel using sunlight.",price=0,stat=160,image=image.placeholder}},
  -- CARGO BAYS =============================================================================================================
  { {name="Standard Cargo Bay",description="The standard mining rig cargo bay. Not very big.",price=0,stat=6,image=image.placeholder},
    {name="Extra small Cargo Bay",description="This box is on a diet",price=750,stat=7,image=image.placeholder},
    {name="Small Cargo Bay",description="It' is like a dwarf small but sturdy. Why this is important nobody knows",price=0,stat=8,image=image.placeholder},
    {name="Medium Cargo Storage",description="It stores and talks to dead ores",price=0,stat=10,image=image.placeholder},
    {name="Large Cargo Strongbox",description="When size doesn't matter",price=0,stat=12,image=image.placeholder},
    {name="Extra Large Booty Box",description="This fat thing looks like someones parent",price=0,stat=14,image=image.placeholder},
    {name="Small large LootCrate(tm)",description="Okay, what happened here, where is my loot?",price=0,stat=17,image=image.placeholder},
    {name="Extra medium Cargo Bay",description="Sounds like a swedish thing...",price=0,stat=20,image=image.placeholder},
    {name="Three Dimensional Cargo",description="How does the third dimension work? What does it look like? All we know is that it has virtually unlimited storage capacities.",price=9001,stat=150,image=image.placeholder}},
  -- UI ======================================================================================================================
  { {name="Standard sensors",description="The basic hull and fuel meters.",price=0,stat=0,image=image.placeholder},
    {name="GPS",description="Adds a minimap with an automatic depth marker and tells you how much you have in your cargo bay.",price=750,stat=1,image=image.placeholder},
    {name="Advanced sensors",description="Adds numerical values on the hull and fuel meters and tells you how fast you dig blocks.",price=0,stat=2,image=image.placeholder},
    {name="4",description="",price=0,stat=3,image=image.placeholder},
    {name="Basic CPU",description="Gives you an esimate of the amount of fuel needed to dig a block.",price=0,stat=4,image=image.placeholder},
    {name="6",description="",price=0,stat=5,image=image.placeholder},
    {name="Advanced CPU",description="Gives you an estimate of the amount of fuel needed to return to the surface.",price=0,stat=6,image=image.placeholder},
    {name="Dynamic camera",description="Makes you able to move the camera. Press y to activate.",price=0,stat=7,image=image.placeholder},
    {name="Infrared camera",description="Makes gaspockets visible.",price=0,stat=8,image=image.placeholder}}
}

--[[u.list = {}

for i = 1,6 do
  u.list[i] = {}
  for t = 1,8 do
    table.insert(u.list[i], {name="Placeholder", description="Placeholder description", price=250+500*t^2, stat=t, image=image.placeholder})
  end
end]]

for i = 1,7 do
  for t = 3,9 do
    u.list[i][t].price = math.floor(750*8^((t-2)/2)+0.5)
  end
end

u.names = {"Hulls","Drills","Engines","Radiators","Fuel Tanks","Cargo bays","UI upgrades"}
u.statUnit = {" Hull Points"," Blocks/s"," Blocks/s^2","%"," Litres"," blocks",""}
u.statName = {"Strength:","Speed:","Acceleration:","Reduces damage by","Capacity:","Storage:","UI Level:"}
u.multiplier = {1,1,1,100,1,1,1}

u.purchased = {
  {false,false,false,false,false,false,false,false,false},
  {false,false,false,false,false,false,false,false,false},
  {false,false,false,false,false,false,false,false,false},
  {false,false,false,false,false,false,false,false,false},
  {false,false,false,false,false,false,false,false,false},
  {false,false,false,false,false,false,false,false,false},
  {false,false,false,false,false,false,false,false,false}
}

u.unlocked = {8,8,8,8,8,8,8}

function u.purchase(a,b,c)
  item = u.list[a][b]
  if p.money >= item.price or c then
    if not c then p.money = p.money - item.price end
    u.purchased[a][b] = true
    local highest = b
    for t = b,9 do
      if u.purchased[a][t] and t > highest then
        highest = t
      end
    end
    --print(highest)
    if highest <= b then
      --print("hello")
      if a == 1 then
        p.maxhealth = item.stat
        p.health = item.stat
      elseif a == 2 then
        p.baseDigSpeed = item.stat
        if b == 9 then
          p.drillLevel = #world.ores
        end
      elseif a == 3 then
        p.basexacc = item.stat
        p.baseyacc = item.stat*2.05
      elseif a == 4 then
        p.radiator = item.stat
      elseif a == 5 then
        p.tanksize = item.stat
        p.fuel = item.stat
      elseif a == 6 then
        p.cargoSize = item.stat
      elseif a == 7 then
        UI.level = item.stat
        if item.stat == 8 then
          world.ores[#world.ores-1].image = love.graphics.newImage("img/gaspocket.png")
        end
      end
    end
  end
end --code:p.y = 500*40