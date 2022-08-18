untyped // bad practice and makes life harder but needed because I chose to rewrite with classes (why did I do that)

global function ShipControllerInit

struct {
	table< entity, entity > ships
	entity shipMover
	entity ship
} file

void function ShipControllerInit()
{
	AddClientCommandCallback( "ship", SpawnShipForPlayer )
	AddClientCommandCallback( "test", testfunc )
}

// Spawn a new spaceship where the player is looking at
bool function SpawnShipForPlayer( entity player, array<string> args )
{
	string type = "straton"
	if ( args.len() )
		type = args[0]

	TraceResults r = GetViewTrace( player )

	var s = Spaceship( type, r.endPos )
	//if( r.hitEnt )
	//s.mover.SetParent( r.hitEnt )
	return true
}

bool function testfunc (entity player, array<string> args ) {
	thread testpls(player)
	return true
}

void function testpls(entity player) {
	while(true) {
		entity guy = CreateMarvin(player.GetTeam(),player.GetOrigin(),player.GetAngles())
		DispatchSpawn( guy )
		guy.Freeze()
		guy.Hide()
		guy.SetMaxHealth(10000)
		guy.SetHealth(10000)

		guy.ReplaceActiveWeapon("mp_weapon_smr")
		entity weapon = guy.GetMainWeapons()[0]

		//weapon.FireWeaponBullet( player.GetOrigin() + player.GetForwardVector()*50  , player.GetViewVector(), 1, DF_GIB | DF_EXPLOSION )
		weapon.FireWeaponMissile( player.EyePosition() + player.GetForwardVector()*100,player.GetViewVector(), 1.0, damageTypes.largeCaliberExp, damageTypes.largeCaliberExp, false, PROJECTILE_NOT_PREDICTED )



		guy.Destroy()
		weapon.Destroy()
		wait 0.05
	}
}

//mp_titanweapon_dumbfire_rockets

