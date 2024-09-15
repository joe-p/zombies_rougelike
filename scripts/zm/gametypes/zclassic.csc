#using scripts\codescripts\struct;

#insert scripts\shared\shared.gsh;

function main()
{
	LuiLoad("ui.uieditor.menus.Craftables.WonderfizzMenuBase");
	level._zombie_gameModePrecache =&onPrecacheGameType;
	level._zombie_gamemodeMain =&onStartGameType;
}

function onPrecacheGameType()
{
	
}

function onStartGameType()
{
	
}
