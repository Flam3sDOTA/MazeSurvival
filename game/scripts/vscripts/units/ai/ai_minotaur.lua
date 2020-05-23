function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hDoubleEdgeAbility = thisEntity:FindAbilityByName( "centaur_dunerunner_double_edge" )
	thisEntity.hEarthbindAbility = thisEntity:FindAbilityByName( "dunerunner_earthbind" )

	thisEntity:SetContextThink( "CentaurDunerunnerThink", CentaurDunerunnerThink, 0.5 )
end

--------------------------------------------------------------------------------

function CentaurDunerunnerThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.5
	end

	return 0.5
end