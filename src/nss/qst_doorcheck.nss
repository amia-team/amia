// Lord-Jyssev - Quest Check script for OnFailToOpen or OnAreaTransitionClick
//
// This script checks for a variable on the door or transition trigger
// to ensure that the player has completed/started/not started a quest
// to be able to open or transition through.
//
// Variable options:
// string QuestStarted      = This quest must be started before access
// string QuestFinished     = This quest must be finished before access
// string QuestNotStarted   = Access is barred if this quest is started or finished

void main()
{
    object oPC = GetClickingObject();
    string sQuestStarted    = GetLocalString( OBJECT_SELF, "queststarted");
    string sQuestFinished   = GetLocalString( OBJECT_SELF, "questfinished");
    string sQuestNotStarted = GetLocalString( OBJECT_SELF, "questnotstarted");

    if( sQuestStarted != "") //Check to see if the quest fields are set
    {
        object oPCKey = GetItemPossessedBy(oPC,"ds_pckey");
        int nQuestStarted  = GetLocalInt(oPCKey,sQuestStarted);
        if( nQuestStarted < 1)
        {
            SendMessageToPC( oPC, "You must have started the <c Í >" + sQuestStarted + "</c> quest to use this.");
            return;
        }
    }
    else if( sQuestFinished != "") //Check to see if the quest fields are set
    {
        object oPCKey = GetItemPossessedBy(oPC,"ds_pckey");
        int nQuestFinished = GetLocalInt(oPCKey,sQuestFinished);
        if (nQuestFinished != 2)
        {
            SendMessageToPC( oPC, "You must have completed the <c Í >" + sQuestFinished + "</c> quest to use this.");
            return;
        }
    }
    else if( sQuestNotStarted != "") //Check to see if the quest fields are set
    {
        object oPCKey = GetItemPossessedBy(oPC,"ds_pckey");
        int nQuestNotStarted = GetLocalInt(oPCKey,sQuestNotStarted);
        if (nQuestNotStarted != 0)
        {
            SendMessageToPC( oPC, "You may no longer use this after starting the <c Í >" + sQuestNotStarted + "</c> quest.");
            return;
        }
    }

    // Logic to determine if this is set on a door or not
    if ( GetEventScript(OBJECT_SELF, EVENT_SCRIPT_DOOR_ON_FAIL_TO_OPEN ) == "qst_doorcheck") // Door
    {
        SetLocked( OBJECT_SELF, FALSE );
        PlayAnimation(  ANIMATION_DOOR_OPEN1 );
        DelayCommand( 12.0, PlayAnimation(  ANIMATION_DOOR_CLOSE ) );
        DelayCommand( 13.0, SetLocked( OBJECT_SELF, TRUE ) );
    }
    else // Not Door
    {
        ExecuteScript("nw_g0_transition");
    }



}
