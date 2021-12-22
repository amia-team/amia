//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_cust_feat
//description: Script for custom feats
//used as: Custom featscript

/*
---------
Changelog
---------
Date         Name        Reason
------------------------------------------------------------------
2012-05-03   PoS         Start
2012-09-20   Glim        Added Shadow Fusion
2012-10-02   PoS         Added Tactical Approach
2013-02-23   PoS         Added Bladesinging & Augment Summoning
2013-04-12   Glim        Added Deep Guard Acrobatic Fighting
2013-08-24   Terrah      Using external resources now. See legacy_feats for the olds.
------------------------------------------------------------------
*/

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------

#include "inc_ds_records"
#include "x2_inc_spellhook"
//custom spell constants
#include "inc_dc_feats"
#include "x2_inc_toollib"
#include "x2_inc_itemprop"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "x0_i0_position"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------
string GetSpellScript( string sKey, int nType, int nSubType );


//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main( ){

    object      oPC         = OBJECT_SELF;
    int         nSpell      = GetSpellId( );
    string      sPCKey      = GetName( GetPCKEY( oPC ) );

    int SELF_CAST;
    int DB_TYPE = -1;

    //Translate spellID to database types
    switch( nSpell ){

        case DC_FEAT_ACT: SELF_CAST=2;DB_TYPE=0;break;
        case DC_FEAT_INS: SELF_CAST=2;DB_TYPE=1;break;
        default:return;
    }

    //Have we done the request before?
    string sScript = GetLocalString( oPC, "cp_"+IntToString( SELF_CAST )+"_"+IntToString( DB_TYPE ) );

    if( sScript == "" ){

        //Get the spellscript
        sScript = GetSpellScript( sPCKey, DB_TYPE, SELF_CAST );

        //Didnt find any, use legacy_spells as our spellscript
        if( sScript == "" )
            sScript = "legacy_feats";

        //Save
        SetLocalString( oPC, "cp_"+IntToString( SELF_CAST )+"_"+IntToString( DB_TYPE ), sScript );
    }

    //Debug
    //SendMessageToPC( oPC, sPCKey+" ("+IntToString( SELF_CAST )+":"+IntToString( DB_TYPE )+"): "+sScript );

    //Precast code, this function also trigges the spellhook
    if( !X2PreSpellCastCode( ) ){
        return;
    }

    //Run the script
    ExecuteScript( sScript, OBJECT_SELF );
}


string GetSpellScript( string sKey, int nType, int nSubType ){

    SQLExecDirect( "SELECT File FROM custom_resources WHERE PCKey='"+sKey+"' AND Type='"+IntToString( nType )+"' AND Subtype='"+IntToString( nSubType ) +"'" );
    if( SQLFetch( ) ){

        return SQLGetData( 1 );
    }

    return "";
}
