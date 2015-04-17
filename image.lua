image = {}
local i = image

i.backfill = love.graphics.newImage("img/backfillsquare.png")
i.explosion = love.graphics.newImage("img/explosion.png")

i.upgrade = love.graphics.newImage("img/upgrade.png")

i.grass = love.graphics.newImage("img/grass2.png")
i.dirt = love.graphics.newImage("img/dirt3.png")

i.iron = love.graphics.newImage("img/iron2.png")
i.bronze = love.graphics.newImage("img/bronze2.png")
i.silver = love.graphics.newImage("img/silver2.png")
i.gold = love.graphics.newImage("img/gold2.png")
i.platinum = love.graphics.newImage("img/platinum.png")
--i["purple platinum"] = love.graphics.newImage("img/purple_platinum.png")
i.einsteinium = love.graphics.newImage("img/einsteinium2.png")
i.emerald = love.graphics.newImage("img/emeralds.png")
i.mithril = love.graphics.newImage("img/mithril.png") -- 10*gold
i.ruby = love.graphics.newImage("img/ruby.png")
i.adamant = love.graphics.newImage("img/adamant.png")
i.diamond = love.graphics.newImage("img/diamond.png")
i.wolfram = love.graphics.newImage("img/wolfram.png")
i.amazonite = love.graphics.newImage("img/amazonite.png")
i.galvorn = love.graphics.newImage("img/galvorn.png")
i.juvelium = love.graphics.newImage("img/juvelium.png")
i["death metal"] = love.graphics.newImage("img/death_metal.png")
i.silima = love.graphics.newImage("img/silima.png")
i.unobtainium = love.graphics.newImage("img/unobtainium.png")
i.tilkal = love.graphics.newImage("img/tilkal.png")
i.legendarium = love.graphics.newImage("img/legendarium.png")
i.psykadelium = love.graphics.newImage("img/psykadelium.png")

i.stone = love.graphics.newImage("img/stone3.png")
i.lava = love.graphics.newImage("img/lava.png")
i.gaspocket = love.graphics.newImage("img/transparent.png")
--i.gaspocketvisible = love.graphics.newImage("img/gaspocket.png")

i.orestore = love.graphics.newImage("img/sellspot.png")
i.fuelstore = love.graphics.newImage("img/fuelstore.png")
i.upgradestore = love.graphics.newImage("img/upgradestore.png")
i.itemstore = love.graphics.newImage("img/itemstore.png")
i.sputnik = love.graphics.newImage("img/sputnik.png")

i.player = love.graphics.newImage("img/player.png")
i.drill = love.graphics.newImage("img/drill.png")
i.flame = love.graphics.newImage("img/flame.png")
i.bands = {}
for _ = 8,1,-1 do
  table.insert(i.bands,love.graphics.newImage("img/band".._..".png"))
end

i.dirtParticle = love.graphics.newImage("img/dirtparticle.png")
i.particleQuad = love.graphics.newQuad(15,15,10,10,40,40)

i.stones = love.graphics.newImage("img/stones.png")
i.dirtQuads = {}
i.dirtScale = 5
for y = 0,i.dirtScale-1 do
  for x = 0,i.dirtScale-1 do
    table.insert(i.dirtQuads,love.graphics.newQuad(x*40,y*40,40,40,40*i.dirtScale,40*i.dirtScale))
  end
end

--[[i.roundDirtQuads = {}
for i = 0,15 do
  i.roundDirtQuads[i] = {}
  for y = 0,i.dirtScale-1 do
    for x = 0,i.dirtScale-1 do
      table.insert(i.dirtQuads,love.graphics.newQuad(x*40,y*40,40,40,40*i.dirtScale,40*i.dirtScale))
    end
  end
end]]

i.roundDirt = {}
for j = 0,15 do
  i.roundDirt[j] = love.graphics.newImage("img/rounddirt/"..j..".png")
end

i.placeholder = love.graphics.newImage("img/placeholder.png")

-- UPGRADES
i.hulls = {}
i.hulls.iron = love.graphics.newImage("img/upgrades/hulls/iron.png")
i.hulls.angmallen = love.graphics.newImage("img/upgrades/hulls/angmallen.png")
i.hulls.mithril = love.graphics.newImage("img/upgrades/hulls/mithril.png")
i.hulls.diamond = love.graphics.newImage("img/upgrades/hulls/diamond.png")
i.hulls.unobtainium = love.graphics.newImage("img/upgrades/hulls/unobtainium.png")
i.hulls.galvorn = love.graphics.newImage("img/upgrades/hulls/galvorn.png")
i.hulls.deathmetal = love.graphics.newImage("img/upgrades/hulls/deathmetal2.png")
i.hulls.silima = love.graphics.newImage("img/upgrades/hulls/silima.png")
i.hulls.forcefield = love.graphics.newImage("img/upgrades/hulls/forcefield.png")

