//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_q42_lyrenotes
//group:   Plane of Shadow, In the Shadow of Shadesteel quest (q42)
//used as: item activation script
//date:    Mar 19, 2015
//author:  Anatida


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main()
{
   //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName(oItem);
            int nInTrigger = (GetIsInsideTrigger(oPC, "pos_q42_playlyre"));
            int nClass;
            int nSkillRank;
            effect eEffect = EffectVisualEffect(VFX_DUR_BARD_SONG, FALSE);


            if (GetLevelByClass(CLASS_TYPE_BARD, oPC) < 1)
            {
             //wrong CLASS
                SendMessageToPC( oPC, "You can not decipher the notes on the page." );
                return;
            }
            // Notes must be played on the Shadow Lyre
            if ( GetTag( oTarget ) != "pos_q42_lyre" )
            {
                //wrong target
                SendMessageToPC( oPC, "Perhaps the notes are meant for a certain instrument." );
                return;
            }
            // PC must be in the right location for the music to have an effect
            if (nInTrigger != 1)
            {
                //wrong location
                SendMessageToPC( oPC, "You play the notes on the Shadow Lyre, but nothing seems to happen." );
                return;
            }

            // We want real bards with some investment in perform. Look at base ranks only
            if (GetSkillRank(SKILL_PERFORM, oPC, TRUE) <15)
            {
             //Fail Skill Check
                SendMessageToPC( oPC, "Your performance is lacking; nothing happens." );
                return;
            }

            else
            {
            //Success! Msg PC and reveal secret transition
                SendMessageToPC( oPC, "You play the notes on the Shadow Lyre, and something seems to happen!" );
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0);

 //Set up a Nth loop to check progressively further triggers from the PC
                int nLoop = 1;
                object oTrigger =  GetNearestObject( OBJECT_TYPE_TRIGGER, oPC, nLoop );
                while (GetIsObjectValid(oTrigger) == TRUE)
                {
                    // if the right trigger is found, create the object and stop the loop
                    if (GetTag(oTrigger) ==  "pos_q42_playlyre")
                    {
                    object oPLC;
                    string sTarget      = GetLocalString( oTrigger, "target");
                    string sSpawnpoint  = GetLocalString( oTrigger, "spawnpoint");
                    string sResref      = GetLocalString( oTrigger, "resref" );

                    oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResref, GetLocation( GetWaypointByTag( sSpawnpoint ) ), FALSE, sTarget );
                    effect eHint = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR );
                    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eHint, GetLocation( oPLC ), 20.0 );
                    DestroyObject( oPLC, 20.0 );
                    return;
                    }
                 // if the correct trigger is not found, progress the loop by 1
                 nLoop = nLoop + 1;
                 oTrigger =  GetNearestObject( OBJECT_TYPE_TRIGGER, oPC, nLoop );
                }
            }

    }
}
