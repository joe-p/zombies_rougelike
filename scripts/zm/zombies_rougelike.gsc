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
        level.players[i].score += 100000;
    }

    array::thread_all( level.chests, &chest_think );

    wait(10);
    init_shop();
}

function init_shop()
{
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
	
	level thread zm_powerup_fire_sale::toggle_fire_sale_on();
	level.zombie_vars["zombie_powerup_fire_sale_time"] = 90;

	while ( level.zombie_vars["zombie_powerup_fire_sale_time"] > 0)
	{
		WAIT_SERVER_FRAME;
		level.zombie_vars["zombie_powerup_fire_sale_time"] = level.zombie_vars["zombie_powerup_fire_sale_time"] - 0.05;
	}

	level thread zm_powerup_fire_sale::check_to_clear_fire_sale();

	level.zombie_vars["zombie_powerup_fire_sale_on"] = false;
	level notify ( "fire_sale_off" );	
}

// This function waits until the shop is initialized then waits until a box is used to start the shop
function chest_think() {
    level waittill("zombies_rougelike_shop_start");
    user = undefined;
    original_cost = self.zombie_cost;
    self.zombie_cost = 0;

    while( 1 )
	{
        self waittill( "trigger", user );
        if (user == level)
            continue;
        break;
    }

    self waittill("trigger");
    self.zombie_cost = original_cost;
    // End firesale right after box is used
    level.zombie_vars["zombie_powerup_fire_sale_time"] = 0;

    self chest_think();
}