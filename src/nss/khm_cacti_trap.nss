//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  khm_cacti_trap
//group:   traps
//used as: trigger OnEnter script
//date:    aug 02 2008
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oTrigger  = OBJECT_SELF;
    object oPLC      = GetFirstInPersistentObject( oTrigger, OBJECT_TYPE_PLACEABLE );
    object oPC       = GetEnteringObject();

    //only PCs and companions trigger this
    if ( !GetIsPC( oPC ) && GetAssociateType( oPC ) == ASSOCIATE_TYPE_NONE ){

        return;
    }

    //block for 15 mins
    if ( GetIsBlocked() ){

        return;
    }

    SetBlockTime( oTrigger, 15 );

    //cacti aren't always 'ripe'
    if ( d10() < 6 ){

        return;
    }

    while ( GetIsObjectValid( oPLC ) ) {

        if ( GetTag( oPLC ) == "khm_cactus" ){

            ExecuteScript( "khm_cacti_boom", oPLC );
            break;
        }

        oPLC = GetNextInPersistentObject( oTrigger, OBJECT_TYPE_PLACEABLE );
    }
}

