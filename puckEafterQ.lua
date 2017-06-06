local puckEafterQ= {}


puckEafterQ.optionEnable = Menu.AddOption({ "Utility", "puckEafterQ"}, "Enable", "puckEafterQ")
dodgeTick = 0
delay = 0.25 -- block orders time
enemyrange = 300 -- use E if enemy in range 300


function puckEafterQ.OnUpdate()
    if not Menu.IsEnabled(puckEafterQ.optionEnable) then return end
    local myHero = Heroes.GetLocal()
    local myTeam = Entity.GetTeamNum(myHero)
	if NPC.GetUnitName(myHero) ~= "npc_dota_hero_puck" then return end
    local Q = NPC.GetAbilityByIndex(myHero, 0)
    local E = NPC.GetAbilityByIndex(myHero, 2)
    for i= 1, Heroes.Count() do
        local enemy = Heroes.Get(i)
        local sameTeam = Entity.GetTeamNum(enemy) == myTeam
        if not sameTeam and not NPC.IsDormant(enemy) and Entity.GetHealth(enemy) > 0 then
            if NPC.IsEntityInRange(myHero, enemy, enemyrange) then
                if Ability.IsReady(E) and Ability.SecondsSinceLastUse(Q)<=1 and Ability.SecondsSinceLastUse(Q)>0 then
                    Ability.CastNoTarget(E)
                    dodgeTick = GameRules.GetGameTime()+delay
                end 
            end 
        end 
    end 
end

function puckEafterQ.OnPrepareUnitOrders(orders)
    if GameRules.GetGameTime()>dodgeTick then return true end 
    return false
end

return puckEafterQ
