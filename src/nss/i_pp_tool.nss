//////////////////////////////////////////////////////////////////////////
// Pickpocket Replacement Package
// by James E. King, III (jking@prospeed.net) - MagnumMan
//////////////////////////////////////////////////////////////////////////
//
// ChangeLog
// YYYYMMDD WHO Notes
// -------- --- ----------------------------------------------------------
// 20050528 JEK Initial Release
// 20051222 kfw Added No-PvP Area check, and bug out
// 20071222 disco merged into three files
// 20071222 added ant-griefing measures
// 20150402 M.A'D. Fixed PP not using PPer's Feats/Items

//////////////////////////////////////////////////////////////////////////

#include "pp_utils"
#include "x2_inc_switches"
#include "x0_i0_position"
#include "cs_inc_xp"

// Process a successful pickpocket attempt
//
void Pickpocket(object oPC, object oTarget, int iBeatRollBy){

    int iDebugDie       = GetLocalInt   (oPC, PP_D100_FIX_VARNAME);
    int iPickRoll       = iDebugDie ? iDebugDie : d100();
    int iPickLowerBound = 50;
    int iPickUpperBound = 55 + (iBeatRollBy / 5);

    PP_Debug("Pickpocket", GetName(oPC) + " beat DC by " + IntToString(iBeatRollBy) + " for a pick item percentage bonus of " + IntToString(iBeatRollBy / 5) + "%");
    PP_Debug("Pickpocket", GetName(oPC) + " must roll [50.." + IntToString(iPickUpperBound) + "] to get an item");
    PP_Debug("Pickpocket", GetName(oPC) + " rolls a " + IntToString(iPickRoll));

    if (iPickRoll >= iPickLowerBound && iPickRoll < iPickUpperBound) {

        int iValidItems = PP_CountValidItems(oTarget);

        if (!iValidItems) {

            PP_Debug("Pickpocket", GetName(oTarget) + " has no valid objects to pickpocket; reverting to gold");
            SendMessageToPC(oPC, "You find nothing in their pack that can be lifted safely, trying their gold pouch...");
        }
        else {

            int iDebugPickItemNo = GetLocalInt(oPC, PP_PIN_FIX_VARNAME);
            int iPickItemNo = iDebugPickItemNo ? iDebugPickItemNo : (Random(iValidItems) + 1);

            object oPick = PP_PickItem(oTarget, iPickItemNo);

            if (!GetIsObjectValid(oPick)) {

                SendMessageToPC(oPC, "Pickpocket item attempt internal failure; could not pick an item");
                //PP_Log("Pickpocket", "Pickpocket item attempt internal failure; could not pick an item");
                return;
            }

            int iStackSize = GetItemStackSize(oPick);

            if (iStackSize > 1) {

                SetItemStackSize(oPick, iStackSize - 1);                // target loses one
                CreateItemOnObject(GetResRef(oPick), oPC);              // picker gains one
            }
            else {

                AssignCommand(oPC, ActionTakeItem(oPick, oTarget));     // item transfer
            }

            PP_Log("Pickpocket", GetName(oPC) + " pickpocketed '" + GetName(oPick) + "' from " + GetName(oTarget));
            return;
        }
    }

    int iGold  = iBeatRollBy * PP_HighestClassLevel(oPC);
    int iLimit = FloatToInt(IntToFloat(GetGold(oTarget)) * 0.05f);

    if (iGold > iLimit)
        iGold = iLimit;

    PP_Debug("Pickpocket", "iGold = " + IntToString(iGold) + "; iLimit = " + IntToString(iLimit));
    PP_Log  ("Pickpocket", GetName(oPC) + " pickpocketed " + IntToString(iGold) + " gp from " + GetName(oTarget));

    int iXP   = FloatToInt(IntToFloat(iGold) * 0.05f);

    if (!iGold) {

        SendMessageToPC(oPC, GetName(oTarget) + " has an empty coin bag.");
        iXP = 10;   // you get 10 xp for your trouble
    }
    else {

        AssignCommand(oPC, TakeGoldFromCreature(iGold, oTarget));
    }

    //PP_Log  ("Pickpocket", GetName(oPC) + " earned " + IntToString(iXP) + "xp");
    GiveCorrectedXP(oPC, iXP, "Job" );

    return;
}

