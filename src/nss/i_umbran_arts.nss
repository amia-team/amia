// A set of Shadowdancer skills, all of them taking up uses of
// Shadow Evade to activate.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/28/2011 PaladinOfSune    Initial Release.
// 05/09/2011 PaladinOfSune    Added Essence of Ethereality.
// 05/31/2018 Hrothmus         Readded Shade Merge, pulled in code for 5 other widgets
//
//
//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_spellhook"
#include "x0_i0_match"
#include "amia_include"
#include "inc_ds_records"
#include "inc_ds_actions"
#include "inc_td_appearanc"
#include "nwnx_effects"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------
void VestigeUnraveling( object oPC );
void EssenceOfEthereality( object oPC );
void ShadeMerge( object oPC );
void CreatePulsar( object oPC, object oItem );
void NightEyes( object oPC);
void RefundShadowEvade( object oPC, int nAmount );
void ShadowAffinity( object oPC );
void TenebrousTempo( object oPC );
void ShadowManticore( object oPC);
void EmptyFunction( object oTarget );
void CastingAnim( object oPC);
int DecrementShadowEvade( object oPC, int nAmount );
effect EffectShadowPulsarEffect();

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void ActivateItem()
{
    // Major variables.
    object oPC          = GetItemActivator();
    object oTarget      = GetItemActivatedTarget();
    location lTarget    = GetItemActivatedTargetLocation();
    object oItem        = GetItemActivated();
    string sItemName    = GetResRef( oItem );
    int iSDLevel        = GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC );


    // Identify widget and direct to appropriate code
    if( sItemName == "umbran_arts_1" && DecrementShadowEvade( oPC, 1 ) == 1  && iSDLevel >= 6 ){
        CastingAnim( oPC);
        DelayCommand( 4.0, VestigeUnraveling( oPC ) );
    }
    else if( sItemName == "umbran_arts_2" && DecrementShadowEvade( oPC, 2 ) == 1 && iSDLevel >= 10 ){
        CastingAnim( oPC);
        DelayCommand( 4.0, EssenceOfEthereality( oPC ) );
    }
    else if( sItemName == "umbran_arts_3" && DecrementShadowEvade( oPC, 3 ) == 1 && iSDLevel >= 16 ){
        CastingAnim( oPC);
        DelayCommand( 4.0, ShadeMerge( oPC ) );
    }
    else if( sItemName == "umbran_arts_4" && DecrementShadowEvade( oPC, 2 ) == 1 && iSDLevel >= 10 ){
        CastingAnim( oPC);
        DelayCommand( 4.0, CreatePulsar( oPC, oItem ) );
    }
    else if( sItemName == "umbran_arts_7" && DecrementShadowEvade( oPC, 3 ) == 1 && iSDLevel >= 16 ){
        CastingAnim( oPC);
        DelayCommand( 4.0, ShadowManticore( oPC ) );
    }
    else if( sItemName == "umbran_arts_6" && iSDLevel >= 6 ){
        DelayCommand( 4.0, NightEyes( oPC ) );
    }
    else if( sItemName == "umbran_arts_5" && iSDLevel >= 6 ){
        AssignCommand( oPC, ShadowAffinity( oPC ) );
    }
    else if( sItemName == "umbran_arts_8" && iSDLevel >= 10 ){
        CastingAnim( oPC);
        DelayCommand( 4.0, TenebrousTempo( oPC ) );
    }
    else if ( sItemName == "" ){
                AssignCommand( oPC, EmptyFunction( oTarget ) );
    }
}

void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }

    SetExecutedScriptReturnValue(nResult);
}

