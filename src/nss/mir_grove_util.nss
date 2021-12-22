////////////////////////////////////////////////////////////////
// Circle of Balance     Druid Grove System (MagnumMan         )
// Copyright (C) 2004 by James E. King, III (jking@prospeed.net)
//                       Valdor Dormanigon  (Archdruid         )
////////////////////////////////////////////////////////////////
//
// Constants for all scripts to reference and common utility
// functions are kept here.
//
////////////////////////////////////////////////////////////////

//2007/04/27 Last ditch effort hack by Disco to counter Funi, line 127
//2007/08/04 Changed Hallowing bits


#include "nw_i0_plot"                             // HasItem
#include "x0_i0_position"                         // GetChangedPosition
#include "logger"

// Tweaks
const float  HALLOW_RADIUS            = 16.0f;    // dist from tree to stone circle edge
const int    REGEN_HP                 = 1;
const float  REGEN_INTERVAL           = 2.0f;
const float  MIN_TELEPORT_TREE_RADIUS = 6.0f;

// Tags & ResRefs
const string WOLF_DEN_TAG             = "mir_wolf_den";
const string GROVE_TAG                = "mir_hidden_grove";
const string GROVE_DANGER_WOLF_TAG    = "mir_wolf_danger";
const string ELVORIEL_TAG             = "mir_san_elvoriel";
const string DUIR_TAG                 = "mir_grove_great_tree";
const string DUIR_FAKE_CREATURE_TAG   = "mir_grove_great_tree_fake_creatu";
const string TELEPORT_TREE_TAG        = "cb_teleport_tree";
const string LARGE_BARK_TAG           = "cb_bark";
const string LARGE_BARK_RESREF        = "cb_bark";
const string SMALL_BARK_TAG           = "cb_bark_sml";
const string SMALL_BARK_RESREF        = "cb_bark_sml";
const string ARCHDRUID_KEY_TAG        = "cb_archdruid_key"; // Player with this is a Grove Admin

// Waypoints
const string WOLF_WAKEUP_FIRST_WAYPT  = "WP_mir_wolf_wakeup_1";
const string WOLF_WAKEUP_SECOND_WAYPT = "WP_mir_wolf_wakeup_2";
const string WOLF_DEN_WAYPT           = "WP_mir_wolf_home";
const string ELVORIEL_TRANSPORT_WAYPT = "WP_cb_cordor";

// Merchants
const string ELVORIEL_MERCHANT_TAG    = "mir_san_elvoriel_merchant";

// Variables
//const string GROVE_REGEN_VARNAME      = "MIR.GROVE.REGEN";
const string BARK_ACTIVATED_VARNAME   = "MIR.GROVE.ACTIVATED.BARK";
const string GROVE_LISTENER_COUNT     = "MIR.GROVE.LISTEN.COUNT";
const string ELVORIEL_POLY_VARNAME    = "MIR.SAN.ELVORIEL.FORM";
const string CB_BARK_ACTIVATED        = "CB.BARK.ACTIVATED";
const string CB_BARK_CANUSE_PREFIX    = "CB.";

// Conversations
const string DUIR_BARK_ADMIN_MENU     = "cb_bark";


// --------------------------------------------------------------------------

object GetGroveArea()
{
    return GetObjectByTag(GROVE_TAG);
}

object GetGreatDuir()
{
    return GetObjectByTag(DUIR_TAG);
}

object GetFakeListener()
{
    return GetObjectByTag(DUIR_FAKE_CREATURE_TAG);
}

object GetClosestTeleportTree(object oPC)
{
    return GetNearestObjectByTag(TELEPORT_TREE_TAG, oPC);
}

object CreateSmallBark(object oPC)
{
    return CreateItemOnObject(SMALL_BARK_RESREF, oPC);
}

int IsSmallBark(object oBark)
{
    if (GetTag(oBark) == SMALL_BARK_TAG)
        return TRUE;
    else
        return FALSE;
}

object CreateLargeBark(object oPC)
{
    return CreateItemOnObject(LARGE_BARK_RESREF, oPC);
}

// Will prefer to return the large (unlimited use) item before the single use
object GetBarkOnPlayer(object oPC){

