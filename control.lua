local lastIdx = 0
local entities = {}
local selectedEntry = nil

local function ShowMessage(player, message)
    if not (player.gui.center["ssc-message"]) then
        local gui = player.gui.center
        local frame = gui.add{type = "frame", name = "ssc-message", caption = "Message", direction = "vertical"}
        frame.add{type = "label", caption = message, style = "ssc-multiline-label"}
        frame.add{type = "button", name = "ssc-exit", caption = "Ok"}
    end
end

local function CloseGUI(player)
    if player.gui.center["ssc-message"] then
        player.gui.center["ssc-message"].destroy()
    end
    if player.gui.center["ssc-adjust"] then
        player.gui.center["ssc-adjust"].destroy()
        selectedEntry = nil
    end
end

local function GetSignals(control)
    local signals = {}
    local red = control.get_circuit_network(defines.wire_type.red, defines.circuit_connector_id.combinator_input)
    local green = control.get_circuit_network(defines.wire_type.green, defines.circuit_connector_id.combinator_input)
    
    if red and red.signals then
        for _, s in ipairs(red.signals) do
            signals[s.signal.name] = s
        end
    end
    if green and green.signals then
        for _, s in ipairs(green.signals) do
            if signals[s.signal.name] == nil then
                signals[s.signal.name] = s
            else
                signals[s.signal.name].count = signals[s.signal.name].count + s.count
            end
        end
    end
    local result = {}
    for _, s in pairs(signals) do
        table.insert(result, s)
    end
    return result
end

local function Save()
    global["ssc-entities"] = entities
end

local function onLoad()
    entities = global["ssc-entities"] or {}
end

local function onInit()
    onLoad()
end

local function onTick(e)
    for _, entry in ipairs(entities) do
        if entry.entity and entry.entity.valid == true then
            local entity = entry.entity
            local idx = entry.signalIdx
            local control = entity.get_control_behavior()
            local signals = GetSignals(control)
            
            control.parameters = {}
            if signals[idx] then
                local signal = signals[idx]
                control.parameters = {
                    parameters = {
                        first_signal = signal.signal,
                        second_signal = signal.signal,
                        comparator = "=",
                        output_signal = signal.signal,
                        copy_count_from_input = true
                    }
                }
            end
        end
    end
end

function onBuiltEntity(e)
    local player = game.players[e.player_index]
    if e.created_entity then
        local entity = e.created_entity
        if entity.name == "signal-splitter-combinator" then
            lastIdx = lastIdx + 1
            local entityEntry = {
                signalIdx = lastIdx,
                entity = entity
            }
            table.insert(entities, entityEntry)
            Save()
        end
    end
    --ShowMessage(player, serpent.block(entities))
end

function onMinedEntity(e)
    local player = game.players[e.player_index]
    if e.entity then
        local entity = e.entity
        if entity.name == "signal-splitter-combinator" then
            for i, v in ipairs(entities) do
                if v.entity == entity then
                    table.remove(entities, i)
                end
            end
        end
    end
end

function onGuiClick(e)
    local player = game.players[e.player_index]
    local element = e.element
    if element and element.name and element.name == "ssc-exit" then
        local gui = player.gui.center
        if gui["ssc-adjust"] ~= nil and selectedEntry ~= nil then
            local number = tonumber(gui["ssc-adjust"]["ssc-adjust-layout"]["signalID"].text)
            if number == nil then
                CloseGUI(player)
                ShowMessage(player, "Set a number!")
            else
                selectedEntry.signalIdx = number
                Save()
                CloseGUI(player)
            end
        else
            CloseGUI(player)
        end
    end
end

function onGuiOpened(e)
    local player = game.players[e.player_index]
    if player.opened and player.opened.name == "signal-splitter-combinator" then
        player.opened = nil 
        CloseGUI(player)
        
        local entity = e.entity
        local entry = nil
        
        for i, v in ipairs(entities) do
            if v.entity == entity then
                entry = v
            end
        end
    
        if entity ~= nil then
            local gui = player.gui.center
            local frame = gui.add{type = "frame", name = "ssc-adjust", caption = "Signal Splitter Combinator", direction = "vertical"}
            local layout = frame.add{type = "table", name="ssc-adjust-layout", column_count = 2}
            layout.add{type = "label", caption = "Signal ID", style = "ssc-multiline-label"}
            layout.add{type = "textfield", name = "signalID", text = entry.signalIdx}
            layout.add{type = "button", name = "ssc-exit", caption = "Ok"}
            
            selectedEntry = entry
        else
            ShowMessage(player, "Unknown item, please rebuild it")
        end
        
    end
end

script.on_init(onInit)
script.on_load(onLoad)

script.on_event(defines.events.on_gui_click, onGuiClick)

script.on_event(defines.events.on_built_entity, onBuiltEntity)
script.on_event(defines.events.on_robot_built_entity, onBuiltEntity)
script.on_event(defines.events.on_player_mined_entity, onMinedEntity)
script.on_event(defines.events.on_robot_mined_entity, onMinedEntity)

script.on_event(defines.events.on_tick, onTick)
script.on_event(defines.events.on_gui_opened, onGuiOpened)