// Processes a Pickpocket Request
//
void PP_Activate()
{
    object oPC        = GetItemActivator();
    object oArea      = GetArea(oPC);

    // No-PvP Area check
    if(GetLocalInt(
        oArea,
        "CS_MAP_NO_PP")==1){

        // Notify the PC
        FloatingTextStringOnCreature(
            "- You may not use the Pickpocket Tool in this area. -",
            oPC,
            FALSE);

        // Bug out
        return;

    }

    object oTarget    = GetItemActivatedTarget();
    // Edit - 4/2/15 by M.A'D.
    // Was set to TRUE, Changed to FALSE so it reports in-game skill, not just ranks
    // But this has the -50 on it, so add that afterwards
    int    iPickSkill = GetSkillRank( SKILL_PICK_POCKET, oPC, FALSE );
    //int    nDexMod    = GetAbilityModifier( ABILITY_DEXTERITY, oPC );
    //iPickSkill       += nDexMod;

    // add the amount that the supernatural detriment removes
    // Edit - 4/2/15 by M.A'D. PP_SKILL_DIFFERENCE is declared in
    // a segment of code that has been encapsulated elsewhere
    // Changing PP_SKILL_DIFFERENCE to 50 to counter the IG Disabling
    iPickSkill += 50;

    // If you have no classes that can pickpocket then the character probably
    // relevelled and dropped their pickpocket class, so we need to do some cleanup
    /*if (!PP_HighestClassLevel(oPC)) {
        SendMessageToPC(oPC, "You have no pickpocketing abilities whatsoever.");
        PP_AdjustPC(oPC);
        return;
    }*/

    // You must be trained to pickpocket
    /*if (!GetHasSkill(SKILL_PICK_POCKET, oPC)) {
        FloatingTextStringOnCreature("You are not trained in the art of pickpocketing.", oPC, FALSE);
        return;
    }*/

    // You can only pick PCs (NPCs are not always set up with gold and items to pick)
    if (!PP_ALLOW_VS_NPC && !GetIsPC(oTarget)) {

        FloatingTextStringOnCreature("You can only pickpocket from other PCs.", oPC, FALSE);
        return;
    }

    if ( GetIsDM( oTarget ) ) {

        FloatingTextStringOnCreature("It would be unwise to pickpocket a DM, the least of all reasons being they can smite you just by thinking about it.", oPC, FALSE);
        return;
    }

    // You cannot pick your own pockets.
    if (oPC == oTarget) {

        SendMessageToPC(oPC, "You cannot pick your own pockets... well, you can, but people might look at you funny, and you'll always get what you take from yourself unless you have a critical failure and drop everything you own on the ground, falling haphazardly while attempting to gather it all up and gouging your eye out on a sharp dagger,");
        SendMessageToPC(oPC, "and then people will look at you funny even more - if you live to tell them about it, that is, but you might suffer a stroke just thinking about your incompetence and then one side of your face will be numb all the time, and nobody will take you seriously when you tell them you did this all to yourself.  No, perhaps we won't be letting you pick your own pockets.  It's for your own good, honest.");
        return;
    }

    // You must be within PP_MIN_DISTANCE meters to pickpocket
    if ( GetDistanceBetween(oPC, oTarget) > PP_MIN_DISTANCE ) {

        FloatingTextStringOnCreature("You are too far away.", oPC, FALSE);
        return;
    }

    // You cannot pick anyone under level PP_LOWEST_LEVEL
    if (GetHitDice(oTarget) < PP_LOWEST_LEVEL) {

        FloatingTextStringOnCreature("Target is below level " + IntToString(PP_LOWEST_LEVEL) + " - not allowed.", oPC, FALSE);
        return;
    }

    //anti griefing measure
    if ( oTarget == GetLocalObject( oPC, "pp_last_victim" ) ) {

        FloatingTextStringOnCreature("You can't pickpocket the same character twice in a row.", oPC, FALSE);
        return;
    }
    else{

        SetLocalObject( oPC, "pp_last_victim", oTarget );
    }

    ///////////////////////////////////////////////////////////////////////////
    // Prerequisites passed, here we do the actual attempt.
    ///////////////////////////////////////////////////////////////////////////

    int iTargetSpot = GetSkillRank(SKILL_SPOT, oTarget);
    if (iTargetSpot < 0)    // If untrained in spot, treat like 0
        iTargetSpot = 0;

    int iTargetDC   = 20 + (GetHitDice(oTarget) / 2) + (iTargetSpot / 2);

    // Dead man's DC is 0
    if (GetIsDead(oTarget))
        iTargetDC   = 0;

    // All party members or NPCs in certian radiuses give a DC bonus;
    int iProxBonus  = 0;
    location lTarget = GetLocation(oTarget);
    object oObj = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, lTarget, TRUE);

    while (GetIsObjectValid(oObj)) {

        if (GetIsPC(oObj)) {

            if (oObj == oTarget || oObj == oPC) {

                oObj = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, lTarget, TRUE);
                continue;
            }

            if (InPartyTogether(oTarget, oObj))
                iProxBonus += PP_DistanceDCBonus(oTarget, oObj);
        } else {

            if (GetIsEnemy(oTarget, oObj)) {

                oObj = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, lTarget, TRUE);
                continue;
            }

            iProxBonus += PP_DistanceDCBonus(oTarget, oObj);
        }

        oObj = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, lTarget, TRUE);
    }

    iTargetDC += iProxBonus;

    PP_Debug("PP_Activate", "iProxBonus  = " + IntToString(iProxBonus ));
    PP_Debug("PP_Activate", "iTargetSpot = " + IntToString(iTargetSpot));
    PP_Debug("PP_Activate", "iTargetDC   = " + IntToString(iTargetDC  ));

    ///////////////////////////////////////////////////////////////////////////

    int iDebugDie     = GetLocalInt(oPC, PP_D20_FIX_VARNAME);
    int iDie          = iDebugDie ? iDebugDie : d20();

    // Apply successive pick decay algorithm
    int iLastPickDay  = GetLocalInt(oTarget, "PP_" + GetName(oPC) + "_Day");
    int iDecay        = GetLocalInt(oTarget, "PP_" + GetName(oPC) + "_Decay");
    int iCurDay       = GetCalendarDay();
    if (iCurDay < iLastPickDay)
        iCurDay += 28;

    if (iLastPickDay == 0 || iCurDay - iLastPickDay >= 2)
        iDecay        = 0;

    int iRoll         = iPickSkill + iDie - iDecay;

    PP_Debug("PP_Activate", "iPickSkill   = " + IntToString(iPickSkill  ));
    PP_Debug("PP_Activate", "iDie         = " + IntToString(iDie        ));
    PP_Debug("PP_Activate", "iLastPickDay = " + IntToString(iLastPickDay));
    PP_Debug("PP_Activate", "iCurDay      = " + IntToString(iCurDay     ));
    PP_Debug("PP_Activate", "iDecay       = " + IntToString(iDecay      ));
    PP_Debug("PP_Activate", "iRoll        = " + IntToString(iRoll       ));

    // Adjust the decay for the next attempt
    if (iDecay == 0) iDecay = 4;
    else             iDecay *= 2;
    SetLocalInt(oTarget, "PP_" + GetName(oPC) + "_Day", GetCalendarDay());
    SetLocalInt(oTarget, "PP_" + GetName(oPC) + "_Decay", iDecay);
    PP_Debug("PP_Activate", "iDecay(next) = " + IntToString(iDecay      ));

    int bCritFail     = (iDie == 1 );
    int bCritSucc     = (iDie == 20);
    int bSuccess      = (bCritSucc || (iRoll > iTargetDC)) && !bCritFail;

    int iBeatRollBy = iRoll - iTargetDC;
    if (iBeatRollBy < 1)
        iBeatRollBy = 1;

    int iLostRollBy = iTargetDC - iRoll;
    if (iLostRollBy < 0)
        iLostRollBy = 0;

    PP_Debug("PP_Activate", "iBeatRollBy = " + IntToString(iBeatRollBy));
    PP_Debug("PP_Activate", "iLostRollBy = " + IntToString(iLostRollBy));

    // ex: Valdor Dormanigon (MagnumMan) SUCCESS vs. Feonir (Feonir): Pickpocket(1) + Roll(20) = 21 vs. DC(20) + Level(30) + HalfSpot(102) = 101

    string logString =
          GetName(oPC) + " (" + GetPCPlayerName(oPC) + ") "
        + (bSuccess ? "SUCCESS" : "FAIL")
        + " vs. "
        + GetName(oTarget) + " (" + GetPCPlayerName(oTarget) + "): Pickpocket ("
        + IntToString(iPickSkill) + ") + Roll(" + IntToString(iDie) + ") = " + IntToString(iRoll)
        + " vs. ";

    if (GetIsDead(oTarget))
        logString = logString + "DeadDC(0)";
    else
        logString = logString +
             "20 + Level(" + IntToString(GetHitDice(oTarget))
                 + ") + HalfSpot(" + IntToString(iTargetSpot) + ")";
    logString = logString + " + ProximityBonus(" + IntToString(iProxBonus) + ")";
    logString = logString + " = DC " + IntToString(iTargetDC);
    //PP_Log("Pickpocket", logString);

    if (!bSuccess) {

        SendMessageToAllDMs( GetName( oPC )+" failed to PP "+GetName( oTarget )+" in "+GetName( oArea )+"." );

        // Spotted if you critical fail, or if you lose the DC by more than 1/2 your pick skill
        if (bCritFail || iLostRollBy >= (iPickSkill / 2)) {

            // Spotted
            SendMessageToPC    (oTarget, "Pickpocket: " + GetName(oPC) + " failed a pickpocket attempt and you spot them doing it.");
            //PP_Log             ("Pickpocket", GetName(oPC) + " failed a pickpocket attempt and was spotted by " + GetName(oTarget));

            if (GetIsDead(oTarget))
                bCritFail = FALSE;      // you cannot fall over when the target is dead

            if (bCritFail)
                SendMessageToPC(oPC    , "Pickpocket Skill Check [FAIL]: Pickpocket(" + IntToString(iPickSkill) + ") + d20(" + IntToString(iDie) + ") - RepeatedAttemptPenalty(" + IntToString((iPickSkill + iDie) - iRoll) + ") = " + IntToString(iRoll) + " vs. DC " + IntToString(iTargetDC) + " - you rolled a 1 (critical failure) and failed your pickpocket attempt badly enough that you've been spotted.");
            else
                SendMessageToPC(oPC    , "Pickpocket Skill Check [FAIL]: Pickpocket(" + IntToString(iPickSkill) + ") + d20(" + IntToString(iDie) + ") - RepeatedAttemptPenalty(" + IntToString((iPickSkill + iDie) - iRoll) + ") = " + IntToString(iRoll) + " vs. DC " + IntToString(iTargetDC) + " - you failed your pickpocket attempt badly enough that you've been spotted (if target is dead then you are spotted only if companions are near).");

            if (!GetIsDead(oTarget)) {

                // Turn target to PC when spotted
                TurnToFaceObject(   oPC, oTarget);

                // On critical failure you fumble badly enough that you fall on your back
                //  and your helmet is unequipped so your face can be seen (for roleplay)
                AssignCommand   (   oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0f, RoundsToSeconds(3)));

                PP_AdjustPC(oPC);

                object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
                if (GetIsObjectValid(oHelm))
                    AssignCommand(  oPC, ActionUnequipItem(oHelm));
            }
        } else {
            // Spotted
            SendMessageToPC    (oTarget, "Pickpocket: " + GetName(oPC) + " failed a pickpocket attempt - but your character DOES NOT KNOW because you did not spot them doing it.");
            //PP_Log             ("Pickpocket", GetName(oPC) + " failed a pickpocket attempt, but was NOT spotted by " + GetName(oTarget));
        }

        // You lose (amount you failed the DC by) * level of target
        int iXPLoss = (iLostRollBy * GetHitDice(oTarget)) / 10;
        if (bCritFail)
            iXPLoss *= 2;

        if (GetXP(oPC) - iXPLoss < 3000) {
            //PP_Log  ("Pickpocket", GetName(oPC) + " would have gone below level 3, capping xp loss so they do not.");
            iXPLoss = GetXP(oPC) - 3000;
        }

        if (iXPLoss > 500) {
            //PP_Log  ("Pickpocket", GetName(oPC) + " would have lost " + IntToString(iXPLoss) + " but the 500xp governor kicked in.");
            iXPLoss = 500;
        }

        if (iXPLoss > 0) {
            //PP_Log  ("Pickpocket", GetName(oPC) + " lost " + IntToString(iXPLoss) + "xp");
            SetXP(oPC, GetXP(oPC) - iXPLoss);
        }

    }
    else {

        if (iRoll > iTargetDC && bCritSucc) {

            SendMessageToPC    (oTarget, "Pickpocket: " + GetName(oPC) + " rolled a natural 20 and beat your DC of " + IntToString(iTargetDC) + ", they get 2 picks from you - but your character DOES NOT KNOW.");
            SendMessageToPC    (oPC    , "Pickpocket Skill Check [OK]: Pickpocket(" + IntToString(iPickSkill) + ") + d20(" + IntToString(iDie) + ") - RepeatedAttemptPenalty(" + IntToString((iPickSkill + iDie) - iRoll) + ") = " + IntToString(iRoll) + " vs. DC " + IntToString(iTargetDC) + " - you rolled a natural 20 *and* beat your target's DC, so you get 2 picks from them!");

            Pickpocket         (oPC    , oTarget, iBeatRollBy);

        } else {
            SendMessageToPC    (oTarget, "Pickpocket: " + GetName(oPC) + " beat your DC of " + IntToString(iTargetDC) + ", they get 1 pick from you - but your character DOES NOT KNOW.");
            if (bCritSucc)
                SendMessageToPC(oPC    , "Pickpocket Skill Check [OK]: Pickpocket(" + IntToString(iPickSkill) + ") + d20(" + IntToString(iDie) + ") - RepeatedAttemptPenalty(" + IntToString((iPickSkill + iDie) - iRoll) + ") = " + IntToString(iRoll) + " vs. DC " + IntToString(iTargetDC) + " - you rolled a natural 20, and although you didn't beat the DC, you get one successful pick.");
            else
                SendMessageToPC(oPC    , "Pickpocket Skill Check [OK]: Pickpocket(" + IntToString(iPickSkill) + ") + d20(" + IntToString(iDie) + ") - RepeatedAttemptPenalty(" + IntToString((iPickSkill + iDie) - iRoll) + ") = " + IntToString(iRoll) + " vs. DC " + IntToString(iTargetDC) + " - one successful pick.");
        }

        Pickpocket             (oPC    , oTarget, iBeatRollBy);
    }
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            PP_Activate( );
            break;
    }
}
