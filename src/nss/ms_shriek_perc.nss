//name:     ms_shriek_perc
//date:     1/8/2017
//author    msheeler

#include "inc_ds_spawns"

void main()
{

    //variables

    object oPC = GetLastPerceived();
    object oArea = GetArea( oPC );
    object oTrigger = GetNearestObjectByTag("db_spawntrigger", oPC, 1);
    object oSpawnpoint = GetRandomSpawnpoint(oTrigger);

    effect eVFX = EffectVisualEffect(VFX_FNF_SOUND_BURST);

    location lLocation = GetLocation(OBJECT_SELF);

    //if we have screamed in the last turn don't do it again.
    if ( GetIsBlocked(OBJECT_SELF) > 0 )
    {
        return;
    }

    //if the last creature seen was a PC then we will scream and attract a spawn group
    if (GetIsPC(oPC))
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lLocation);
        DelayCommand( 1.0, GetCrittersFromArea( oPC, oArea, oSpawnpoint ) );
        SetBlockTime( OBJECT_SELF, 2, 0 );
    }
}
