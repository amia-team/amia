//::///////////////////////////////////////////////
//:: Trig_RedAche
//:://////////////////////////////////////////////
/*
   Upon entering, applies the Red Ache disease,
   (1d6 initial and secondary STR damage).
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

effect eDisease = EffectDisease(DISEASE_RED_ACHE);

//Apply the effect, and voila!

  ApplyEffectToObject(
     DURATION_TYPE_PERMANENT,
     eDisease,
     oVictim);

}
