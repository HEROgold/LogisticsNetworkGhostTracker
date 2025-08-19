require("__heroic-library__.vars.strings")
require("vars.strings")

local ghost_combinator_item = table.deepcopy(
    data.raw[Item][ConstantCombinator]
)
local ghost_combinator_entity = table.deepcopy(
data.raw[ConstantCombinator][ConstantCombinator]
)


ghost_combinator_item.name = GhostCombinator
ghost_combinator_item.place_result = GhostCombinator
ghost_combinator_item.icon = resources .. "/graphics/icons/ghost-combinator.png"

ghost_combinator_entity.name = GhostCombinator
ghost_combinator_entity.minable.result = GhostCombinator
ghost_combinator_entity.icon = resources .. "/graphics/icons/ghost-combinator.png"
ghost_combinator_entity.sprites.sheet = {
    filename = resources .. "/graphics/entity/ghost-combinator.png",
    scale = 0.5,
    width = 114,
    height = 102,
    priority = "medium",
    shift = util.by_pixel(0, 5)
}

data:extend({ghost_combinator_item})
data:extend({ghost_combinator_entity})
