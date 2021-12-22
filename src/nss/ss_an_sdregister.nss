//::///////////////////////////////////////////////
//:: FileName ss_an_sdregister
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Anatida
//:: Created On: 5/18/2014 10:25:52 PM
//:://////////////////////////////////////////////
//:: Catalogs PCs that register.
//:: Made generic to be used for other things.
//:: Gives item based off of local variable
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

void main()
{
    object oPC = GetPCSpeaker();
    string sItem = GetLocalString(OBJECT_SELF, "GiveItem");
    string sPCName = GetName( oPC );
    string sName;
    int i;
    int nCount = GetLocalInt( OBJECT_SELF, "npc_g_i" );

    if ( GetIsPC( oPC ) ){

        for ( i=0; i<nCount; ++i ){

            sName = GetLocalString( OBJECT_SELF, "npc_g_"+IntToString( i ) );

            if ( sName == sPCName ){

                break;
            }
        }

        if ( sName != sPCName ){

//            SendMessageToPC( oPC, "*identifies you*" );

            TurnToFaceObject( oPC );

            SetLocalString( OBJECT_SELF, "npc_g_"+IntToString( i ), sPCName );
            SetLocalInt( OBJECT_SELF, "npc_g_"+IntToString( i ), NWNX_GetRunTime() );
            SetLocalInt( OBJECT_SELF, "npc_g_i", nCount + 1 );
            CreateItemOnObject(sItem, oPC, 1);
            //CreateItemOnObject("sdtextbook", oPC, 1);

        }
    }
}
