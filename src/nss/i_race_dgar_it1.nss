// Spell-like Ability: Invisibility
#include "x2_inc_switches"
void DoInvis(object oPC);
void main(){

    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ACTIVATE:{

            // vars
            object  oPC         = GetItemActivator();


            AssignCommand( oPC,DoInvis(oPC) );

            break;
        }
        default:{
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}

void DoInvis(object oPC)
{
            int     nHD         = GetHitDice(oPC);
            float   fDuration   = TurnsToSeconds( nHD );   // 1 turn per level
            effect  eInvis      = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);

            // anim
            AssignCommand( oPC, PlaySound( "sdr_invisible" ) );

            // wink em out!
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eInvis, oPC, fDuration);
}
