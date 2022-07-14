local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local DataStore2 = require(ServerStorage.DS2)
local Rodux = require(ReplicatedStorage.Packages.Rodux)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)
local Roact: Roact = require(ReplicatedStorage.Packages.Roact)
local Copy = require(script.Parent.Copy)

local Components = {}
local PurchaseHandlers = {}

local Tag = "Item"

--: Setup datastore
DataStore2.Combine("PlayerData", "Money")

--: Setup components
for _, module: ModuleScript in ipairs(script.Parent.Components:GetChildren()) do
  if (not module:IsA("ModuleScript")) then continue end

  Components[module.Name] = require(module)
end

--: Setup purchase handlers
for _, module: ModuleScript in ipairs(script.Parent.PurchaseHandlers:GetChildren()) do
  if (not module:IsA("ModuleScript")) then continue end

  PurchaseHandlers[module.Name] = require(module)
end

local function PlayerAdded(player: Player)
  local moneyStore = DataStore2("Money", player)

  print(moneyStore:Get())
end

local function GetTableFromConfiguration(configuration: Configuration)
  local tab = {}

  for _, value: ValueBase in ipairs(configuration:GetChildren()) do
    if (not value:IsA("ValueBase")) then continue end

    tab[value.Name] = value.Value
  end

  return tab
end

local function ItemAdded(item: BasePart)
  --: Initialize rodux store
  local itemStore = Rodux.Store.new(function(state, action)
    local newState = Copy(state)

    if (action.type == "ItemPriceUpdated") then
      newState.ItemPrice = action.newPrice
      elseif (action.type == "ItemNameUpdated") then
      newState.ItemName = action.newName
    end

    return newState
  end, GetTableFromConfiguration(item:FindFirstChildOfClass("Configuration")), {Rodux.loggerMiddleware})

  --: Create click detector for handling purchases
  local clickDetector = Instance.new("ClickDetector")
  clickDetector.Parent = item

  --: Create GUIs
  local rootGUI = Roact.createElement(RoactRodux.StoreProvider, {
    store = itemStore
  }, {
    GUI = Components.Billboard({
      adornee = item,
      size = UDim2.fromScale(5, 2),
      offset = Vector3.new(0, 2, 0)
    })
  })

  Roact.mount(rootGUI, item)

  --: Purchase handling
  clickDetector.MouseClick:Connect(function(playerWhoClicked)
    local character = playerWhoClicked.Character
    if (not character) then return end
 
    local humanoid, root = character:FindFirstChildOfClass("Humanoid"), character.PrimaryPart
    if (not humanoid or not root or humanoid.Health <= 0) then return end

    local state = itemStore:getState()
    local moneyStore = DataStore2("Money", playerWhoClicked)
    if (moneyStore:Get() < state.ItemPrice) then return end

    local didPurchase = PurchaseHandlers[state.PurchaseHandler or "Default"](item, itemStore, playerWhoClicked)
    if (didPurchase) then
      moneyStore:Increment(-state.ItemPrice)
      print(moneyStore:Get())
    end
  end)
end

for _, item in ipairs(CollectionService:GetTagged(Tag)) do
  task.spawn(ItemAdded, item)
end

for _, player in ipairs(Players:GetPlayers()) do
  task.spawn(PlayerAdded, player)
end

CollectionService:GetInstanceAddedSignal(Tag):Connect(ItemAdded)
Players.PlayerAdded:Connect(PlayerAdded)