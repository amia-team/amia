// Quest satchel for use in "Courier for A Day" quest in Cordor
#include "x2_inc_switches"
#include "inc_ds_qst"

void main()
{
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ACTIVATE:
        {
            // vars
            object oTarget = GetItemActivatedTarget();
            object oBag = GetItemActivated();
            object oPC = GetItemActivator();
            string sTag = GetTag( oTarget );
            int nQStatus = GetLocalInt( oBag, "QStatus" );

            //check if used on valid quest NPC
            if( sTag == "Haur" && GetLocalInt( oBag, "Haur" ) == 0 )
            {
                SetLocalInt( oBag, "Haur", 1 );
                nQStatus = nQStatus + 1;
                SetLocalInt( oBag, "QStatus", nQStatus );
                AssignCommand( oTarget, ActionSpeakString( "An adventurin' type bringin' me order forms? Bless ye. 'ere then, too many o' ye types don't think o' bringin' any light with ye, daft lot that ye are. This 'ere's one o' mine, heftier than yer usual twig'o'a'torch. *Haur hands you a club with a wad of rags wrapped around the end*" ) );
                CreateItemOnObject( "qst_adventorch", oPC );
                GiveXPToCreature( oPC, 250 );
            }
            else if( sTag == "ArmuthFletcher" && GetLocalInt( oBag, "Fletcher" ) == 0 )
            {
                SetLocalInt( oBag, "Fletcher", 1 );
                nQStatus = nQStatus + 1;
                SetLocalInt( oBag, "QStatus", nQStatus );
                AssignCommand( oTarget, ActionSpeakString( "Hello there! Oh, you have those feathers for my arrows. You know most people think fighting off monsters is all up close and personal, but keeping your distance is safer. Here. *the Fletcher places a simple Sling and some stones in your hand*" ) );
                CreateItemOnObject( "nw_wbwsl001", oPC );
                CreateItemOnObject( "nw_wammbu008", oPC, 50 );
                GiveXPToCreature( oPC, 250 );
            }
            else if( sTag == "X3_CALADNEI" && GetLocalInt( oBag, "Guston" ) == 0 )
            {
                SetLocalInt( oBag, "Guston", 1 );
                nQStatus = nQStatus + 1;
                SetLocalInt( oBag, "QStatus", nQStatus );
                AssignCommand( oTarget, ActionSpeakString( "Don't believe I've seen you around before, new to the region are you? Thank you for the bundle of rope, you can have this old coil here, never know when it might come in handy. *the Captain hands you a coil of rope*" ) );
                AssignCommand( oTarget, ActionSpeakString( "Oh and come speak to me again once your deliveries are done. I have a bit of work for you as well, if you're interested." ) );
                CreateItemOnObject( "rope", oPC );
                GiveXPToCreature( oPC, 250 );
            }
            else if( sTag == "TheMapKeeper" && GetLocalInt( oBag, "Mapper" ) == 0 )
            {
                SetLocalInt( oBag, "Mapper", 1 );
                nQStatus = nQStatus + 1;
                SetLocalInt( oBag, "QStatus", nQStatus );
                AssignCommand( oTarget, ActionSpeakString( "Oh! More ink! I just love working with ink! Oh but the last delivery was wrong, they brought me Alchemist's Fire and I nearly burned down my precious map! Here, I can't bare to keep it around. *the Map Keeper hands you a jar of Alchemist's Fire*" ) );
                CreateItemOnObject( "x1_wmgrenade002", oPC );
                GiveXPToCreature( oPC, 250 );
            }
            else if( sTag == "Haulfest" && GetLocalInt( oBag, "Tristana" ) == 0 )
            {
                SetLocalInt( oBag, "Tristana", 1 );
                nQStatus = nQStatus + 1;
                SetLocalInt( oBag, "QStatus", nQStatus );
                AssignCommand( oTarget, ActionSpeakString( "Another who has come to make their fortune here, are you? Thank you for bringing these documents to me. Please, allow me to pay you with something to keep you whole and healthy in your travels. *Tristana gifts you with some basic healing supplies*" ) );
                CreateItemOnObject( "it_medkit002", oPC, 10 );
                GiveXPToCreature( oPC, 250 );
            }
            else if( sTag == "AxisStoreClerk" && GetLocalInt( oBag, "Hilrash" ) == 0 )
            {
                SetLocalInt( oBag, "Hilrash", 1 );
                nQStatus = nQStatus + 1;
                SetLocalInt( oBag, "QStatus", nQStatus );
                AssignCommand( oTarget, ActionSpeakString( "My case of potion substrate, wonderful. Here, you strike me as the sort that will find a need for this, sometime when you're in a tricky situation. *Hil'rash takes a magical potion bottle out of his store and gives it to you*" ) );
                CreateItemOnObject( "custompotion", oPC );
                GiveXPToCreature( oPC, 250 );
            }
            else if( sTag == "sewer_cleaner" && GetLocalInt( oBag, "Cleaner" ) == 0 )
            {
                SetLocalInt( oBag, "Cleaner", 1 );
                nQStatus = nQStatus + 1;
                SetLocalInt( oBag, "QStatus", nQStatus );
                AssignCommand( oTarget, ActionSpeakString( "Oh aye, the new mop 'eads we ordered a month ago, jus' grand! 'ere ye go, found this down in tunnel five t'other day. *the foreman gives you a single vial of magical liquid*" ) );
                AssignCommand( oTarget, ActionSpeakString( "Say, I might just 'ave somethin' else up yer alley too, little problem we've got down 'ere. Come by again when ye've done yer deliveries, aye?" ) );
                CreateItemOnObject( "ds_single_anti", oPC, 5 );
                GiveXPToCreature( oPC, 250 );
            }
            else
            {
                SendMessageToPC( oPC, "**this is not one of the people you have a delivery for**" );
            }

            //check overall status of deliveries
            if( nQStatus == 7 )
            {
                if ( ds_quest( oPC, "ds_quest_37" ) == 2 )
                {
                    ds_quest( oPC, "ds_quest_37", 3 );
                }
            }
        }
        default:
        {
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
