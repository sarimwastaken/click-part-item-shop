local ServerStorage = game:GetService("ServerStorage")
local Tools = ServerStorage.Tools :: Folder

return function (item: BasePart, store, player: Player)
  local tool = Tools:FindFirstChild(store:getState().ItemName)
  if (not tool or not tool:IsA("Tool")) then return end

  tool:Clone().Parent = player.Backpack
  return true
end