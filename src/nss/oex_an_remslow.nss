//::///////////////////////////////////////////////
//:: OnExit Trigger Event
//:: oes_an_remslow
//:: Anatida 8/5/2015
//:: FadedWings 11/08/2015
//:://////////////////////////////////////////////
/*
Removes the (permanent) slowed effect from the PC exiting the trigger.
*/

#include "NW_I0_SPELLS"

void main()
{
    object oPC = GetExitingObject();
    string sTag = GetTag( OBJECT_SELF );

    if (!GetIsPC(oPC)) return;

    effect eRemove = GetFirstEffect( oPC );
    object oCreator =  GetEffectCreator( eRemove );

    while( GetIsEffectValid( eRemove ) )
    {
        oCreator =  GetEffectCreator( eRemove );
        if( GetTag(oCreator) == sTag )
        {
            RemoveEffect(oPC, eRemove );
        }
        eRemove = GetNextEffect (oPC);
    }

}
