// Quest Lynx Blood or Sword Spider Leg for use in "Children of Webs" quest in Cape Slakh
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
            object oItem = GetItemActivated();
            object oPC = GetItemActivator();
            object oTrigger = GetObjectByTag( "slakhspidersacs" );
            string sResRef = GetResRef( oItem );
            object oQuestItem;

            //check if used in the proper location
            if( GetIsInsideTrigger( oPC, "slakhspidersacs" ) == TRUE )
            {
                //quest update, and fade to black for all nearby party members (cycle through)
                if ( ds_quest( oPC, "ds_quest_38" ) == 4 )
                {
                    if( sResRef == "qst_lynxblood" )
                    {
                        AssignCommand( oPC, SpeakString( "**proceeds to pour the lynx blood out over each of the egg sacs, which seems to excite the growing brood within**" ) );
                    }
                    else if( sResRef == "qst_swrdspdrleg" )
                    {
                        AssignCommand( oPC, SpeakString( "**goes from egg sac to egg sac, slitting them open with the sword spider leg, spilling ungrown hatchlings across the floor**" ) );
                    }

                    object oInTrigger = GetFirstInPersistentObject( oTrigger, OBJECT_TYPE_CREATURE );

                    while( GetIsObjectValid( oInTrigger ) )
                    {
                        if( GetIsPC( oInTrigger ) && ds_check_partymember( oPC, oInTrigger ) == TRUE )
                        {
                            FadeToBlack( oInTrigger );
                            SendMessageToPC( oInTrigger, "While wading through the webbing in the room to deal with the egg sacs, your foot bumps into something metalic..." );
                            CreateItemOnObject( "qst_antiqcorhelm", oInTrigger );
                            GiveXPToCreature( oInTrigger, 500 );
                            ds_quest( oInTrigger, "ds_quest_38", 5 );

                            oQuestItem = GetItemPossessedBy( oInTrigger, "qst_slakhitems" );
                            if ( GetIsObjectValid( oQuestItem ) )
                            {
                                DestroyObject( oQuestItem );
                            }

                            DelayCommand( 6.0, FadeFromBlack( oInTrigger ) );
                        }
                        oInTrigger = GetNextInPersistentObject( oTrigger, OBJECT_TYPE_CREATURE );
                    }
                }
            }
            else
            {
                if( sResRef == "qst_lynxblood" )
                {
                    SendMessageToPC( oPC, "You'd best save the blood you've collected, until you're in the same room as the egg sacs." );
                }
                else if( sResRef == "qst_swrdspdrleg" )
                {
                    SendMessageToPC( oPC, "The piece of Sword Spider leg you have isn't exactly lengthy, you'll have to be close to the egg sacs to use it." );
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
