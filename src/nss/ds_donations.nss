//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_donations
//group:   gods and such
//used as: OnClose script
//date:    jan 04 2009
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
object GetNearestIdol( object oPLC );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC          = GetLastClosedBy();
    object oPLC         = OBJECT_SELF;
    object oIdol        = GetNearestIdol( oPLC );
    string sArea        = SQLEncodeSpecialChars( GetName( GetArea( oPLC ) ) );
    string sTag         = GetTag( oIdol );
    int nGold           = GetGold( oPLC );


    if ( nGold > 0 ){

        ds_take_item( oPLC, "NW_IT_GOLD001" );

        string sPC    = SQLEncodeSpecialChars( GetName( oPC ) );

        if ( GetIsObjectValid( oIdol ) && GetDistanceBetween( oIdol, oPLC ) < 5.0 ){

            int nRatio    = GetGold( oPC ) / nGold;

            if ( nRatio < 11 ){

                object oDroppedGold = GetNearestObjectByTag( "NW_IT_GOLD001" );

                DestroyObject( oDroppedGold );

                effect eBless       = EffectTemporaryHitpoints( d10( GetHitDice( oPC ) ) );
                effect eVFX         = EffectVisualEffect( VFX_IMP_PULSE_HOLY );

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBless, oPC, 600.0 );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oPC );

                AssignCommand( oIdol, SpeakString( "*blesses you*" ) );
            }

            effect eVFX         = EffectVisualEffect( VFX_IMP_FLAME_S );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oIdol );
        }
        else{

            sTag = "-";
        }

        string sQuery = "INSERT INTO donations VALUES ( NULL, '"+sArea+"', '"+sTag+"', '"+sPC+"', '"+IntToString( nGold )+"', NOW() )";

        SQLExecDirect( sQuery );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

object GetNearestIdol( object oPLC ){

    object oObject = GetNearestObject( OBJECT_TYPE_PLACEABLE, oPLC );
    int i;

    while ( GetIsObjectValid( oObject ) ){

        if ( GetResRef( oObject ) == "ds_idol" ){

            return oObject;
        }

        if ( i > 20 ){

            return OBJECT_INVALID;
        }

        ++i;

        oObject = GetNearestObject( OBJECT_TYPE_PLACEABLE, oPLC, i );
    }

    return OBJECT_INVALID;
}
