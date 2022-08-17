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
	int burst = 0
	while (burst < 1) {
		burst ++
		entity guy = CreateSoldier(TEAM_BOTH,player.GetOrigin(),player.GetAngles())
		DispatchSpawn( guy )
		guy.Hide()
		guy.ReplaceActiveWeapon("mp_weapon_defender")
		entity weapon = guy.GetMainWeapons()[0]

		vector origin = player.GetOrigin() + player.GetViewVector() * 50
		vector dir = player.GetViewVector()
		weapon.FireWeaponBullet( origin , dir, 1, DF_GIB | DF_EXPLOSION )

		vector traceEnd = origin + player.GetViewVector() * 56756 //max length
		TraceResults r = TraceLine( origin, traceEnd, [], TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

		CreateWeaponTracer(origin , r.endPos ,1)

		guy.Destroy()
		weapon.Destroy()
		wait 0.05
	}
}

/*
entity guy = CreateSoldier(TEAM_UNASSIGNED,expect vector(this.ship.GetOrigin()),expect vector(this.ship.GetAngles()))
DispatchSpawn( guy )
guy.Hide()
guy.ReplaceActiveWeapon("mp_weapon_defender")
entity weapon = guy.GetMainWeapons()[0]

vector shootvector = <this.ship.GetForwardVector().x,this.ship.GetForwardVector().y,this.ship.GetForwardVector().z + 1.5> //slightly up
vector au = AnglesToUp(this.ship.GetAngles())
vector af = AnglesToForward(this.ship.GetAngles())
vector ar = AnglesToRight(this.ship.GetAngles())

vector origin = expect vector (this.ship.GetOrigin() + (af * this.config.barrel1cannonPosForward) + (au * this.config.barrel1cannonPosUp) + (ar * this.config.barrel1cannonPosRight))

weapon.FireWeaponBullet( origin , shootvector, 1, DF_GIB | DF_EXPLOSION )



vector traceEnd = origin + af * 56756 //max length
TraceResults r = TraceLine( origin, traceEnd, [], TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

CreateWeaponTracer(origin , r.endPos ,1)


guy.Destroy()
weapon.Destroy()*/