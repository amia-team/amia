/*  a_c_languages

    --------
    Verbatim
    --------
    Sets bonus language from convo screen

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    22-07-06  Disco       Start of header
    20071118  Disco       Using inc_ds_records now
    ------------------------------------------------------------------
*/

//includes
#include "inc_ds_records"

void main(){


    //comes from ExecuteScript target
    object oPC              = GetLocalObject( OBJECT_SELF, "lan_target");
    int nLanguagesTaken     = GetLocalInt( oPC, "languages_taken" ) + 1;

    //get convo node
    int nNode    = GetLocalInt( oPC, "ds_node" );

    //set journal entry
    AddJournalQuestEntry( "lan_"+IntToString( nNode ), 1, oPC, FALSE );

    //set journal
    SetPCKEYValue( oPC, "lan_"+IntToString( nNode ), 1 );
    SetPCKEYValue( oPC, "languages_taken", nLanguagesTaken );

    //save character
    ExportSingleCharacter( oPC );

}
