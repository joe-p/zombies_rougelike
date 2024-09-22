#using scripts\codescripts\struct; 
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared; 
#using scripts\zm\_zm_score;
#using scripts\zm\_zm;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\shared\array_shared;
#using scripts\zm\_zm_utility; 
#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_t9_wonderfizz;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_bgb_machine;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh; 
#insert scripts\zm\_zm_utility.gsh; 

#using scripts\zm\_load; 

#namespace zombies_rougelike; 

REGISTER_SYSTEM_EX( "zombies_rougelike", &__init__, &__main__, undefined ) 

function __init__(){
}

function __main__(){
    debug_mode = true;
    level waittill("initial_blackscreen_passed");
    IPrintLnBold("Welcome to Zombies Rougelike v0.0.0!");

    level.func_override_wallbuy_prompt = &disable_wallbuy_purchase;

    foreach(player in level.players)
    {
        player GiveWeapon(GetWeapon("bowie_knife"));
        if (debug_mode) {
            player zm_score::add_to_player_score( 100000 );
        }
    }

    foreach(chest in level.chests)
    {
        chest.zrl_cost_mult = 1;
        chest.zrl_cost = chest.zombie_cost;
        chest zm_magicbox::hide_chest();
    }
    // Fire sale logic checks if ( level.chest_index != i ), so we need to set chest_index to a random number
    level.chest_index = 1337;

    foreach(bgb_machine in level.bgb_machines)
    {
        bgb_machine thread bgb_machine::hide_bgb_machine(0);
    }

    zombie_utility::set_zombie_var("zombie_move_speed_multiplier", 10, false, 2);

    perk_machines = GetEntArray("zombie_vending", "targetname");
    foreach(perk in perk_machines) {
        perk.machine Delete();
        perk.bump Delete();
        perk.clip ConnectPaths();
        perk.clip Delete();
        perk Delete();
    }

    thread round_think();

    if (debug_mode) {
        thread init_shop();
    }
}

function disable_wallbuy_purchase() {
    self SetHintString("Wallbuys are disabled in Zombies Rougelike!");
    return false;
}

function round_think() {
    shop_interval = 3;

    while(1) {
        level waittill("between_round_over");

        // Shop is every 3 rounds
        if (zm::get_round_number() % shop_interval == 0) {
            init_shop();
        }
    }
}

function init_shop()
{
    // Ensure no zombies spawn during the shop
    SetDvar("ai_DisableSpawn",1);

    duration = 60;
	level.zombie_vars["zombie_powerup_fire_sale_time"] = duration;

    // Be sure to think after starting the firesale started so the cost is updated correctly (and not 10)
    level thread zm_powerup_fire_sale::start_fire_sale(level.players[0]);
    if (!level.zombie_vars["zombie_powerup_fire_sale_on"]) {
        level waittill("fire_sale_on");
    }
    array::thread_all( level.chests, &chest_think );
    foreach(bgb_machine in level.bgb_machines)
    {
        bgb_machine.base_cost = 5000;
    }

    IPrintLnBold("You have " + duration + " seconds to use the shop and go to the mystery box!");
    level notify("zombies_rougelike_shop_start");
    
    foreach(player in level.players)
    {
        player _t9_wonderfizz::OpenBuyablesMenu();
    }


	level waittill ( "fire_sale_off" );
    level notify("zombies_rougelike_shop_stop");

    SetDvar("ai_DisableSpawn",0);
}

// Wait until the shop has started and then update the chest cost based on the player's current chest cost
function chest_think() {
    level endon("zombies_rougelike_shop_stop");
    while( 1 )
    {
        self.zombie_cost = self.zrl_cost;
        self waittill( "chest_accessed" );
        self.zrl_cost_mult = self.zrl_cost_mult * 2;
        self.zrl_cost = self.zrl_cost * self.zrl_cost_mult;
    }
}