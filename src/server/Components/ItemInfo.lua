local roact: Roact = require(game:GetService("ReplicatedStorage").Packages.Roact)
local RoactRodux = require(game:GetService("ReplicatedStorage").Packages.RoactRodux)

local Component = roact.Component:extend("ItemInfo")

function Component:init()
  
end

function Component:render()
  return roact.createElement("Frame", {
    AnchorPoint = Vector2.new(.5, .5),
    Position = UDim2.fromScale(.5, .5),
    Size = UDim2.fromScale(1, 1),
    
    BackgroundTransparency = 1,
    BorderSizePixel = 0
  }, {
    NameLabel = roact.createElement("TextLabel", {
      AnchorPoint = Vector2.new(.5, .5),
      Position = UDim2.fromScale(.5, .3),
      Size = UDim2.fromScale(1, .6),

      BackgroundTransparency = 1,
      BorderSizePixel = 0,

      Font = Enum.Font.GothamBold,
      TextColor3 = Color3.new(1, 1, 1),
      TextScaled = true,
      TextStrokeTransparency = 0,

      Text = self.props.name
    }),

    PriceLabel = roact.createElement("TextLabel", {
      AnchorPoint = Vector2.new(.5, .5),
      Position = UDim2.fromScale(.5, .6 + .35 / 2),
      Size = UDim2.fromScale(1, .35),

      BackgroundTransparency = 1,
      BorderSizePixel = 0,

      Font = Enum.Font.GothamMedium,
      TextColor3 = Color3.new(0.321568, 0.933333, 0.262745),
      TextScaled = true,
      TextStrokeTransparency = 0,

      Text = "$" .. self.props.price
    })
  })  
end

function Component:didMount()
  
end

return RoactRodux.connect(function(state, props)
  return {name = state.ItemName, price = state.ItemPrice}
end)(Component)