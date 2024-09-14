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

    wait(15);
    IPrintLnBold("Respawn!");

    // zm_game_module::respawn_players();
    spawnPoints = struct::get_array("initial_spawn_points", "targetname");
                    
    assert(IsDefined(spawnPoints), "Could not find initial spawn points!");

    for(i = 0; i < level.players.size; i++) {
        player = level.players[i];
        spawnPoint = zm::getFreeSpawnpoint( spawnPoints, player );
        player setorigin(spawnPoint.origin);
        player setplayerangles (spawnPoint.angles);
    }
}