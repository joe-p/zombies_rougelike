#using scripts\codescripts\struct; 
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared; 
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_game_module;
#using scripts\zm\_zm;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\shared\array_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh; 
#insert scripts\zm\_zm_utility.gsh; 

#using scripts\zm\_load; 

#namespace zombies_rougelike; 

REGISTER_SYSTEM_EX( "zombies_rougelike", &__init__, &__main__, undefined ) 

function __init__(){
}

function __main__(){
    level waittill("initial_blackscreen_passed");
    IPrintLnBold("Hello World!");

    for(i = 0; i < level.players.size; i++) {
        player = level.players[i];
        player.score += 100000;
        player.zrl_chest_cost_mult = 2;
    }

    init_shop();
}

function init_shop()
{
    array::thread_all( level.chests, &chest_think );

	// If chests use a special leaving wait till it is away
	if( IS_TRUE( level.custom_firesale_box_leave ) )
	{
		while( zm_powerup_fire_sale::firesale_chest_is_leaving() )
		{
			WAIT_SERVER_FRAME;
		}
	}

	level notify ("powerup fire sale");
	level endon ("powerup fire sale");

    IPrintLnBold("You have 90 seconds to use the shop and go to the mystery box!");
    level notify("zombies_rougelike_shop_start");
	    
	level.zombie_vars["zombie_powerup_fire_sale_on"] = true;
	level.disable_firesale_drop = true;


    // Store the original cost of the chests
    for(i = 0; i < level.chests.size; i++) {
        level.chests[i].old_cost = level.chests[i].zombie_cost;
    }
	
	level thread zm_powerup_fire_sale::toggle_fire_sale_on();

    // Iterate over the chests and set their zombie_cost to old_cost (the original price before firesale)
    for(i = 0; i < level.chests.size; i++) {
        level.chests[i].zombie_cost = level.chests[i].old_cost;
    }

	level.zombie_vars["zombie_powerup_fire_sale_time"] = 90;

	while ( level.zombie_vars["zombie_powerup_fire_sale_time"] > 0)
	{
		WAIT_SERVER_FRAME;
		level.zombie_vars["zombie_powerup_fire_sale_time"] = level.zombie_vars["zombie_powerup_fire_sale_time"] - 0.05;
	}

	level thread zm_powerup_fire_sale::check_to_clear_fire_sale();

	level.zombie_vars["zombie_powerup_fire_sale_on"] = false;
	level notify ( "fire_sale_off" );

    level notify("zombies_rougelike_shop_stop");

    // Iterate over players and reset their chest cost multiplier
    for(i = 0; i < level.players.size; i++) {
        level.players[i].zrl_chest_cost_mult = 1;
    }
}

// Wait until the shop has started and then update the chest cost based on the player's current chest cost
function chest_think() {
    level endon("zombies_rougelike_shop_stop");
    while( 1 )
    {
        user = self.chest_user;
        // Wait until there is a chest user
        if (user === undefined || user == level) { 
            wait(0.1);
            continue;
        }

        self.zombie_cost = self.zombie_cost * user.zrl_chest_cost_mult;
        user.zrl_chest_cost_mult = user.zrl_chest_cost_mult * 2;

        // Once this is triggered, the chest_user should be set to undefined
        self waittill( "chest_accessed" );
    }
}