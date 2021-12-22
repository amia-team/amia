#include "inc_ds_died"

void main()
{

    effect eDeath = EffectDamage( 1000 );
    object oPC = GetLastSpeaker();

    SetLocalObject( oPC, "killer", OBJECT_SELF );



    DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDeath, GetLastSpeaker() ) );



}
