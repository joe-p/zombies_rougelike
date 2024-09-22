#namespace zrl_perks; 

function init() 
{
    level.zrl_player_perk_fns = SpawnStruct();
    level.zrl_player_perk_fns.levelup = SpawnStruct();
    level.zrl_player_perk_fns.levelup.armorvest = &player_levelup_armorvest;
}
 
function player_init() 
{
    self.zrl_perks = SpawnStruct();
}

// Jugg
function player_levelup_armorvest() {
    if (!IsDefined(self.zrl_perks.armorvest)) {
        self.zrl_perks.armorvest = SpawnStruct();
        self.zrl_perks.armorvest["level"] = 1;

        self.maxhealth = self.maxhealth + 50;

        return;
    }

    self.maxhealth = self.maxhealth + 25;
}