i.drills = {}
i.drills.iron = love.graphics.newImage("img/upgrades/drills/iron.png")
i.drills.gold = love.graphics.newImage("img/upgrades/drills/gold.png")
i.drills.emerald = love.graphics.newImage("img/upgrades/drills/emerald.png")
i.drills.adamant = love.graphics.newImage("img/upgrades/drills/adamant.png")
i.drills.amazonite = love.graphics.newImage("img/upgrades/drills/amazonite.png")
i.drills.juvelium = love.graphics.newImage("img/upgrades/drills/juvelium.png")
i.drills.silima = love.graphics.newImage("img/upgrades/drills/silima.png")
i.drills.tilkal = love.graphics.newImage("img/upgrades/drills/tilkal.png")
i.drills.atomic = love.graphics.newImage("img/upgrades/drills/atomicdisassembler.png")

i.engines = {}
i.engines.standard = love.graphics.newImage("img/upgrades/engines/1.png")
i.engines.discombobulator = love.graphics.newImage("img/upgrades/engines/2.png")
i.engines.siege = love.graphics.newImage("img/upgrades/engines/3.png")
i.engines.lawnmower = love.graphics.newImage("img/upgrades/engines/4.png")
i.engines.omfg = love.graphics.newImage("img/upgrades/engines/5.png")
i.engines.steam = love.graphics.newImage("img/upgrades/engines/8.png")
i.engines.superturbo = love.graphics.newImage("img/upgrades/engines/7.png")
i.engines.epsylon = love.graphics.newImage("img/upgrades/engines/6.png")
i.engines.warp = love.graphics.newImage("img/upgrades/engines/9.png")

i.radiators = {}
i.radiators.none = love.graphics.newImage("img/transparent.png")
i.radiators.rusty = love.graphics.newImage("img/upgrades/radiators/rusty.png")
i.radiators.cheap = love.graphics.newImage("img/upgrades/radiators/cheap.png")
i.radiators.okay = love.graphics.newImage("img/upgrades/radiators/okay.png")
i.radiators.water = love.graphics.newImage("img/upgrades/radiators/water.png")
i.radiators.fridge = love.graphics.newImage("img/upgrades/radiators/fridge.png")
i.radiators.freezer = love.graphics.newImage("img/upgrades/radiators/freezer.png")
i.radiators.car = love.graphics.newImage("img/upgrades/radiators/car.png")
i.radiators.standard = love.graphics.newImage("img/upgrades/radiators/standard.png")

i.tanks = {}
i.tanks.standard = love.graphics.newImage("img/upgrades/tanks/standard.png")
i.tanks.truck = love.graphics.newImage("img/upgrades/tanks/truck.png")
i.tanks.double = love.graphics.newImage("img/upgrades/tanks/double.png")
i.tanks.wooden = love.graphics.newImage("img/upgrades/tanks/wooden.png")
i.tanks.oil = love.graphics.newImage("img/upgrades/tanks/oil.png")
i.tanks.fish = love.graphics.newImage("img/upgrades/tanks/fish.png")
i.tanks.t34 = love.graphics.newImage("img/upgrades/tanks/t34.png")
i.tanks.tiger = love.graphics.newImage("img/upgrades/tanks/tiger.png")
i.tanks.algae = love.graphics.newImage("img/upgrades/tanks/algae.png")

i.bays = {}
i.bays.standard = love.graphics.newImage("img/upgrades/bays/standard.png")
i.bays.cardboard = love.graphics.newImage("img/upgrades/bays/cardboard.png")
i.bays.bad = love.graphics.newImage("img/upgrades/bays/bad.png")
i.bays.safe = love.graphics.newImage("img/upgrades/bays/safe.png")
i.bays.okay = love.graphics.newImage("img/upgrades/bays/okay.png")
i.bays.cleaner = love.graphics.newImage("img/upgrades/bays/cleaner.png")
i.bays.trans = love.graphics.newImage("img/upgrades/bays/trans.png")
i.bays.good = love.graphics.newImage("img/upgrades/bays/good.png")
i.bays.three = love.graphics.newImage("img/upgrades/bays/3d.png")

i.UI = {}


--i.. = love.graphics.newImage("img/upgrades//.png")