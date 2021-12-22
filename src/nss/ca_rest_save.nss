// OnConversation action: playerrest: save
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 20050325   jking            Initial release

#include "amia_include"

void main()
{
    object oPC = GetPCSpeaker();
    AssignCommand( oPC, ClearAllActions() );
    AR_ExportPlayer( oPC );
}

