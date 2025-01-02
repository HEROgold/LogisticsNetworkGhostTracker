require("control.tracking")

---@param entity LuaEntity
function track_entity(entity)
    track_logistic_cell(entity)
    track_ghost_tracker(entity)
    track_ghost(entity)
end