void VestigeUnraveling( object oPC ){
    // Variables.
    effect eVis = EffectVisualEffect(VFX_DUR_TENTACLE);
    effect eVis2 = EffectVisualEffect( VFX_IMP_KNOCK );
    float fDelay;
    int nResist;

    // Create a circle of visuals around the caster.
    location lLocation;
    float fAngle;
    int x;

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oPC, 4.0 );
    for ( x = 0; x < 4; x++ ) {
        lLocation   = GenerateNewLocationFromLocation( GetLocation( oPC ), 2.0, fAngle, 0.0 );
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eVis, lLocation, 4.5 );
        fAngle      = fAngle + 90;
    }

    // Capture each door and placeable within the radius.
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 30.0, GetLocation( oPC ), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
    while( GetIsObjectValid( oTarget ) )
    {
        fDelay = GetRandomDelay( 0.5, 2.5 );
        if( !GetPlotFlag( oTarget ) && GetLocked( oTarget ) )
        {
            nResist =  GetDoorFlag( oTarget, DOOR_FLAG_RESIST_KNOCK );
            if ( nResist == 0 )
            {
                // Unlock it!
                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0 ) );
                DelayCommand( fDelay + 0.3, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis2, oTarget ) );
                AssignCommand( oTarget, ActionUnlockObject( oTarget ) );
            }
            else if ( nResist == 1 )
            {
                FloatingTextStrRefOnCreature( 83887, OBJECT_SELF );   //
            }
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 30.0, GetLocation( oPC ), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
    }
}

// Function that handles the Umbran Arts: Essence Of Ethereality Widget
void EssenceOfEthereality( object oPC )
{
    // Used for duration/AC.
    int nDuration   = GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC );
    int nDexterity  = GetAbilityModifier( ABILITY_DEXTERITY, oPC );

    // Visual variables.
    effect eVFX1    = EffectVisualEffect( VFX_DUR_SANCTUARY );
    effect eVFX2    = EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR );
    effect eVFX3    = EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE );
    effect eFNF     = EffectVisualEffect( VFX_FNF_SMOKE_PUFF );

    // DC is Dexterity Mod + 10 + Tier Level (Tier 2 = spell level 6 equivalent).
    int nDC         = nDexterity + 16;
    effect eSanc    = EffectSanctuary( nDC );

    // Link it all together.
    effect eLink = EffectLinkEffects( eVFX1, eVFX2 );
    eLink = EffectLinkEffects( eLink, eVFX3 );
    eLink = EffectLinkEffects( eLink, eSanc );

    // Apply to the PC.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eFNF, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds( nDuration ) );
}

