//::///////////////////////////////////////////////
//:: Trig_FilFever
//:://////////////////////////////////////////////
/*
   Upon entering, applies the Filth Fever disease,
   (1d3 initial and secondary CON and INT damage).
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

effect eDisease = EffectDisease(DISEASE_FILTH_FEVER);

//Apply the effect, and voila!

  ApplyEffectToObject(
     DURATION_TYPE_PERMANENT,
     eDisease,
     oVictim);

}
