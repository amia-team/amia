//::///////////////////////////////////////////////
//:: Amia Fall Check
//:: amx_fallcheck
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: 06/23/2022
//:://////////////////////////////////////////////

// Explanation:
// This script is tied to several forms to check if a divine caster PC is fallen
// It has numerous checks, from a specific fallen check to checks to ensure
// alignment/deities/domains/etc are correct for various divine classes

#include "inc_ds_gods"

int ALIGN_BORDER_HIGH = 70;
int ALIGN_BORDER_LOW = 30;
string FALL_WIDGET = "dg_fall";

int DruidCheck(object oPC) {
    string sGod  = GetDeity( oPC );
    if ( sGod == "" ) {
        return FALSE;
    }
    if (IsValidDruidGod(FindIdol(oPC, sGod))) {
        return TRUE;
    }
    if (sGod == "Silvanus" || sGod == "Mielikki" || sGod == "Eldath"
    || sGod == "Chauntea" || sGod == "Gwaeron Windstrom" || sGod == "Lurue"
    || sGod == "Nobanion" || sGod == "Shiallia" || sGod == "Ubtao"
    || sGod == "Ulutiu" || sGod == "Auril" || sGod == "Malar" || sGod == "Talos"
    || sGod == "Talona" || sGod == "Umberlee" || sGod == "Aerdrie Faenya"
    || sGod == "Angharradh" || sGod == "Deep Sashelas" || sGod == "Fenmarel Mestarine"
    || sGod == "Rillifane Rallathil" || sGod == "Solonor Thelandira" || sGod == "Oberon"
    || sGod == "Anhur" || sGod == "Isis" || sGod == "Osiris" || sGod == "Sebek"
    || sGod == "Set" || sGod == "Thard Harr" || sGod == "Baervan Wildwanderer"
    || sGod == "Segojan Earthcaller" || sGod == "Sheela Peryroyl") {
        return TRUE;
    }
    return FALSE;
}

// Check if the caster has a valid deity. Return FALSE if they don't, return TRUE if they do
int DeityCheck(object oPC, int nClass = CLASS_TYPE_INVALID) {
    string sGod  = GetDeity( oPC );
    if ( sGod == "" ) {
        SendMessageToPC(oPC, "You have no deity which you can draw divine power from.");
        return FALSE;
    }
    object oIdol = FindIdol(oPC, sGod);
    if ( oIdol == OBJECT_INVALID ){
        SendMessageToPC(oPC, sGod + " has no domain on Amia...");
        return FALSE;
    }
    //check alignment vs god
    if (!MatchAlignment( oPC, oIdol )) {
        SendMessageToPC(oPC, "Your alignment and your patron's are out of sync...");
        return FALSE;
    }

    if (nClass == CLASS_TYPE_CLERIC) {
        //check domains vs god
        if (MatchDomain( oPC, oIdol ) == -1) {
            SendMessageToPC(oPC, "Your clerical domains do not align with your patron's...");
            return FALSE;
        }
        if (MatchDomain( oPC, oIdol, 1 ) == -1) {
            SendMessageToPC(oPC, "Your clerical domains do not align with your patron's...");
            return FALSE;
        }
    }
    if (nClass == CLASS_TYPE_DRUID) {
        if (!DruidCheck(oPC)) {
            SendMessageToPC(oPC, "Your patron does not support druidism...");
            return FALSE;
        }
    }

    return TRUE;
}

// Check if the caster has a fallen widget
int IsSpecificFallen(object oPC) {
    if (GetLocalInt(oPC,"Fallen") == 1) {
        return TRUE;
    }
    if (GetItemPossessedBy(oPC,FALL_WIDGET) != OBJECT_INVALID) {
        return TRUE;
    }
    return FALSE;
}

// Return TRUE if the caster is a divine class
int IsDivineCast() {
    int iClass = GetLastSpellCastClass();
    if (iClass == CLASS_TYPE_BLACKGUARD || iClass == CLASS_TYPE_CLERIC
    || iClass == CLASS_TYPE_DRUID || iClass == CLASS_TYPE_PALADIN
    || iClass == CLASS_TYPE_RANGER || iClass == CLASS_TYPE_DIVINE_CHAMPION) {
        return TRUE;
    }
    return FALSE;
}

// Return TRUE if the caster is NOT Fallen
int FallenCastCheck(object oPC) {
    // Don't bother checking if it came from an item
    if( GetIsObjectValid( GetSpellCastItem( ))) {
       return TRUE;
    }

    int iClass = GetLastSpellCastClass();

    if (iClass == CLASS_TYPE_BLACKGUARD) {
        if (GetAlignmentGoodEvil(oPC) > ALIGN_BORDER_LOW) {
            return FALSE;
        }
    }
    if (iClass == CLASS_TYPE_PALADIN) {
        if (GetAlignmentGoodEvil(oPC) < ALIGN_BORDER_HIGH) {
            return FALSE;
        }
        if (GetAlignmentLawChaos(oPC) < ALIGN_BORDER_HIGH) {
            return FALSE;
        }
    }

    if (iClass == CLASS_TYPE_BLACKGUARD || iClass == CLASS_TYPE_CLERIC
    || iClass == CLASS_TYPE_DRUID || iClass == CLASS_TYPE_PALADIN
    || iClass == CLASS_TYPE_RANGER || iClass == CLASS_TYPE_DIVINE_CHAMPION) {
        if (IsSpecificFallen(oPC)) {
            return FALSE;
        }
    }
    if (iClass == CLASS_TYPE_CLERIC
    || iClass == CLASS_TYPE_DRUID || iClass == CLASS_TYPE_PALADIN
    || iClass == CLASS_TYPE_RANGER || iClass == CLASS_TYPE_DIVINE_CHAMPION) {
        if (!DeityCheck(oPC,iClass)) {
            return FALSE;
        }
    }

    return TRUE;
}