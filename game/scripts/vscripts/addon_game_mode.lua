if MazeSurvival == nil then
	_G.MazeSurvival = class({})
end

require("events")
require("libraries/timers")

function Precache( context )
	-- Items
	PrecacheItemByNameSync( "item_tombstone", context )
	PrecacheItemByNameSync( "item_treasure_box", context )
	PrecacheItemByNameSync( "item_bag_of_gold", context )
	PrecacheItemByNameSync( "item_health_potion", context )
	PrecacheItemByNameSync( "item_mana_potion", context )
	
	-- Models
	PrecacheResource( "model", "models/props_gameplay/neutral_box.vmdl", context )
	PrecacheResource( "model", "models/creeps/beetlejaws/mesh/beetlejaws.vmdl", context )
	PrecacheResource( "model", "models/heroes/slardar/slardar.vmdl", context )
	PrecacheResource( "model", "models/creeps/centaurs/centaur_002.vmdl", context )
	PrecacheResource( "model", "models/creeps/thief/thief_01_leader.vmdl", context )
	PrecacheResource( "model", "models/creeps/thief/thief_01.vmdl", context )
	PrecacheResource( "model", "models/creeps/thief/thief_01_archer.vmdl", context )
	
	-- Sound Files
	PrecacheResource( "soundfile", "soundevents/game_sounds.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_main.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_greevils.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_items.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/soundevents_conquest.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/soundevents_dota_ui.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_ui_imported.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/music/game_sounds_music_tutorial.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_announcer.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_dungeon.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_dungeon_enemies.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_lycan.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_ogre_magi.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_sandking.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_drowranger.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_roshan_halloween.vsndevts",  context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_announcer.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_announcer_dlc_stanleyparable.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_announcer_dlc_stanleyparable_killing_spree.vsndevts", context )
	
	-- Particles
	PrecacheResource( "particle", "particles/units/heroes/hero_drow/drow_base_attack.vpcf", context )
end

function Activate()
	GameRules.MazeSurvival = MazeSurvival()
	GameRules.MazeSurvival:InitGameMode()
end

function MazeSurvival:InitGameMode()
	print( "MazeSurvival is loaded." )
	
	MAX_NUMBER_OF_TEAMS = 2   
	CUSTOM_TEAM_PLAYER_COUNT = {}        
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 4
	CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 0
	local count = 0
	for team,number in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
		if count >= MAX_NUMBER_OF_TEAMS then
			GameRules:SetCustomGameTeamMaxPlayers(team, 0)
		else
			GameRules:SetCustomGameTeamMaxPlayers(team, number)
		end
		count = count + 1
	end
	
	-- Handle Team Colors
	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 0, 100, 0 }		--		Green
	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 178, 34, 34 }		--		Red
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 255, 99, 71 }		--      
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 218, 112, 214 }	--		
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 30, 144, 225 }	--		
	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 212, 212, 37 }	--		
	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }		--
	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	--
	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	--
	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	--
	
	-- Handle Player Colors
	PLAYER_COLORS = {}
    PLAYER_COLORS[0] = "#3dd296;"
    PLAYER_COLORS[1] = "#f3c909;"
    PLAYER_COLORS[2] = "#c54da8;"
    PLAYER_COLORS[3] = "#FF6C00;"
    PLAYER_COLORS[4] = "#3455FF;"
    PLAYER_COLORS[5] = "#65d413;"
    PLAYER_COLORS[6] = "#815336;"
    PLAYER_COLORS[7] = "#1bc0d8;"
    PLAYER_COLORS[8] = "#c7e40d;"
    PLAYER_COLORS[9] = "#8c2af4;"

	for team = 0, (DOTA_TEAM_COUNT-1) do
		color = self.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end
	
	self.m_VictoryMessages = {}
	self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
	self.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"
	
	-- Game Rules
	GameRules:SetCustomGameAllowMusicAtGameStart(false)
	GameRules:SetCustomGameAllowBattleMusic(false)
	GameRules:SetCustomGameAllowHeroPickMusic(false)
	GameRules:EnableCustomGameSetupAutoLaunch(true)
	GameRules:SetSameHeroSelectionEnabled(false)
	GameRules:SetHideKillMessageHeaders(false)
	GameRules:SetUseUniversalShopMode(true)
	GameRules:SetHeroRespawnEnabled(false)
	GameRules:SetSafeToLeave(true)
	GameRules:SetCustomGameSetupAutoLaunchDelay(5)
	GameRules:SetCustomGameEndDelay(0)
	GameRules:SetHeroSelectionTime(30)
	GameRules:SetPreGameTime(0)
	GameRules:SetStrategyTime(0)
	GameRules:SetShowcaseTime(0)
	GameRules:SetGoldTickTime(2)
	GameRules:SetStartingGold(500)
	GameRules:SetGoldPerTick(10)
	
	-- Gamemode Rules
	local GameMode = GameRules:GetGameModeEntity()
	GameMode:SetUseCustomHeroLevels(false)
	GameMode:DisableHudFlip(true)
	GameMode:SetBuybackEnabled(true)
	GameMode:SetFogOfWarDisabled(false)
	GameMode:SetUnseenFogOfWarEnabled(true)
	GameMode:SetLoseGoldOnDeath(false)
	GameMode:SetAnnouncerDisabled(true)
	GameMode:SetDeathOverlayDisabled(true)
	GameMode:SetDaynightCycleDisabled(true)
	GameMode:SetWeatherEffectsDisabled(true)
	GameMode:SetRemoveIllusionsOnDeath(true)
	GameMode:SetStashPurchasingDisabled(true)
	GameMode:SetTopBarTeamValuesVisible(false)
	GameMode:SetTopBarTeamValuesOverride(true)
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetSelectionGoldPenaltyEnabled(false)
	GameMode:SetKillingSpreeAnnouncerDisabled(true)
	
	-- Events
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(MazeSurvival, "OnNPCSpawned"), self)
	ListenToGameEvent("player_connect_full", Dynamic_Wrap(MazeSurvival, "OnConnectFull"), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(MazeSurvival, "OnPlayerReconnect"), self)
	ListenToGameEvent("player_disconnect", Dynamic_Wrap(MazeSurvival, "OnPlayerDisconnect"), self)
	ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(MazeSurvival, "OnTeamKillCredit" ), self )
	ListenToGameEvent('entity_killed', Dynamic_Wrap(MazeSurvival, 'OnEntityKilled'), self)
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(MazeSurvival, 'OnEntityHurt'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap( MazeSurvival, 'OnGameRulesStateChange' ), self )
	
	GameMode:SetThink( "OnThink", self, "GlobalThink", 2 )
end

-- Evaluate the state of the game
function MazeSurvival:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end