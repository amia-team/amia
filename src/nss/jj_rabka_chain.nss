//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: jj_rabka_chain
//description: Used on the pull chain in the Mysterious Ruins to summon the boss
//used as: placable onUsed script
//date:    Aug 10 2010
//author:  Jehran

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "amia_include"
#include "inc_ds_records"

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main()
{
    object oPC = GetLastUsedBy();
    if (GetIsBlocked())
    {
        FloatingTextStringOnCreature("*you hear a bell but then nothing*", oPC);
        SendMessageToPC( oPC, "You can't summon it again that quickly");
        return;
    }
    struct _ECL_STATISTICS ecl = GetECL(oPC);
    if (ecl.fECL < 25.0)
    {
        FloatingTextStringOnCreature("*you hear a bell but then nothing*", oPC);
        SendMessageToPC( oPC, "You need to be ECL 25+");
        return;
    }
    string sPCKEY = GetLocalString( oPC, "pckey" );
    if ( GetLocalInt( OBJECT_SELF, sPCKEY ) )
    {
        FloatingTextStringOnCreature("*you hear a bell but then nothing*", oPC);
        SendMessageToPC(oPC, "You aren't interesting anymore." );
        return;
    }
    FloatingTextStringOnCreature("*you hear a bell and then a roar*", oPC);
    SetLocalInt(OBJECT_SELF, sPCKEY, TRUE);
    SetBlockTime(OBJECT_SELF, 15);
    DelayCommand(4.0f, ds_spawn_critter_void( oPC, "mc_amiaforest_boss", GetLocation(OBJECT_SELF), TRUE, "mc_amiaforest_boss" ));
}
