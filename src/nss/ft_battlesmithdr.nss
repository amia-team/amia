/*
    Custom Feat (Self): Battlesmith Damage Resistance
        Grants DR 3/- (unlimited) to user, only removed by resting.

    Created: August 13th, 2014 - Glim
*/

#include "x2_inc_spellhook"
void BattlesmithDR( object oPC );

void main()
{
    BattlesmithDR( OBJECT_SELF );
}

void BattlesmithDR( object oPC )
{
    effect eDR = ExtraordinaryEffect( EffectDamageReduction( 3, DAMAGE_POWER_ENERGY, 0 ) );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eDR, oPC );
//Debug
SendMessageToPC( oPC, "Success!" );
}
