local puckW= {}

puckW.optionEnable = Menu.AddOption({ "Utility", "puckW"}, "Enable", "puckW")
enemyrange = 400 -- use W if enemy blink in range 400

function puckW.OnUpdate()
    if not Menu.IsEnabled(puckW.optionEnable) then return end
    local myHero = Heroes.GetLocal()
    local myTeam = Entity.GetTeamNum(myHero)
    if NPC.GetUnitName(myHero) ~= "npc_dota_hero_puck" then return end
    local W = NPC.GetAbilityByIndex(myHero, 1)
    for i= 1, Heroes.Count() do
        local enemy = Heroes.Get(i)
        local sameTeam = Entity.GetTeamNum(enemy) == myTeam
        if not sameTeam and not NPC.IsDormant(enemy) and Entity.GetHealth(enemy) > 0 then
            local dagger = NPC.GetItem(enemy,"item_blink")
            if dagger and NPC.IsEntityInRange(myHero, enemy, enemyrange) and Ability.GetCooldownLength(dagger) > 4 and Ability.SecondsSinceLastUse(dagger)<=1 and Ability.SecondsSinceLastUse(dagger)>0 then
                if not NPC.IsVisible(myHero) then return end
                local myMana = NPC.GetMana(myHero)
                if Menu.IsEnabled(puckW.optionEnable) and W and Ability.IsCastable(W, myMana) and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
                    Ability.CastNoTarget(W)
                end 
            end 
        end 
    end 
end

return puckW

