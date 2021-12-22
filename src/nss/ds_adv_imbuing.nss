//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_adv_imbuing
//group:   dc requests
//used as: action script
//date:    june 02 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "nw_i0_plot"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void AdvancedImbuing( object oPC );
void CreateArrow( object oPC, int nNode, int nSpell, int nLevel, string sName );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    AdvancedImbuing( OBJECT_SELF );
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void AdvancedImbuing( object oPC ){

    int nNode = GetLocalInt( oPC, "ds_node" );

    switch ( nNode ) {

        case 2:     CreateArrow( oPC, nNode, IP_CONST_ONHIT_CASTSPELL_DARKNESS, 17, "Eclipse" );    break;
        case 3:     CreateArrow( oPC, nNode, IP_CONST_ONHIT_CASTSPELL_ACID_FOG, 17, "Emerald Spark" );    break;
        case 4:     CreateArrow( oPC, nNode, IP_CONST_ONHIT_CASTSPELL_FIREBRAND, 17, "Flamespitter" );    break;
        case 5:     CreateArrow( oPC, nNode, IP_CONST_ONHIT_CASTSPELL_SCINTILLATING_SPHERE, 17, "Shockwave" );    break;
        case 6:     CreateArrow( oPC, nNode, IP_CONST_ONHIT_CASTSPELL_WEB, 17, "Spidersilk" );    break;
        case 7:     CreateArrow( oPC, nNode, IP_CONST_ONHIT_CASTSPELL_MASS_BLINDNESS_AND_DEAFNESS, 17, "Stardust" );    break;
    }

    DeleteLocalInt( oPC, "ds_node" );
}

void CreateArrow( object oPC, int nNode, int nSpell, int nLevel, string sName ){

    string sTag   = "ds_imbue_"+IntToString( nNode );

    if ( GetNumItems( oPC, sTag ) < 6 ){

        string sArrow = "nw_wammar00"+IntToString( nNode );
        object oArrow = CreateItemOnObject( sArrow, oPC, 1, sTag );

        IPRemoveAllItemProperties( oArrow, DURATION_TYPE_PERMANENT );

        itemproperty ipOnHit = ItemPropertyOnHitCastSpell( nSpell, nLevel );

        IPSafeAddItemProperty( oArrow, ipOnHit );

        SetName( oArrow, sName );
    }
    else{

        SendMessageToPC( oPC, "You already have 5 of these arrows in your inventory." );
    }
}
