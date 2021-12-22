//::///////////////////////////////////////////////
//:: Trig_Vermmad
//:://////////////////////////////////////////////
/*
   Upon entering, applies the Vermin Madness disease,
   (1 initial and secondary INT, WIS and CHA damage).
*/
//:://////////////////////////////////////////////
//:: Created By: PaladinOfSune
//:: Created On: 23rd February 2006
//:://////////////////////////////////////////////


void main()
{

// Definition of variables.

object oVictim = GetEnteringObject();

if( !GetIsPC( oVictim ) )
        return;

effect eDisease = EffectDisease(DISEASE_VERMIN_MADNESS);

//Apply the effect, and voila!

  ApplyEffectToObject(
     DURATION_TYPE_PERMANENT,
     eDisease,
     oVictim);

}
