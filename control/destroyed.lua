require("control.tracking")

function untrack_entity(entity)
    clean_cells()
    untrack_logistic_cell(entity)
    untrack_ghost_tracker(entity)
    untrack_ghost(entity)
end
