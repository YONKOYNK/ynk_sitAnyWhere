local isSitting = false

local function seLever(player)
    while isSitting do
        Wait(0)
        if IsControlJustPressed(0, Config.touche) then
            ClearPedTasksImmediately(player)
            isSitting = false
            print("Vous vous êtes levé.")
        end
    end
end

local function SitOnBench(entity) --- l'entity veut dire le banc
    if isSitting then return end

    local player = PlayerPedId()
    local coords = GetEntityCoords(entity)
    local heading = (GetEntityHeading(entity) + 180.0) % 360

    local _, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 1.0, 0)
    local finalZ = groundZ + 0.5

    SetEntityCoordsNoOffset(player, coords.x, coords.y, finalZ, false, false, false)
    SetEntityHeading(player, heading)

    Wait(100)

    TaskStartScenarioAtPosition(player, Config.animName, coords.x, coords.y, finalZ, heading, -1, true, true)
    isSitting = true
    print("Vous êtes assis.")

    CreateThread(function() --- ca fonctionne pas tant que je ne lai pas declancher
        seLever(player)
    end)
end

for _, model in ipairs(Config.seats) do
    exports.ox_target:addModel(model, {
        {
            name = 'sit_bench_' .. model,
            label = 'S\'asseoir ynk',
            icon = 'fas fa-chair',
            onSelect = function(data)
                SitOnBench(data.entity)
            end
        }
    })
end
