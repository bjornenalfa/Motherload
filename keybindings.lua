keybindings = {}
local k = keybindings

k.list = {
  x="items.use(1)",
  c="items.use(2)",
  v="items.use(3)",
  b="items.use(4)",
  n="items.use(5)",
  m="items.use(6)",
  l="items.use(7)",
  o="saves.openMenu()",
  --i="saves.save('test2')",
  --p="saves.load('test2')",
  h="earthquake.start()"
}

function keybindings.keypressed(key)
  --print("pressed "..key)
  if k.list[key] then
    --print("accepted "..key)
    loadstring(k.list[key])()
  end
end