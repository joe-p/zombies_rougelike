#using scripts\zm\_zm_perks;

#namespace zrl_perks; 

function init() 
{
    level.zrl_player_perk_fns = SpawnStruct();
    level.zrl_player_perk_fns.levelup = [];
    level.zrl_player_perk_fns.levelup["armorvest"] = &player_levelup_armorvest;
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

        self.n_player_health_boost = 50;
    } else {
        self.n_player_health_boost = self.n_player_health_boost + 25;
        self.zrl_perks.armorvest["level"] = self.zrl_perks.armorvest["level"] + 1;
    }

    self zm_perks::perk_set_max_health_if_jugg("health_reboot", 1, 0);
}