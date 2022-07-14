return function (item: BasePart, store, playerWhoPurchased: Player)
  warn(("This item (%s) does not have a purchase handler, please specify one..."):format(store:getState().ItemName))
end