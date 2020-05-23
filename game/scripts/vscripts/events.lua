GameRules.DropTable = LoadKeyValues("scripts/kv/item_drops.kv")

---------------------------------------------------------------------------
-- Event: OnNPCSpawned
---------------------------------------------------------------------------
function MazeSurvival:OnNPCSpawned(event)
    local spawned = EntIndexToHScript(event.entindex)
    if not spawned then
        return
    end
  
	if spawned:IsRealHero() and spawned.bFirstspawned == nil then
		spawned.bFirstspawned = true
		MazeSurvival:OnHeroInGame(spawned)
	end
end

---------------------------------------------------------------------------
-- Event: OnHeroInGame
---------------------------------------------------------------------------
function MazeSurvival:OnHeroInGame(hero)

end

---------------------------------------------------------------------------
-- Event: OnEntityHurt
---------------------------------------------------------------------------
function MazeSurvival:OnEntityHurt(event)
	local attacker = EntIndexToHScript(event.entindex_attacker)
	local inflictor
	if event.entindex_inflictor then
		inflictor = EntIndexToHScript(event.entindex_inflictor)
	end
	local damagebits = event.damagebits
	local damage = event.damage
end


---------------------------------------------------------------------------
-- Event: OnConnectFull
---------------------------------------------------------------------------
function MazeSurvival:OnConnectFull(keys) 
	local entIndex = keys.index + 1
	local player = EntIndexToHScript(entIndex)
end

---------------------------------------------------------------------------
-- Event: OnPlayerReconnect
---------------------------------------------------------------------------
function MazeSurvival:OnPlayerReconnect(keys)
 
end

---------------------------------------------------------------------------
-- Event: OnPlayerDisconnect
---------------------------------------------------------------------------
function MazeSurvival:OnPlayerDisconnect(keys)

end

---------------------------------------------------------------------------
-- Event: OnTeamKillCredit
---------------------------------------------------------------------------
function MazeSurvival:OnTeamKillCredit(event)
  local nKillerID = event.killer_userid
  local nTeamID = event.teamnumber
  local nTeamKills = event.herokills
  local KillerName = PlayerResource:GetPlayerName(nKillerID)
end

---------------------------------------------------------------------------
-- Event: OnEntityKilled
---------------------------------------------------------------------------
function MazeSurvival:OnEntityKilled(event)
	local killed = EntIndexToHScript(event.entindex_killed)
	if not killed then
		return
	end
	
	if killed:GetUnitName() == "unit_minotaur" then
		GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
	end
	
	-- EmitGlobalSound("announcer_dlc_stanleyparable_killing_spree_announcer_kill_wipeout_you_04")
	
	if killed and killed:IsRealHero() then
		local newItem = CreateItem( "item_tombstone", killed, killed )
		newItem:SetPurchaseTime( 0 )
		newItem:SetPurchaser( killed )
		local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
		tombstone:SetContainedItem( newItem )
		tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
		FindClearSpaceForUnit( tombstone, killed:GetAbsOrigin(), true )	
	end
	
	if killed:IsCreature() then
        RollDrops(killed)
    end
end

function RollDrops(unit)
    local DropInfo = GameRules.DropTable[unit:GetUnitName()]
    if DropInfo then
        for item_name,chance in pairs(DropInfo) do
            if RollPercentage(chance) then
                -- Create the item
                local item = CreateItem(item_name, nil, nil)
                local pos = unit:GetAbsOrigin()
                local drop = CreateItemOnPositionSync( pos, item )
                local pos_launch = pos+RandomVector(RandomFloat(50,75))
				item:LaunchLoot(false, 75, 0.75, pos_launch)
            end
        end
    end
end

---------------------------------------------------------------------------
-- Event: OnGameRulesStateChange
---------------------------------------------------------------------------
function MazeSurvival:OnGameRulesStateChange()
  local nNewState = GameRules:State_Get()
  if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
    print( "Pregame in Progress" )
  elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    MazeSurvival:OnGameInProgress()
	Convars:SetInt("dota_max_physical_items_purchase_limit", 9999)
    Convars:SetInt("dota_max_physical_items_drop_limit", 9999)
  end
end

function MazeSurvival:OnGameInProgress()
	Timers:CreateTimer(1, function()
		EmitGlobalSound("announcer_dlc_stanleyparable_announcer_battle_begin_08")
		--Spawn Chests
		for i = 1,10 do
			local namechest = "ChestSpawn" .. i
			local spawnLocationChest = Entities:FindByName(nil, namechest)
			local ChestUnit = CreateUnitByName( "npc_treasure_chest" , spawnLocationChest:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
			ChestUnit:FaceTowards(ChestUnit:GetAbsOrigin())
		end
		Timers:CreateTimer(1, function()
			--Spawn Dagger Thief
			for i = 1,23 do
				local nameDagger = "thief_dagger" .. i
				local spawnLocationDagger = Entities:FindByName(nil, nameDagger)
				local DaggerUnit = CreateUnitByName( "unit_thief_dagger" , spawnLocationDagger:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS )
				DaggerUnit:FaceTowards(DaggerUnit:GetAbsOrigin())
			end
		end)
		Timers:CreateTimer(1, function()
			--Spawn Blade Thief
			for i = 1,18 do
				local nameBlade = "thief_blade" .. i
				local spawnLocationBlade = Entities:FindByName(nil, nameBlade)
				local BladeUnit = CreateUnitByName( "unit_thief_blade" , spawnLocationBlade:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS )
				BladeUnit:FaceTowards(BladeUnit:GetAbsOrigin())
			end
		end)
		Timers:CreateTimer(1, function()
			--Spawn Archer Thief
			for i = 1,14 do
				local nameArcher = "thief_archer" .. i
				local spawnLocationArcher = Entities:FindByName(nil, nameArcher)
				local ArcherUnit = CreateUnitByName( "unit_thief_archer" , spawnLocationArcher:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS )
				ArcherUnit:FaceTowards(ArcherUnit:GetAbsOrigin())
			end
		end)
		Timers:CreateTimer(3, function()
		--Spawn Minotaur
			local spawnLocationMinotaur = Entities:FindByName(nil, "MinotaurSpawn")
			local Minotaur = CreateUnitByName( "unit_minotaur" , spawnLocationMinotaur:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS )
			Minotaur:FaceTowards(Minotaur:GetAbsOrigin())
		end)
	end)
end