    object oSmall = OBJECT_INVALID;

    object oBark = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oBark)) {
        if (GetTag(oBark) == SMALL_BARK_TAG)
            oSmall = oBark;
        else if (GetTag(oBark) == LARGE_BARK_TAG)
            return oBark;

        oBark = GetNextItemInInventory(oPC);
    }

    return oSmall;

}

int IsGroveMember(object oPC)
{
    object oBark = GetBarkOnPlayer(oPC);
    if (!GetIsObjectValid(oBark) || IsSmallBark(oBark))
        return FALSE;
    else
        return TRUE;
}

int IsBarkAdmin(object oPC){

    if ( GetPCPlayerName( oPC ) == "Funiculus" ){

        return FALSE;
    }

    return HasItem(oPC, ARCHDRUID_KEY_TAG);
}

// --------------------------------------------------------------------------

void RemoveAllObjectsWithTagFromPlayer(object oPC, string tag){

    object oObj = GetFirstItemInInventory(oPC);

    while (oObj != OBJECT_INVALID) {

        if (GetTag(oObj) == tag) {

            if ( tag == SMALL_BARK_TAG ){

                FloatingTextStringOnCreature("The small Duir Bark in your pack turns to ash", oPC, FALSE);

            }
            else if ( tag == LARGE_BARK_TAG ){

                FloatingTextStringOnCreature("The Duir Bark in your pack turns to ash - you are no longer a member of the Circle of Balance", oPC, FALSE);
            }

            DestroyObject( oObj );
        }

        oObj = GetNextItemInInventory(oPC);
    }
}

// --------------------------------------------------------------------------

void InformBarkAdmin(object oBark, object oPC, string theverb)
{
    object oAdmin = GetFirstPC();
    while (oAdmin != OBJECT_INVALID) {

        if (IsBarkAdmin(oAdmin)) {

            string type;
            if (GetTag(oBark) == LARGE_BARK_TAG)
                type = "[member]";
            else
                type = "[visitor]";

            SendMessageToPC(oAdmin, "DUIR BARK " + type + ": " + theverb + " character '" +
                                    GetName(oPC) + "' played by '" +
                                    GetPCPlayerName(oPC) + "'");
        }

        oAdmin = GetNextPC();
    }
}

// --------------------------------------------------------------------------

void IncEnableFakeListener(object oFakeListener)
{
    SetListening(oFakeListener, TRUE);
    SetLocalInt(oFakeListener, GROVE_LISTENER_COUNT,
        GetLocalInt(oFakeListener, GROVE_LISTENER_COUNT) + 1);
}

void DecDisableFakeListener(object oFakeListener)
{
    int iListeners = GetLocalInt(oFakeListener, GROVE_LISTENER_COUNT) - 1;
    if (iListeners < 0)
        iListeners = 0;

    if (!iListeners)
        SetListening(oFakeListener, FALSE);

    SetLocalInt(oFakeListener, GROVE_LISTENER_COUNT, iListeners);
}

// --------------------------------------------------------------------------

// I decided to remove the lightning effect - Jim
float TeleportCommonSFX(location lNearestTree, float accumulatedDelay)
{
//    effect eLightning = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    effect eNatBal    = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);

//    int strikes = d3();
//    int i;
//    for (i = 0; i < strikes; ++i) {
//        accumulatedDelay += 0.5f + (1 / (1+Random(9)));
//        DelayCommand(accumulatedDelay, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eLightning, lNearestTree));
//    }

    accumulatedDelay += 0.8f;
    DelayCommand(accumulatedDelay, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eNatBal, lNearestTree));

    return accumulatedDelay;
}

