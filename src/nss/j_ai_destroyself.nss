/************************ [Destroy Ourself] ************************************
    Filename: J_AI_DestroySelf
************************* [Destroy Ourself] ************************************
    This is executed OnDeath to clean up the corpse. It helps - clears all
    non-droppable stuff.

    It is not fired if there are corpses or whatever :-)

    Sorts destroyed things.

    Oh, if this is executed any other time when they are dead, they are
    destroyed instantly.
************************* [History] ********************************************
    1.3 - Added to replace a include function for death.
        - No locals are destroyed. The game should do that anyway. Items are, though.
************************* [Workings] *******************************************
    this, if ever fired, will destroy the creature. It is not deleayed - there
    is a special function in the death script to check the whole "Did I get
    raised?" stuff.

    I suppose you can edit this to put a corpse in :-D
************************* [Arguments] ******************************************
    Arguments: N/A - none needed.
************************* [Destroy Ourself] ***********************************/


// Exectued from death, to speed things up.
#include "j_inc_constants"
#include "inc_ds_ondeath"
//#include "spawn_functions"
//#include "inc_lootcorpse"

void main()
{
    object oCreature = OBJECT_SELF;

    // To not crash limbo. Destroying in limbo crashes a server (1.2 bugfix)
    if ( !GetIsObjectValid(GetArea(oCreature)) )
       return;

    // Must be dead.
    if ( !GetIsDead(oCreature) )
        return;

    // Totally dead - no death file, no raising.
    SetAIInteger( I_AM_TOTALLY_DEAD, TRUE );

    // 76: "[Dead] Destroying self finally."
    DebugActionSpeakByInt( 76 );
    SetIsDestroyable( TRUE, FALSE, FALSE );

    //GenerateLoot( oCreature );
    //CreateLootableCorpse( oCreature );

    // Check Trigger Camp
    /*
    object oCamp = GetLocalObject( oCreature, "TriggerCamp" );
    if ( GetIsObjectValid(oCamp) ) {
        if ( TriggerCampState(oCamp) == FALSE )
            DestroyTriggerCamp( oCamp );
    }
    */

// Note: we never do more then one death removal check. DM's can re-raise
// and kill a NPC if they wish.
}
