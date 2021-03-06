class FFA_W_DualMK23Weapon extends ScrnDualMK23Pistol;

var class<KFWeapon> SingleWeaponClass;
var class<KFWeaponPickup> SinglePickupClass;

function DropFrom(vector StartLocation)
{
	local int m;
	local KFWeaponPickup Pickup;
	local int AmmoThrown, OtherAmmo;
	local KFWeapon SinglePistol;

	if( !bCanThrow )
		return;

	AmmoThrown = AmmoAmount(0);
	ClientWeaponThrown();

	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		if (FireMode[m].bIsFiring)
			StopFire(m);
	}

	if ( Instigator != None )
		DetachFromPawn(Instigator);

	if( Instigator.Health > 0 )
	{
		OtherAmmo = AmmoThrown / 2;
		AmmoThrown -= OtherAmmo;
		SinglePistol = Spawn(SingleWeaponClass);
		SinglePistol.SellValue = SellValue / 2;
		SinglePistol.GiveTo(Instigator);
		SinglePistol.Ammo[0].AmmoAmount = OtherAmmo;
		SinglePistol.MagAmmoRemaining = MagAmmoRemaining / 2;
		MagAmmoRemaining = Max(MagAmmoRemaining-SinglePistol.MagAmmoRemaining,0);
	}

	Pickup = Spawn(SinglePickupClass,,, StartLocation);

	if ( Pickup != None )
	{
		Pickup.InitDroppedPickupFor(self);
		Pickup.DroppedBy = PlayerController(Instigator.Controller);
		Pickup.Velocity = Velocity;
		//fixing dropping exploit
		Pickup.SellValue = SellValue / 2;
		Pickup.Cost = Pickup.SellValue / 0.75; 
		Pickup.AmmoAmount[0] = AmmoThrown;
		Pickup.MagAmmoRemaining = MagAmmoRemaining;
		if (Instigator.Health > 0)
			Pickup.bThrown = true;
		//Log("--- Pickup "$String(Pickup)$" spawned with Cost = "$Pickup.Cost);
	}

    Destroyed();
	Destroy();
}

defaultproperties
{
	Weight=4.000000
	FireModeClass(0)=Class'FFArms.FFA_W_DualMK23Fire'
	DemoReplacement=Class'FFArms.FFA_W_MK23Weapon'
	SingleWeaponClass=Class'FFArms.FFA_W_MK23Weapon'
	SinglePickupClass=Class'FFArms.FFA_W_MK23Pickup'
	PickupClass=Class'FFArms.FFA_W_DualMK23Pickup'
	ItemName="FFA Dual MK23"
}
