/*  Item : Harper Scouts :: Bag of Tricks : Galestone

    --------
    Verbatim
    --------
    This script

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    080406  kfw         Initial release.
    090206  kfw         Bugfix, spell effect dispelling.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"

void KillInvis( object oPC ){

    effect eEff = GetFirstEffect( oPC );
    int nType;
    while( GetIsEffectValid( eEff ) ){
        nType=GetEffectType( eEff );

        if( nType == EFFECT_TYPE_INVISIBILITY || nType == EFFECT_TYPE_ETHEREAL || nType == EFFECT_TYPE_SANCTUARY )
            RemoveEffect( oPC, eEff );

        eEff = GetNextEffect( oPC );
    }
}

void main( ){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables.
            object oPC          = GetItemActivator( );
            location lOrigin    = GetItemActivatedTargetLocation( );

            KillInvis( oPC );

            // Candy.
            ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                EffectVisualEffect( VFX_IMP_PULSE_WIND ),
                oPC );

            // Cycle objects within 20-foot radius.
            object oObject      = GetFirstObjectInShape( SHAPE_SPHERE, 20.0, lOrigin, FALSE, OBJECT_TYPE_AREA_OF_EFFECT );

            while( GetIsObjectValid( oObject ) ){

                // AOE (Airborne).
                if( GetObjectType( oObject ) == OBJECT_TYPE_AREA_OF_EFFECT )
                    DestroyObject( oObject );

                oObject         = GetNextObjectInShape( SHAPE_SPHERE, 20.0, lOrigin, FALSE, OBJECT_TYPE_AREA_OF_EFFECT );

            }

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
