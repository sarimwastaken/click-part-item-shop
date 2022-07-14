local roact: Roact = require(game:GetService("ReplicatedStorage").Packages.Roact)
local ItemInfo = require(script.Parent.ItemInfo)

return function (props: {size: UDim2, offset: Vector3, adornee: BasePart})
  return roact.createElement("BillboardGui", {
    Adornee = props.adornee,
    StudsOffset = props.offset,
    Size = props.size,

    ResetOnSpawn = false,
    LightInfluence = 0,
  }, {
    Info = roact.createElement(ItemInfo)
  })
end