void TeleportCommon   (object oPC, location lDest)
{
    object oBark = GetLocalObject(oPC, CB_BARK_ACTIVATED);

    // Elvoriel's conversation choice "take me to Cordor" uses this code too
    int    iElvorielTriggered = GetLocalInt(oPC, "Elvoriel");
    DeleteLocalInt(oPC, "Elvoriel");

    if (GetIsObjectValid(oBark) && IsSmallBark(oBark) && !iElvorielTriggered) {
        FloatingTextStringOnCreature("The small Duir Bark in your pack turns to ash", oPC, FALSE);
        DestroyObject(oBark);
        SetLocalObject(oPC, CB_BARK_ACTIVATED, OBJECT_INVALID);
    }

    location lNearestTree;
    if (GetArea(oPC) == GetGroveArea())
        lNearestTree = GetLocation(GetGreatDuir());
    else
        lNearestTree = GetLocation(GetClosestTeleportTree(oPC));

    float accumulatedDelay = 0.0f;
    accumulatedDelay += TeleportCommonSFX(lNearestTree, accumulatedDelay);

    DelayCommand(accumulatedDelay, AssignCommand(oPC, ActionMoveToLocation(lNearestTree)));

    // Appear close to the tree but not directly on it
    vector   new_vec = GetChangedPosition(GetPositionFromLocation(lDest),
                                          IntToFloat(5 + Random(5)),
                                          IntToFloat(Random(359)));
    location new_loc = Location(GetAreaFromLocation(lDest),
                                new_vec,
                                IntToFloat(Random(359)));

    accumulatedDelay += 2.5f;
    DelayCommand(accumulatedDelay, AssignCommand(oPC, ActionJumpToLocation(new_loc)));

    // Now some VFX at the destination...
    if (GetArea(oPC) == GetGroveArea())
        lNearestTree = GetLocation(GetClosestTeleportTree(GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lDest)));
    else
        lNearestTree = GetLocation(GetGreatDuir());

    accumulatedDelay += TeleportCommonSFX(lNearestTree, accumulatedDelay);
}

void TeleportToGrove  (object oPC)
{
    // Now that this player has found one of the teleport trees, they
    // should be allowed to use it.  We add the a special int to the bark
    // they activated, much like the quest subsystem works to
    // mark that they can do it from now on.

    object oBark = GetLocalObject(oPC, CB_BARK_ACTIVATED);
    if ( !GetIsObjectValid(oBark) ) {
        LogWarn( "mir_grove_util", "Teleport To Grove: Could not find bark "
                                    + " for pc: " + GetName(oPC) );
        return;
    }

    SetLocalInt(oBark, CB_BARK_CANUSE_PREFIX + GetTag(GetArea(oPC)), 1);

    TeleportCommon(oPC, GetLocation(GetGreatDuir()));
}

void TeleportFromGrove(object oPC, object oDest)
{
    // @@@ Cutscene effect of user walking into the tree would be pretty cool.
    TeleportCommon(oPC, GetLocation(oDest));
}

// --------------------------------------------------------------------------

void ApplyHallowingEffect( object oPC ){

    SetLocalInt( oPC, "nHallowed", 1 );

    if ( GetHasSpellEffect( SPELL_REGENERATE, oPC ) == 0 &&

        GetHasSpellEffect(SPELL_MONSTROUS_REGENERATION, oPC ) == 0){

        int nAmount    = GetMaxHitPoints( oPC ) - GetCurrentHitPoints( oPC );

        if ( nAmount < 1 ){

            return;
        }
        else{

            nAmount = ( nAmount / 30 ) + 1;
        }

        effect eRegen = EffectRegenerate( nAmount, 1.0 );
        effect eVis   = EffectVisualEffect( VFX_DUR_BLUR );
        effect eLink  = EffectLinkEffects( eRegen, eVis );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, 31.0f );

        FloatingTextStringOnCreature( GetName(OBJECT_SELF)+": Your wounds heal in close proximity to the Great Duir", oPC, FALSE);
    }

    effect eEffect = GetFirstEffect( oPC );

    while ( GetIsEffectValid( eEffect ) ) {

        if (GetEffectType( eEffect ) == EFFECT_TYPE_INVISIBILITY ||
            GetEffectType( eEffect ) == EFFECT_TYPE_IMPROVEDINVISIBILITY ) {

            RemoveEffect( oPC, eEffect );
            FloatingTextStringOnCreature( "The healing glow negates your invisibility.", oPC, FALSE );
        }

        eEffect = GetNextEffect( oPC );
    }

    DelayCommand( 600.0, DeleteLocalInt( oPC, "nHallowed" ) );

}
