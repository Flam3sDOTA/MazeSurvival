GameUI.SetCameraDistance(1300);
var minotaur = null;
var minotaurHealthProgressBar = null;
var minotaurHealthLabel = null;

function OnScoreboardButtonPressed() {
	Game.EmitSound("ui_chat_slide_in")
}

function OnLeaderboardButtonPressed() {
	Game.EmitSound("ui_chat_slide_in")
}

function OnShopButtonPressed() {
  Game.EmitSound("ui_chat_slide_out")
  $("#Items").ToggleClass("ShopHidden");
}

function UIContinuePressed() {
  Game.EmitSound("ui_chat_slide_out")
  $("#PopupWindow").ToggleClass("Invisible");
}

function createHealthBars() {
    minotaurHealthProgressBar = $.CreatePanel("ProgressBar", $("#BossProgressBarContainer"), "BossProgressBar");
    minotaurHealthProgressBar.min = 0;
    minotaurHealthProgressBar.max = 100;
    minotaurHealthProgressBar.value = 100;
    minotaurHealthLabel = $.CreatePanel("Label", $("#BossProgressBarContainer"), "BossLabel");
    minotaurHealthLabel.AddClass("BossLabel");
}

function startUpdateHealthBarLoop() {
    updateHealthBar();
    $.Schedule(1.0 / 30.0, startUpdateHealthBarLoop);
}

function updateHealthBar() {
    minotaurHealthProgressBar.value = Entities.GetHealthPercent(minotaur);
    minotaurHealthLabel.text = Entities.GetHealthPercent(minotaur) + "%";
}

function startFindUnitsLoop() {
    var allUnits = Entities.GetAllEntities()
    for (var unit of allUnits) {
        var unitName = Entities.GetUnitName(unit)
        if (unitName == "unit_minotaur") {
            minotaur = unit;
        }
    }

    if (minotaur) {
        createHealthBars();
        startUpdateHealthBarLoop();
    } else {
        $.Schedule(1, startFindUnitsLoop)
    }
}

function BossHPTickUp()
{
	if ( $( "#BossProgressBar" ).value < 1.0 )
	{
		$( "#BossProgressBar" ).value = $( "#BossProgressBar" ).value + 0.025;
	}
}

startFindUnitsLoop();