// Function that handles the Umbran Arts: Shade Merge Widget
void ShadeMerge( object oPC )
{
    // Ensure that a summoned creature is present
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
    if(!GetIsObjectValid(oSummon))
    {
        SendMessageToPC(oPC, "Your shade needs to be summoned first!");
        RefundShadowEvade( oPC, 3 );
        return;
    }

    // Ensure summoned creature is a shade
    string sSummonRef = GetResRef(oSummon);
    if((FindSubString(sSummonRef, "sd_shadow_")==-1))
    {
        SendMessageToPC(oPC, "Summoned creature is not a shade!");
        RefundShadowEvade( oPC, 3 );
        return;
    }

    // Unsummon the shade
    effect eUnsummon = EffectVisualEffect(VFX_IMP_UNSUMMON);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eUnsummon, oSummon);
    DestroyObject(oSummon, 1.0);

    // Ability Duration
    int nDuration   = GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC );

    // Create visual effects
    effect eHowl = EffectVisualEffect( VFX_IMP_DEATH_L );
    effect eTentic = EffectVisualEffect( VFX_DUR_TENTACLE );
    effect eShadow = EffectVisualEffect ( VFX_DUR_PROT_SHADOW_ARMOR );

    // Create functional effects
    effect eConceal = EffectConcealment( 50 );
    effect eNeg = EffectDamageImmunityIncrease( DAMAGE_TYPE_NEGATIVE, 100 );
    effect eLevel = EffectImmunity( IMMUNITY_TYPE_NEGATIVE_LEVEL );
    effect eDeath = EffectImmunity( IMMUNITY_TYPE_DEATH );
    effect eAbil = EffectImmunity( IMMUNITY_TYPE_ABILITY_DECREASE );

    // Link the effects together as eLink
    effect eLink = EffectLinkEffects( eShadow, eNeg );
           eLink = EffectLinkEffects( eLevel, eLink );
           eLink = EffectLinkEffects( eAbil, eLink );
           eLink = EffectLinkEffects( eDeath, eLink );
           eLink = EffectLinkEffects( eConceal, eLink );

    // Begin check to set glowy eyes if the oPC is of a workable appearance
    int iAppearance = GetAppearanceType( oPC );
    int iGender = GetGender( oPC );
    effect eGlow;

    if ((iAppearance > -1) && (iAppearance < 7) && (iGender == GENDER_FEMALE))
      {
      switch (iAppearance)
         {
         case APPEARANCE_TYPE_DWARF: eGlow = EffectVisualEffect(VFX_EYES_GREEN_DWARF_FEMALE); break;
         case APPEARANCE_TYPE_ELF: eGlow = EffectVisualEffect(VFX_EYES_GREEN_ELF_FEMALE); break;
         case APPEARANCE_TYPE_GNOME: eGlow = EffectVisualEffect(VFX_EYES_GREEN_GNOME_FEMALE); break;
         case APPEARANCE_TYPE_HALFLING: eGlow = EffectVisualEffect(VFX_EYES_GREEN_HALFLING_FEMALE); break;
         case APPEARANCE_TYPE_HALF_ELF: eGlow = EffectVisualEffect(VFX_EYES_GREEN_HUMAN_FEMALE); break;
         case APPEARANCE_TYPE_HALF_ORC: eGlow = EffectVisualEffect(VFX_EYES_GREEN_HALFORC_FEMALE); break;
         case APPEARANCE_TYPE_HUMAN: eGlow = EffectVisualEffect(VFX_EYES_GREEN_HUMAN_FEMALE); break;
         }
         eLink = EffectLinkEffects( eGlow, eLink);
      }
   else if ((iAppearance > -1) && (iAppearance < 7) && (iGender == GENDER_MALE))
      {
      switch (iAppearance)
         {
         case APPEARANCE_TYPE_DWARF: eGlow = EffectVisualEffect(VFX_EYES_GREEN_DWARF_MALE); break;
         case APPEARANCE_TYPE_ELF: eGlow = EffectVisualEffect(VFX_EYES_GREEN_ELF_MALE); break;
         case APPEARANCE_TYPE_GNOME: eGlow = EffectVisualEffect(VFX_EYES_GREEN_GNOME_MALE); break;
         case APPEARANCE_TYPE_HALFLING: eGlow = EffectVisualEffect(VFX_EYES_GREEN_HALFLING_MALE); break;
         case APPEARANCE_TYPE_HALF_ELF: eGlow = EffectVisualEffect(VFX_EYES_GREEN_HUMAN_MALE); break;
         case APPEARANCE_TYPE_HALF_ORC: eGlow = EffectVisualEffect(VFX_EYES_GREEN_HALFORC_MALE); break;
         case APPEARANCE_TYPE_HUMAN: eGlow = EffectVisualEffect(VFX_EYES_GREEN_HUMAN_MALE); break;
         }
         eLink = EffectLinkEffects( eGlow, eLink);
      }

            // Set effects as Supernatural
           eLink = SupernaturalEffect( eLink );

    effect eInvis = ExtraordinaryEffect( EffectInvisibility( INVISIBILITY_TYPE_NORMAL ) );

    float fTenticleDur = 3.0f;

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eHowl, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds( nDuration ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eTentic, oPC, fTenticleDur );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eInvis, oPC, TurnsToSeconds( nDuration ) );
}

// Function that handles the Umbran Arts: Pulsar Widget
void CreatePulsar(object oPC, object oItem)
{
    // Ability Duration
    int nDuration   = GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC );

    // Ensure that a summoned creature is present
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
    if(!GetIsObjectValid(oSummon))
    {
        SendMessageToPC(oPC, "Your shade needs to be summoned first!");
        RefundShadowEvade( oPC, 2 );
        return;
    }

    // Ensure summoned creature is a shade
    string sSummonRef = GetResRef(oSummon);
    if((FindSubString(sSummonRef, "sd_shadow_")==-1))
    {
        SendMessageToPC(oPC, "Summoned creature is not a shade!");
        RefundShadowEvade( oPC, 2 );
        return;
    }

    // Ensure summoned shade does not allready have an AOE effect active
    if(GetHasEffect(EFFECT_TYPE_AREA_OF_EFFECT))
    {
        SendMessageToPC(oPC, "An AOE effect already active on the shade!");
        RefundShadowEvade( oPC, 2 );
        return;
    }

    // Apply the effects (effect created further down in script)
    AssignCommand(oItem, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShadowPulsarEffect(), oSummon, TurnsToSeconds( nDuration )));
}

