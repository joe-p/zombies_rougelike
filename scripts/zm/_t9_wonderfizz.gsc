//----------------------------------------------//
//                                              //
//              Dobby's Wonderfizz              //
//                                              //
//----------------------------------------------//

// major credit to lilrifa for providing base code to work off of

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\spawner_shared;

#insert scripts\shared\version.gsh;
#insert scripts\zm\_zm_utility.gsh;
#insert scripts\shared\ai\utility.gsh;
#insert scripts\shared\ai\systems\behavior.gsh;
#insert scripts\shared\archetype_shared\archetype_shared.gsh;
#insert scripts\shared\shared.gsh;

#using scripts\zm\_zm_score;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_unitrigger;

#precache("menu", "WonderfizzMenuBase");
#precache("lui_menu_data", "cw_perk_buyables.owned_perks");


function autoexec init()
{
    callback::on_connect(&on_player_connected);

    // Register each perk for our menu
    level.cw_perk_buyables = [];

    // Stock 9 perks
    RegisterBuyable("quickrevive");
    RegisterBuyable("deadshot");
    RegisterBuyable("doubletap2");
    RegisterBuyable("staminup");
    RegisterBuyable("armorvest");
    RegisterBuyable("fastreload");
    RegisterBuyable("widowswine");
    RegisterBuyable("additionalprimaryweapon");

    // Logical's Perks
    //RegisterBuyable("jetquiet"); // ffyl
    //RegisterBuyable("immunecounteruav"); // icu
}

// registers a new buyable perk
function RegisterBuyable(speciality)
{
    perk = SpawnStruct();
    perk.name = speciality;

    level.cw_perk_buyables[speciality] = perk;
}


// updates which perks you own
function UpdateOwnedPerks()
{
    ownedPerks = [];
    foreach(perk in level.cw_perk_buyables)
    {
        name = perk.name;
        isOwned = self playerHasPerk(name);

        if(isOwned)
        {
            ownedPerks[ownedPerks.size] = name;
        }
    }

    ownedPerksStr = "";
    foreach(ownedBuyable in ownedPerks)
    {
        ownedPerksStr += (ownedBuyable + "|");
    }
    
    self SetControllerUIModelValue("cw_perk_buyables.owned_perks", ownedPerksStr);
}

// open the menu
function OpenBuyablesMenu()
{
    self CloseMenu("WonderfizzMenuBase");
    self OpenMenu("WonderfizzMenuBase");

    wait 0.05;

    self UpdateOwnedPerks();
}

// returns if the player has the given perk
function playerHasPerk(name)
{
    if(self HasPerk("specialty_" + name))
    {
        return true;
    }
    return false;
}

// on spawned
function on_player_connected()
{
    self thread WatchForMenuResponse();
}

// responds to data from doing something in menu
function WatchForMenuResponse()
{
    self endon("disconnect");

    for(;;)
    {
        self waittill("menuresponse", menu, response);

        // if the menu response isn't from wonderfizz then we dont care
        if(menu != "WonderfizzMenuBase")
        {
            continue;
        }

        // get the perk name, buy perk and update buyables
        responseData = StrTok(response, ".");
        self perkPurchased(responseData);
        self UpdateOwnedPerks();
    }
}

// purchases the given perk
function perkPurchased(responseData)
{
    buyableName = responseData[1];
    buyableCost = Int(responseData[2]);

    if(self zm_score::can_player_purchase(buyableCost) && !self HasPerk("specialty_" + buyableName))
    {
        self zm_score::minus_to_player_score(buyableCost);
        self zm_utility::play_sound_on_ent("purchase");

        self zm_perks::give_perk("specialty_" + buyableName, false);
    }
}