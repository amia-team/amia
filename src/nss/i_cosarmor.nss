/*  Item :: Cosmik's Female-only Armor

    --------
    Verbatim
    --------
    This script will make it uncomfortable for male genders to wear a specific armor.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    070806  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"


void main( ){

    // Variables.
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_EQUIP:{

            // Variables.
            object oPC              = GetPCItemLastEquippedBy( );

            // Females are graced.
            if( GetGender( oPC ) == GENDER_FEMALE )
                break;

            // Discomfort for males.
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectCurse( ), oPC );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_COM_BLOOD_CRT_RED ), oPC );
            FloatingTextStringOnCreature( "<cþþ>- The armor feels a bit tight. -</c>", oPC );

            break;

        }

        default:{
            nResult = X2_EXECUTE_SCRIPT_CONTINUE;
            break;
        }

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}