void NightEyes( object oPC)
{
    // Effect variables
    effect eUltravision  = EffectUltravision();

    // Apply it on use.
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( eUltravision ), oPC );

    // Private message upon activation
    FloatingTextStringOnCreature( "<cþ>- Night Eyes activated -</c>", oPC, FALSE );
}

void ShadowAffinity( object oPC ){

    clean_vars( oPC, 4 );

    SetLocalString( oPC, "ds_action", "td_shaafy_act" );

    ActionStartConversation( oPC, "td_shaafy", TRUE, FALSE );
}

void TenebrousTempo( object oPC ){

    if ( !TakeFeatUses( oPC, FEAT_SHADOW_EVADE, 1 ) ){

        SendMessageToPC( oPC, "You need a charge of your shadow-evade to use this!" );
        return;
    }

    effect eShadow = EffectLinkEffects( EffectMovementSpeedIncrease( 50 ), EffectVisualEffect( VFX_DUR_AURA_PULSE_GREY_BLACK ) );
    eShadow = SetEffectScript( eShadow, "td_effect_end" );
    eShadow = SetEffectSpellID( eShadow, 9630 );
    //eShadow = SetEffectExpireOnHostileAction( eShadow );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( eShadow ), oPC, TurnsToSeconds( GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC ) ) );
}

void ShadowManticore( object oPC )
{

    // Used for duration/AC.
    int nDuration   = GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC );

    // Visual variables.
    effect eVFX     = EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR );
    effect eFNF     = EffectVisualEffect( VFX_IMP_AC_BONUS );

    // Effects
    effect eDR      = EffectDamageReduction( 20, DAMAGE_POWER_PLUS_FIVE, 150 );
    effect eDeath   = EffectImmunity( IMMUNITY_TYPE_DEATH );

    // Link it all together.
    effect eLink = EffectLinkEffects( eVFX, eDeath );

    // Apply to the PC.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eFNF, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDR, oPC, TurnsToSeconds( nDuration ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds( nDuration ) );

}

void RefundShadowEvade( object oPC, int nAmount)
{
    int x;
    for ( x = 0; x < nAmount; x++) {
        IncrementRemainingFeatUses( oPC, FEAT_SHADOW_EVADE );
    }
}

int DecrementShadowEvade( object oPC, int nAmount )
{
    // Loop through Shadow Evade uses and take as many as needed.
    int x;
    for ( x = 0; x < nAmount; x++ ) {
        if( !GetHasFeat( FEAT_SHADOW_EVADE, oPC ) ) {
            FloatingTextStringOnCreature( "You do not have enough uses of Shadow Evade to use this ability.", oPC, FALSE );
            return 0;
        }
        DecrementRemainingFeatUses( oPC, FEAT_SHADOW_EVADE );
    }

    return 1;
}

void CastingAnim ( object oPC ) {

    //Casting Animations and sound
    AssignCommand( oPC, ClearAllActions() );
    if( GetGender( oPC ) == 1 ) {
        AssignCommand( oPC, PlaySound( "vs_chant_illu_hf" ) );
    }
    else {
        AssignCommand( oPC, PlaySound( "vs_chant_illu_hm" ) );
    }
    AssignCommand( oPC, ActionPlayAnimation( ANIMATION_LOOPING_CONJURE1, 1.0, 3.0 ) );

}

effect EffectShadowPulsarEffect()
{
    effect eAOE = EffectAreaOfEffect(AOE_PER_CUSTOM_AOE,"****", "i_sd_pulsar_hb", "****");
    effect eVFX1 = EffectVisualEffect(VFX_DUR_AURA_PULSE_RED_BLACK);
    effect eVFX2= EffectVisualEffect(VFX_DUR_AURA_SILENCE);

    effect eLink = EffectLinkEffects(eVFX1, eVFX2);
    eLink = EffectLinkEffects(eLink, eAOE);

    return eLink;
}

void EmptyFunction( object oTarget ){

}
