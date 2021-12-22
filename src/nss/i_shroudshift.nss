#include "x2_inc_switches"

void Shift1( object oPC ){

    SetCreatureAppearanceType( oPC, 466 );
    //SendMessageToPC( oPC, "Current portrait: "+GetPortraitResRef( oPC ) );
    SetPortraitResRef( oPC, "po_lichkmasked_" );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_POLYMORPH ), oPC );
}

void Shift2( object oPC ){

    SetCreatureAppearanceType( oPC, 6 );
    SetPortraitResRef( oPC, "TAZUL" );
    SetCreatureBodyPart( CREATURE_PART_HEAD, 20, oPC );
    SetCreatureTailType( 0, oPC );
    SetColor( oPC, COLOR_CHANNEL_SKIN, 4 );
    SetColor( oPC, COLOR_CHANNEL_HAIR, 63 );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_POLYMORPH ), oPC );
}

void main( ){

    // Variables.
    int nEvent  = GetUserDefinedItemEventNumber( );
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            object oPC = GetItemActivator();

            if( GetResRef( GetItemActivated( ) ) == "shroudsh_1" ){
                DelayCommand( 9.0, Shift1( oPC ) );
            }
            else{
                Shift2( oPC );
            }

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

