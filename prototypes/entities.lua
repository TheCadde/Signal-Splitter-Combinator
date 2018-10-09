local p = table.deepcopy(data.raw["decider-combinator"]["decider-combinator"])
log(serpent.block(p))

p.name = "signal-splitter-combinator"
p.minable.result = "signal-splitter-combinator"

p.icon = "__signalsplittercombinator__/graphics/icons/signal-splitter-combinator.png"

p.sprites.north.layers[1].filename = "__signalsplittercombinator__/graphics/entity/combinator/signal-splitter-combinator.png"
p.sprites.east.layers[1].filename = "__signalsplittercombinator__/graphics/entity/combinator/signal-splitter-combinator.png"
p.sprites.south.layers[1].filename = "__signalsplittercombinator__/graphics/entity/combinator/signal-splitter-combinator.png"
p.sprites.west.layers[1].filename = "__signalsplittercombinator__/graphics/entity/combinator/signal-splitter-combinator.png"

p.sprites.north.layers[1].hr_version.filename = "__signalsplittercombinator__/graphics/entity/combinator/hr-signal-splitter-combinator.png"
p.sprites.east.layers[1].hr_version.filename = "__signalsplittercombinator__/graphics/entity/combinator/hr-signal-splitter-combinator.png"
p.sprites.south.layers[1].hr_version.filename = "__signalsplittercombinator__/graphics/entity/combinator/hr-signal-splitter-combinator.png"
p.sprites.west.layers[1].hr_version.filename = "__signalsplittercombinator__/graphics/entity/combinator/hr-signal-splitter-combinator.png"

data:extend{p}
