#include "nwnx_creature"



void ArenaSummon(string sSelectedCreature, object oSummonPoint);


//Check the starting conditions for this conversation
int StartingConditional()
{
    object oSummonPoint = GetObjectByTag("lj_arena_wp");


    string sParameter = GetScriptParam("Creature Set");
    if(sParameter != "")
    {
        if(GetLocalString(oSummonPoint, "summon") != "") { return TRUE; } //Creature already set
        else { return FALSE; }
    }
    //sParameter = GetScriptParam("Creature Alive");
    if(sParameter != "")
    {
        if(GetNearestObjectByTag("lj_Arena_Summon") != OBJECT_INVALID) { return TRUE; } //Creature still alive
        else { return FALSE; }
    }

    // Don't show the node; conditions weren't found
    return FALSE;
}

//Main script on "Actions Taken"
void main()
{
    object oSummonPoint = GetObjectByTag("lj_arena_wp");

    if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE)
    {
        object oPC = GetLastUsedBy();
        SendMessageToPC(oPC, "DEBUG: Lever Used");
        string sSelectedCreature = GetLocalString(oSummonPoint, "summon");

        if(GetNearestObjectByTag("lj_Arena_Summon") != OBJECT_INVALID)
        {
            SendMessageToPC(oPC, "DEBUG: Creature is still alive!");
            DestroyObject(GetNearestObjectByTag( "lj_Arena_Summon", OBJECT_SELF));
            /*
            //Count the number of valid creatures and stop
            int nCount;
            while(GetNearestObjectByTag( "lj_Arena_Summon", OBJECT_SELF, nCount) != OBJECT_INVALID)
            {
                SendMessageToPC(oPC, "DEBUG: Creature found.");
                nCount++;
            }
            SendMessageToPC(oPC, "DEBUG: Creatures Found =" + IntToString(nCount));
            while(GetNearestObjectByTag( "lj_Arena_Summon", OBJECT_SELF, nCount) != OBJECT_INVALID)
            {

                DestroyObject(GetNearestObjectByTag( "lj_Arena_Summon", OBJECT_SELF, nCount));
                nCount--;
            }    */

        }
        else if(sSelectedCreature == "")
        {
            SendMessageToPC(oPC, "No monster set. Speak to the beastmaster to ready a creature.");
        }
        else
        {
            SendMessageToPC(oPC, "DEBUG: Summon found - " + sSelectedCreature);
            ActionPlayAnimation (ANIMATION_PLACEABLE_ACTIVATE);
            ArenaSummon(sSelectedCreature, oSummonPoint);
            DeleteLocalString(oSummonPoint, "summon");
            DelayCommand(1.0, ActionPlayAnimation (ANIMATION_PLACEABLE_DEACTIVATE));
        }


    }
    else
    {
        object oPC = GetLastSpeaker(); // Get the player character who initiated the conversation
        object oBeastmaster = OBJECT_SELF; // Assuming the script is attached to the beastmaster NPC
        string sSelectedCreature = GetScriptParam("Creature Resref"); // Initialize the selected creature

        SetLocalString(oSummonPoint, "summon", sSelectedCreature);

    }

}

void ArenaSummon(string sSelectedCreature, object oSummonPoint)
{
    // do the summon
    location lSummonLocation = GetLocation(oSummonPoint);
    object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSelectedCreature, lSummonLocation);
    SetEventScript(oCreature, EVENT_SCRIPT_CREATURE_ON_DEATH, "");
    SetTag(oCreature, "lj_Arena_Summon");
    SetLocalInt(oCreature, "Arena Summon", 1);
    //effect eSummon = EffectSummonCreature(sSelectedCreature, VFX_FNF_DISPEL, 0.5, 1);


    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, GetObjectByTag("lj_arena_beastmaster"), 60.00);
    //object oCreature = GetObjectByTag(sSelectedCreature);
    //NWNX_Creature_SetFaction (oCreature, STANDARD_FACTION_HOSTILE);
    //AssignCommand(oCreature, ActionJumpToLocation(lSummonLocation));
    //SendMessageToPC(GetPCSpeaker(), "Summoned " + GetName(oCreature) + ".");
    //visual effects
    effect eOrbEffect = EffectVisualEffect(VFX_FNF_DISPEL);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eOrbEffect, lSummonLocation, 0.5);

    location lCreatureLocation = GetLocation(oCreature);
    effect eCreatureEffect = EffectVisualEffect(VFX_FNF_SMOKE_PUFF);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eCreatureEffect, lCreatureLocation, 1.0);
}

