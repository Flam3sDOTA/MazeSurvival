function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:SetContextThink( "BanditThink", BanditThink, 1 )
end


function BanditThink()
	if not IsServer() then
		return
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	-- Get last aggro timestamp
    if ( not thisEntity.bHasAggro ) and thisEntity:GetAggroTarget() then
		thisEntity.timeOfLastAggro = GameRules:GetGameTime()
		thisEntity.bHasAggro = true
	end

	if thisEntity.bHasAggro and ( not thisEntity:GetAggroTarget() ) then
		thisEntity.bHasAggro = false
	end

	if not thisEntity.bHasAggro then
		return 1
	end


	return 0.5
end

