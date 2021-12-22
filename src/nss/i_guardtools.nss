//-----------------------------------------------------------------------------
// Cordorian Guard Tools (Item Activation Scripts)
//-----------------------------------------------------------------------------
//script:  i_guardtools
//description: script series for the cordor guard tools/widgets
//used as: item activation script
//date:    june 5 2009
//author:  brainsplitter


//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "inc_ds_ondeath"
         // has the GetCreatureType function by disco


//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

// Guard Fine; Will remove 10% of Target's Gold or 1,000 GP / Target Level (lowest)
void GuardFine(object oTarget, object oSelf);

// Guard Ban; Makes undroppable item on target for Cordor Ban. Boots from Cordor.
void GuardBan(object oTarget, object oSelf);

// Guard Desummoner; Kills target's hencmen. Alternatively; kills target henchman.
void GuardDesummoner(object oTarget, object oSelf);

// Guard Jail Port; Ports target to jail inside sell. Ports user to jail outside cell.
void GuardJailPort(object oTarget, object oSelf);

// Henchman Kill; Applys VFX & kills target. For organization of script.
void HenchmanKill(object oTarget);


//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main(){

    // define base variables
    object oTarget = GetItemActivatedTarget();
    object oSelf   = GetItemActivator();
    object oTool   = GetItemActivated();
    object oArea   = GetArea(oSelf);
    string sToolRR = GetResRef(oTool);

    // determine if area is Cordor area. If yes; continue.
    if (GetStringLeft(GetName(oArea), 8) == "Cordor: "){

        // check resref of tool. determine appropriate function via resref.
        if(sToolRR == "bs_guardfine"){

            GuardFine(oTarget,oSelf);
            SendMessageToPC(oSelf,"DEBUG: Guard Fine function activated");

        }
        else if(sToolRR == "bs_guardban"){

            GuardBan(oTarget,oSelf);
            SendMessageToPC(oSelf,"DEBUG: Guard Ban function activated");

        }
        else if(sToolRR == "bs_guarddesummon"){
            SendMessageToPC(oSelf,"DEBUG: Guard Desummon function activated");

            GuardDesummoner(oTarget,oSelf);
        }
        else if(sToolRR == "bs_guardjailport"){
            SendMessageToPC(oSelf,"DEBUG: Guard Jail Port function activated");

            GuardJailPort(oTarget,oSelf);

        }
    }

    else{

        // inform player that item must be used in Cordor area.
        SendMessageToPC(oSelf,"You may only use Guard Tools in Cordorian areas");

    }
}


//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------

void GuardFine(object oTarget, object oSelf){

    int nFineByPercentage = GetGold(oTarget) / 10;
    int nFineByLevel = GetHitDice(oTarget) * 1000;

    if (nFineByPercentage < nFineByLevel){

        // If 10% of gold is less than levelx1000; take 10% of gold.
        TakeGoldFromCreature(nFineByPercentage,oTarget,TRUE);
        SendMessageToPC(oSelf,"You have fined "
                              + GetName(oTarget)
                              + " "
                              + IntToString(nFineByPercentage)
                              + "gp.");
    }
    else{

        // else; take levelx1000 gold.
        TakeGoldFromCreature(nFineByLevel,oTarget,TRUE);
        SendMessageToPC(oSelf,"You have fined "
                              + GetName(oTarget)
                              + " "
                              + IntToString(nFineByLevel)
                              + "gp.");

    }

    //feedback & VFX
    SendMessageToPC(oSelf,"Ensure the current Chat+Combat/Server Log is screenshotted and posted for verification");

}


// Guard Ban
// Will add Undroppable 'Cordor Ban' object on target.
// Object is checked for presence by OnEnter; Boots target if possessed.
// Will also boot individual to appropriate area upon activation.
void GuardBan(object oTarget, object oSelf){

    effect eVFX = EffectVisualEffect(VFX_IMP_LIGHTNING_M);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oTarget);
    CreateItemOnObject("bs_cordorbannode",oTarget);
    AssignCommand(oTarget,ActionJumpToObject(GetWaypointByTag("wp_bs_guardboot")));
    SendMessageToPC(oTarget,"You have been banned from Cordor by Guard "
                            +GetName(oSelf)
                            +". Attempting to enter patrolled Cordor areas will result in being booted from the area");
    SendMessageToPC(oSelf,"You have banned " + GetName(oTarget) + " from Cordor");
    SendMessageToPC(oSelf,"Ensure the current Chat+Combat/Server Log is screenshotted and posted for verification");

}


// Guard Desummoner
// Will determine if target is PC. If Yes; Remove all Henchmen.
// If No; Will determine if creature is a Henchman. If yes; Kill It.
void GuardDesummoner(object oTarget, object oSelf){

effect eVFX = EffectVisualEffect(VFX_FNF_PWSTUN);
effect eKill= EffectDeath(FALSE,FALSE);
int    nTargType = GetCreatureType(oTarget);

    // switch/case based on result of disco's GetCreatureType script.
    switch(nTargType){

        // if summon (3), companion (4), henchman (5), familiar (6),
        // or poss.familiar; kill it w/ VFX
        case 3: case 4: case 5: case 6: case 7:
            HenchmanKill(oTarget);
            SendMessageToPC(oSelf,"Target henchman killed.");
        break;

        // if Player Character (8); kill all of his hencmen.
        case 8:
            HenchmanKill(GetAssociate(ASSOCIATE_TYPE_SUMMONED,oTarget));
            HenchmanKill(GetAssociate(ASSOCIATE_TYPE_DOMINATED,oTarget));
            HenchmanKill(GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oTarget));
            HenchmanKill(GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oTarget));
            HenchmanKill(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oTarget));
            SendMessageToPC(oSelf,"Henchmen of target killed.");
        break;

        default:
            SendMessageToPC(oSelf,"This is not a valid target for the Desummoner");
        break;
    }
}


// Guard Jail Port
// Will portal target to Cordorian Jail Cell
// Will portal user directly outside of Cell
void GuardJailPort(object oTarget, object oSelf){

    effect eVFX = EffectVisualEffect(VFX_IMP_PDK_HEROIC_SHIELD);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oSelf);
    AssignCommand(oTarget,ActionJumpToObject(GetWaypointByTag("wp_bs_innerjail")));
    AssignCommand(oSelf,ActionJumpToObject(GetWaypointByTag("wp_bs_outerjail")));

    // Give Feedback to Guard PC.
    SendMessageToPC(oSelf,"You have portal-jumped " + GetName(oTarget) + " to jail.");
    SendMessageToPC(oSelf,"Ensure the current Chat+Combat/Server Log is screenshotted and posted for verification");
}


// Henchman Kill
// Will kill target and apply visual effect.
// Exists for script organization/readability.
void HenchmanKill(object oTarget){

    effect eVFX = EffectVisualEffect(VFX_FNF_PWSTUN);
    effect eKill= EffectDeath(FALSE,FALSE);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eKill,oTarget);
}
