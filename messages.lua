messages = {}
local m = messages

m.depth = -1
m.open = false

m.currentFrame = nil

m.depthBased = {
  [-6]={sender="Gammelsmurfen",message=[[Pomppaa! Pompottaa! x2

Ylös, alas, edestakas pysytellään pyöreinä
Hymy suussa heinäkuussa antaa helteen helliä
Tänään ei oo edessämme huolia taikka pulmia
Hypi vapaana, mut varo teräviä kulmia

KERTOSÄE
Minulla on pomppufiilis
hei ota minut kiinni tai pompahdan pilviin asti
Minulla on pomppufiilis
hei ota minut kiinni, kiinni, kiinni, kiinni

Ja toinen säkeistö lähtee nyt!

Ylös, alas, edestakas pysytellään pyöreinä
Allamme on kesämaita ja nurmikoita vihreitä
Pidä muna varasi, sinne ei saa tippua
Pidä muna varasi, taikka saatat rikkua

KERTOSÄE
Minulla on pomppufiilis
hei ota minut kiinni tai pompahdan pilviin asti
Minulla on pomppufiilis
hei ota minut kiinni, kiinni, kiinni, kiinni

Pomppaa! Pompottaa! x4

Noniin kaikki lapset ja aikuiset ja vanhukset
Nyt pompitaan sydämmemme kyllyydestä!

KERTOSÄE:
Minulla on pomppufiilis
hei ota minut kiinni tai pompahdan pilviin asti
Minulla on pomppufiilis
hei ota minut kiinni, kiinni, kiinni, kiinni

Ja vielä kerran!

KERTOSÄE:
Minulla on pomppufiilis
hei ota minut kiinni tai pompahdan pilviin asti
Minulla on pomppufiilis
hei ota minut kiinni, kiinni, kiinni, kiinni

Apua, nämä lapset juoksevat perässäni]]},
  [225]={sender="Gammelsmurfen",message="Watch out for lava, it hurts your hull!!!"},
  [300]={sender="Mr Norell",message="Watch out for gas pockets :)\n\nI would recommend buying a radiator and some hull!"}
  
  
}

m.randomBased = {}

m.received = {
  depthBased = {},
  randomBased = {}
}

function m.update(dt)
  if math.floor(p.y/world.scale) > m.depth then
    m.depth = math.floor(p.y/world.scale)+0
  end
  if m.depthBased[m.depth] then
    m.create(m.depthBased[m.depth].sender,m.depthBased[m.depth].message)
    m.depth = m.depth + 1
  end
end

function m.close()
  m.open = false
  m.currentFrame:Remove()
  m.currentFrame = nil
end

function m.keypressed(key)
  if key == "escape" or key == "return" then
    m.close()
  end
end

local new = loveframes.Create
function m.create(sender, message)
  m.open = true
  
  local frame = new("frame")
  frame:SetSize(420,420)
  frame:Center()
  m.currentFrame = frame
  frame.OnClose = m.close
  
  local panel = new("panel", frame)
  panel:SetSize(100,395)
  panel:SetPos(420-100,25)
  
  local face = new("image", panel)
  face:SetImage(image.placeholder)
  face:SetSize(80,80)
  face:SetPos(10,10)
  
  local name = new("text", panel)
  name:SetPos(5,95)
  name:SetSize(90,50)
  name:SetText(sender)
  
  local list = new("list", frame)
  list:SetPos(0,25)
  list:SetSize(321,395)
  list:SetPadding(5)
  
  local text = new("text")
  list:AddItem(text)
  text:SetText(message)
  
end