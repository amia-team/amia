//::///////////////////////////////////////////////
//:: Trig_Sildoom
//:://////////////////////////////////////////////
/*
   Upon entering, applies the Slimy Doom disease,
   (1d5 initial and secondary DEX damage).
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

effect eDisease = EffectDisease(DISEASE_SLIMY_DOOM);

//Apply the effect, and voila!

  ApplyEffectToObject(
     DURATION_TYPE_PERMANENT,
     eDisease,
     oVictim);

}
