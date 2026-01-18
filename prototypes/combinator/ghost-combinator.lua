


local ghost_combinator_item = table.deepcopy(
    data.raw["item"]["constant-combinator"]
)
local ghost_combinator_entity = table.deepcopy(
data.raw["constant-combinator"]["constant-combinator"]
)


local name = "ghost-combinator"
ghost_combinator_item.name = name
ghost_combinator_item.place_result = name
ghost_combinator_item.icon = resources .. "/graphics/icons/ghost-combinator.png"

ghost_combinator_entity.name = name
ghost_combinator_entity.minable.result = name
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
