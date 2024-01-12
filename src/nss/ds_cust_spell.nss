//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_cust_spell
//description: Script for custom spells
//used as: Custom spellscript

/*
---------
Changelog
---------
Date         Name        Reason
------------------------------------------------------------------
2010-03-14   James       Start
2013-07-06   PoS         Refactored, removed old unused spells and shifted some utility functions into the include.
2013-08-10   Terrah      Moved old script to legacy_spells reworked
------------------------------------------------------------------
*/

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "inc_dc_spells"
#include "aps_include"
#include "NW_I0_SPELLS"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

//Retuns a scriptname if one exists for the desired values
//empty string if none
string GetSpellScript( string sKey, int nType, int nSubType );

void main( ){

    object      oPC         = OBJECT_SELF;
    int         nSpell      = GetSpellId( );
    string      sPCKey      = GetName( GetPCKEY( oPC ) );

    CantripRefresh();

    if( sPCKey == "" )
        sPCKey = GetLocalString( oPC, "PCKEY" );

    if( sPCKey == "" ){
        SpeakString( "Invalid PCKey!" );
        return;
    }

    int SELF_CAST;
    int DB_TYPE = -1;

    //Translate spellID to database types
    switch( nSpell ){

        case DC_SPELL_R_0: SELF_CAST=FALSE;DB_TYPE=0;break;
        case DC_SPELL_R_1: SELF_CAST=FALSE;DB_TYPE=1;break;
        case DC_SPELL_R_2: SELF_CAST=FALSE;DB_TYPE=2;break;
        case DC_SPELL_R_3: SELF_CAST=FALSE;DB_TYPE=3;break;
        case DC_SPELL_R_4: SELF_CAST=FALSE;DB_TYPE=4;break;
        case DC_SPELL_R_5: SELF_CAST=FALSE;DB_TYPE=5;break;
        case DC_SPELL_R_6: SELF_CAST=FALSE;DB_TYPE=6;break;
        case DC_SPELL_R_7: SELF_CAST=FALSE;DB_TYPE=7;break;
        case DC_SPELL_R_8: SELF_CAST=FALSE;DB_TYPE=8;break;
        case DC_SPELL_R_9: SELF_CAST=FALSE;DB_TYPE=9;break;

        case DC_SPELL_S_0: SELF_CAST=TRUE;DB_TYPE=0;break;
        case DC_SPELL_S_1: SELF_CAST=TRUE;DB_TYPE=1;break;
        case DC_SPELL_S_2: SELF_CAST=TRUE;DB_TYPE=2;break;
        case DC_SPELL_S_3: SELF_CAST=TRUE;DB_TYPE=3;break;
        case DC_SPELL_S_4: SELF_CAST=TRUE;DB_TYPE=4;break;
        case DC_SPELL_S_5: SELF_CAST=TRUE;DB_TYPE=5;break;
        case DC_SPELL_S_6: SELF_CAST=TRUE;DB_TYPE=6;break;
        case DC_SPELL_S_7: SELF_CAST=TRUE;DB_TYPE=7;break;
        case DC_SPELL_S_8: SELF_CAST=TRUE;DB_TYPE=8;break;
        case DC_SPELL_S_9: SELF_CAST=TRUE;DB_TYPE=9;break;
        default:return;
    }

    //Have we done the request before?
    string sScript = GetLocalString( oPC, "cp_"+IntToString( SELF_CAST )+"_"+IntToString( DB_TYPE ) );

    if( sScript == "" ){

        //Get the spellscript
        sScript = GetSpellScript( sPCKey, DB_TYPE, SELF_CAST );

        //Didnt find any, use legacy_spells as our spellscript
        if( sScript == "" )
            sScript = "legacy_spells";

        //Save
        SetLocalString( oPC, "cp_"+IntToString( SELF_CAST )+"_"+IntToString( DB_TYPE ), sScript );
    }

    //Debug
    //SendMessageToPC( oPC, sPCKey+" ("+IntToString( SELF_CAST )+":"+IntToString( DB_TYPE )+"): "+sScript );

    //Spells that shouldnt do the precast code should be added to the expetions here
    if( sScript != "legacy_spells" &&
        sScript != "td_iron_to_steel" ){

        //Precast code, this function also trigges the spellhook
        if( !X2PreSpellCastCode( ) ){
            return;
        }
    }

    //Run the script
    ExecuteScript( sScript, OBJECT_SELF );
}

//-----------------------------------------------------------------------------
// defs
//-----------------------------------------------------------------------------

string GetSpellScript( string sKey, int nType, int nSubType ){

    SQLExecDirect( "SELECT File FROM custom_resources WHERE PCKey='"+sKey+"' AND Type='"+IntToString( nType )+"' AND Subtype='"+IntToString( nSubType ) +"'" );
    if( SQLFetch( ) ){

        return SQLGetData( 1 );
    }

    return "";
}