/*
// Clears all the ds_action and ds_check variables
void DS_CLEAR_ALL(object oPC);

// Clears all the ds_check variables
void DS_CLEAR_CHECK(object oPC);

void ArenaSummon(string sSelectedCreature, object oSummonPoint);

// Launches the Convo Function
void LaunchConvo( object oNPC, object oPC);

void main()
{
    if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE)
    {
        object oPC = GetLastUsedBy();
        SendMessageToPC(oPC, "DEBUG: Lever Used");
        object oSummonPoint = GetObjectByTag("lj_arena_wp");
        string sSelectedCreature = GetLocalString(oSummonPoint, "summon");

        if(sSelectedCreature == "")
        {
            SendMessageToPC(oPC, "No monster set. Speak to the beastmaster to ready a creature.");
        }
        else
        {
            SendMessageToPC(oPC, "DEBUG: Summon found - " + sSelectedCreature);
            ActionPlayAnimation (ANIMATION_PLACEABLE_ACTIVATE);
            ArenaSummon(sSelectedCreature, oSummonPoint);
            DeleteLocalString(oSummonPoint, "summon");
            DelayCommand(1.0, ActionPlayAnimation (ANIMATION_PLACEABLE_DEACTIVATE));
        }


    }
    else
    {
        object oPC = GetLastSpeaker(); // Get the player character who initiated the conversation
        object oBeastmaster = OBJECT_SELF; // Assuming the script is attached to the beastmaster NPC
        object oSummonPoint = GetObjectByTag("lj_arena_wp");
        string sSelectedCreature = ""; // Initialize the selected creature
        int nNode           = GetLocalInt( oPC, "ds_node" );
        string sAction      = GetLocalString( oPC, "ds_action");

        // Checks to see if the script has run once, if it did not it runs though the convo file
        if(sAction != "arena_summon")
        {
            SendMessageToPC(oPC, "DEBUG: First fire");
            DeleteLocalInt( oPC, "ds_node");
            DeleteLocalString( oPC, "ds_action");
            LaunchConvo(oBeastmaster,oPC);
        }
        else if(nNode > 0)
        {

            //if( 99 >= nNode >= 1)
            //{
                // Since the script is going to be launched a second time and moved from the NPC to the PC you need to make sure the NPC is set
                // properly on the second run.
                oBeastmaster = GetNearestObjectByTag("lj_arena_beastmaster",oPC);
                SendMessageToPC(oPC, "DEBUG: Nodes found = "+ IntToString(nNode));
                // Depending on the player's selection, set the appropriate creature
                switch (nNode)
                {
                    case 1:
                        sSelectedCreature = "nw_wolf";
                        SendMessageToPC(oPC, "DEBUG: Summon set - " + sSelectedCreature);
                        break;
                    case 2:
                        sSelectedCreature = "nw_goblina";
                        SendMessageToPC(oPC, "DEBUG: Summon set - " + sSelectedCreature);
                        break;
                    case 3:
                        sSelectedCreature = "brog_figiant_006";
                        SendMessageToPC(oPC, "DEBUG: Summon set - " + sSelectedCreature);
                        break;
                    // Add more cases for additional creature options as needed
                    default:
                    // Handle default case or invalid selection
                    break;
                }

                // Store the selected creature in a local variable on the summoning waypoint
                SetLocalString(oSummonPoint, "summon", sSelectedCreature);

                DeleteLocalInt( oPC, "ds_node");
                DeleteLocalString( oPC, "ds_action");
                return;
            //}
        }
        else if(nNode == 0) // If the ds_action variable is set, but a choice wasn't made this will refire the convo script so they can make a choice
        {
            SendMessageToPC(oPC, "DEBUG: Need to refire script.");
            DeleteLocalInt( oPC, "ds_node");
            DeleteLocalString( oPC, "ds_action");
            LaunchConvo(oBeastmaster, oPC);
        }

    DS_CLEAR_ALL(oPC);
    DS_CLEAR_CHECK(oPC);
    }

}

void LaunchConvo( object oNPC, object oPC)
{
    SendMessageToPC(oPC, "DEBUG: Launching conversation");
    SetLocalString(oPC,"ds_action","arena_summon");
    AssignCommand(oNPC, ActionStartConversation(oPC, "lj_arena_summon", TRUE, FALSE));
}


// Trigger script to summon the selected creature when the player enters the trigger
void ArenaSummon(string sSelectedCreature, object oSummonPoint)
{
    // do the summon
    object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSelectedCreature, GetLocation(oSummonPoint));
    //effect eSummon = EffectSummonCreature(sSelectedCreature, VFX_FNF_DISPEL, 0.5, 1);
    location lSummonLocation = GetLocation(oSummonPoint);

    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, GetObjectByTag("lj_arena_beastmaster"), 60.00);
    //object oCreature = GetObjectByTag(sSelectedCreature);
    //NWNX_Creature_SetFaction (oCreature, STANDARD_FACTION_HOSTILE);
    //AssignCommand(oCreature, ActionJumpToLocation(lSummonLocation));
    //SendMessageToPC(GetPCSpeaker(), "Summoned " + GetName(oCreature) + ".");
    //visual effects
    effect eOrbEffect = EffectVisualEffect(VFX_FNF_DISPEL);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eOrbEffect, lSummonLocation, 0.5);

    location lCreatureLocation = GetLocation(oCreature);
    effect eCreatureEffect = EffectVisualEffect(VFX_FNF_SMOKE_PUFF);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eCreatureEffect, lCreatureLocation, 1.0);
}

void DS_CLEAR_ALL(object oPC)
{
   SetLocalInt( oPC, "ds_node", 0 );
   SetLocalString( oPC, "ds_action", "" );
   SetLocalInt( oPC, "ds_actionnode", 0 );
   SetLocalInt( oPC, "ds_check_1", 0 );
   SetLocalInt( oPC, "ds_check_2", 0 );
   SetLocalInt( oPC, "ds_check_3", 0 );
   SetLocalInt( oPC, "ds_check_4", 0 );
}

void DS_CLEAR_CHECK(object oPC)
{
   SetLocalInt( oPC, "ds_check_1", 0 );
   SetLocalInt( oPC, "ds_check_2", 0 );
   SetLocalInt( oPC, "ds_check_3", 0 );
   SetLocalInt( oPC, "ds_check_4", 0 );
}
*/
