/*  ds_action_clean

    --------
    Verbatim
    --------
    Cleans up the generic convo action system after a convo has finished

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    22-10-06  Disco       Start of header
    ------------------------------------------------------------------


*/
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_crafting"



void main(){

    //Get PC
    object oPC       = GetPCSpeaker();
    int i;

    DeleteLocalInt( oPC, "is_crafting" );

    clean_vars( oPC, 4 );

    effect eLoop = GetFirstEffect( oPC );

    while ( GetIsEffectValid( eLoop ) ){

        if ( GetEffectType( eLoop ) == EFFECT_TYPE_CUTSCENEIMMOBILIZE &&
             GetEffectCreator( eLoop ) == oPC &&
             GetEffectSubType( eLoop ) == SUBTYPE_EXTRAORDINARY ){

            RemoveEffect( oPC, eLoop );

            //feedback
            SendMessageToPC( oPC, "[Removing crafting effects]" );

        }

        eLoop = GetNextEffect( oPC );
    }
}
