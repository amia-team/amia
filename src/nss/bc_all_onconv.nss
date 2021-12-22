/*  Bardic College - OnConversation Script.

    --------
    Verbatim
    --------
    Used for one liners and conversations when conversing with NPCs.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    101206  Aleph       Initial release.
    012307  Aleph       Twilight Stage revision.
    20071118  Disco       Using inc_ds_records now
    ------------------------------------------------------------------
*/

//includes
#include "inc_ds_records"

void main(){

    object oPC = GetLastSpeaker();


//    ExecuteScript("nw_c2_default4", OBJECT_SELF);


//  Gypsy speech and recognition checks.

    if(GetTag(OBJECT_SELF) == "bc_npc_fortune" && GetPCKEYValue( oPC, "bc_fortune") == 0)
    {
        ActionSpeakString("Hallo!  Would ju like to have yor fortune told?   Only five golds! [Speak to her again.]", TALKVOLUME_WHISPER);
        SetPCKEYValue(oPC, "bc_fortune", 1);
        return;
    }
    if(GetTag(OBJECT_SELF) == "bc_npc_fortune" && GetPCKEYValue(oPC, "bc_fortune") == 1)
    {
        TakeGoldFromCreature(5, oPC, TRUE);
        ActionSpeakString("Ah!   I see, I see!  I predict you... will be angry...  veeery angry...  When you find out that was scam!  Hah!   Got ya!  I'm great at this fortune telling, ain't I?", TALKVOLUME_WHISPER);
        SetPCKEYValue(oPC, "bc_fortune", 2);
        return;
    }
    if(GetTag(OBJECT_SELF) == "bc_npc_fortune" && GetPCKEYValue(oPC, "bc_fortune") == 2)
    {
        ActionSpeakString("No refunds!", TALKVOLUME_WHISPER);
        return;
    }

//  Anubis speech and recognition checks.

    if(GetTag(OBJECT_SELF) == "bc_npc_anubis" && GetLocalInt(oPC, "bc_anubis") == 0)
    {
        ActionSpeakString("On play nights, it's 25 gold to attend.  Or, you may donate if you like. [Speak to him again to pay.]", TALKVOLUME_WHISPER);
        SetLocalInt(oPC, "bc_anubis", 1);
        return;
    }
    if(GetTag(OBJECT_SELF) == "bc_npc_anubis" && GetLocalInt(oPC, "bc_anubis") == 1)
    {
        TakeGoldFromCreature(25, oPC, TRUE);
        ActionSpeakString("Thank you for supporting the fine arts.", TALKVOLUME_WHISPER);
        ActionPlayAnimation(ANIMATION_FIREFORGET_BOW, 1.0);
        SetLocalInt(oPC, "bc_anubis", 2);
        return;
    }


//  Trumpeteer speech.

    if(GetTag(OBJECT_SELF) == "bc_npc_trumpeteer")
    {
        int iChatter = d3();

        switch(iChatter)
        {
        case 1:
        ActionSpeakString("* Inhales, holds her breath for a full minute, and exhales deeply. *  Please, I'm practicing my technique!", TALKVOLUME_WHISPER);
        break;

        case 2:
        ActionSpeakString("Oh, how to introduce myself...?  I know! 'Flutes, trumpets and winded instruments of tone, I am the mistress of all things blown!'", TALKVOLUME_WHISPER);
        break;

        case 3:
        ActionSpeakString("Ahhh... the sweet sound of the trumpet...", TALKVOLUME_WHISPER);
        break;
        }
    }

//  Luis the armoire.

    oPC = GetLastUsedBy();

    if(GetTag(OBJECT_SELF) == "bc_npc_luis" && GetPCKEYValue(oPC, "bc_luis") == 0 && GetLevelByClass(CLASS_TYPE_BARD, oPC) > 15)
    {
        BeginConversation("bc_npc_luis", oPC);
        SetPCKEYValue(oPC, "bc_luis", 1);
        return;
    }

    if(GetTag(OBJECT_SELF) == "bc_npc_luis" && GetPCKEYValue(oPC, "bc_luis") == 2)
    {
        ActionSpeakString("*Sighs*  Can you not see I am *busy*?  Leave me be!", TALKVOLUME_WHISPER);
        return;
    }

    oPC = GetPCSpeaker();

    if(GetTag(OBJECT_SELF) == "bc_npc_luis" && GetPCKEYValue(oPC, "bc_luis") == 1)
    {
        CreateItemOnObject("bc_item_gfriend", oPC);
        SetPCKEYValue(oPC, "bc_luis", 2);
        return;
    }
}
