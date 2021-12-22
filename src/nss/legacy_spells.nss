//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_cust_spell
//description: Script for custom spells
//used as: Custom spellscript

/*
---------
Changelog
---------
Date         Name        Reason
------------------------------------------------------------------
2010-03-14   James       Start
2013-07-06   PoS         Refactored, removed old unused spells and shifted some utility functions into the include.
2013-08-10   Terrah      Renamed ds_cust_spell -> legacy_spells, fired after new spell-script
2016-04-11   PoS         Added some missing spells
------------------------------------------------------------------
*/

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------

#include "inc_ds_records"
#include "x2_inc_spellhook"
//custom spell constants
#include "inc_dc_spells"
#include "x2_inc_toollib"
#include "x2_inc_itemprop"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "nwnx_effects"

//-----------------------------------------------------------------------------
// prototypes - self cast
//-----------------------------------------------------------------------------
void ArcaneStrike( object oPC );
void Beatitudes( object oPC );
void Bless ( object oPC );
void CupolaofAmplifiedSilence( object oPC );
void DivineResilience( object oPC );
void EarthShield( object oPC );
void GhostlyVeil( object oPC );
void LesserLeyRecall( object oPC );
void LuminousCloud( object oPC );
void MassDeathWard( object oPC );
void PlanarAnchor( object oPC );
void Orcbane( object oPC );
void Sentinel( object oPC );
void ShieldofPeace( object oPC );
void SurgingSpite( object oPC );
void SurgeOfLunacy( object oPC );
void TwistOfFate( object oPC );
void VoxCelestia( object oPC );
//-----------------------------------------------------------------------------
// prototypes - target cast
//-----------------------------------------------------------------------------
void Antithetic( object oPC, object oTarget );
void Barkskin( object oPC, object oTarget );
void BlackCoffin( object oPC, object oTarget );
void ControlConstruct( object oPC, object oTarget );
void DarknessInevitable( object oPC, object oTarget );
void EarthenGrasp( object oPC, object oTarget );
void EdgeOfWilting( object oPC, object oTarget );
void Ingenious( object oPC, object oTarget );
void Fiendsburn( object oPC, object oTarget );
void FreedomOfMovement( object oPC, object oTarget );
void IllusionaryPolymorph( object oPC, object oTarget );
void ParagonSlow( object oPC, object oTarget );
void ReadSchematicMain(object oPC, object oTarget);
void SkeletalDeliquescence( object oPC, object oTarget );
void SpiritShield( object oPC, object oTarget );
void Solipsism( object oPC, object oTarget );
void SoulInfusion( object oPC, object oTarget );
void WallofIce( object oPC, object oTarget );
void WindWalk( object oPC, object oTarget );
//-----------------------------------------------------------------------------
// prototypes - location cast
//-----------------------------------------------------------------------------
void AntiPyromanticCloud(object oPC, location lTarget );
void CleansingMist( object oPC, location lTarget );
void DevouringEarth( object oPC, location lTarget );
void DracoBlast( object oPC, location lTarget );
void EyesOfTheSandTracker( object oPC, location lTarget );
void Foxfire( object oPC, location lTarget );
void GreaterHeroism( object oPC, location lTarget );
void GreaterSandstorm( object oPC, location lTarget );
void JungleOfThorns( object oPC, location lTarget );
void PersistantImage( object oPC, location lTarget );
void Soothe( object oPC, object oTarget, location lTarget );
void VortexOfIllFate( object oPC, object oTarget, location lTarget );
//-----------------------------------------------------------------------------
// prototypes - extra functions... generally discouraged, but sometimes needed
//-----------------------------------------------------------------------------
void DracoBlastDeath( object oTarget, int nDC, int nHP );
void DracoBlastImpact( object oTarget );
void EdgeWoundEffect( object oPC );
void ReadSchematicConcentration(object oPC, object oTarget);
void RunBlackCoffinImpact( object oTarget );
void RunFiendsburnImpact( object oTarget );


//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main( ){
    //standard entry block
    object      oPC         = OBJECT_SELF;
    object      oTarget     = GetSpellTargetObject( );
    location    lTarget     = GetSpellTargetLocation( );
    int         nSpell      = GetSpellId( );
    string      sPCKey      = GetName( GetPCKEY( oPC ) );

    //Precast code, this function also trigges the spellhook
    if( !X2PreSpellCastCode( ) ){
        return;
    }

    // Enter IF block for PCKEY check
    if( sPCKey == "QV6XVFD7_20071013230824"){
        switch( nSpell ){
            case DC_SPELL_R_5:
                GreaterHeroism( oPC, lTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "FFAF4AEA_20090423034315"){
        switch( nSpell ){
            case DC_SPELL_S_4:
                LesserLeyRecall( oPC );
                break;
            case DC_SPELL_R_3:
                AntiPyromanticCloud( oPC, lTarget );
                break;
            case DC_SPELL_R_9:
                Fiendsburn( oPC, oTarget );
                break;
            case DC_SPELL_S_9:
                VoxCelestia( oPC );
                break;
            case DC_SPELL_S_8:
                ShieldofPeace( oPC );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "VDKJR9RU_20081201071249" ){
        switch( nSpell ){
            case DC_SPELL_R_2:
                Barkskin( oPC, oTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "QVMDCTT6_20100118233856" ){
        switch( nSpell ){
            case DC_SPELL_S_1:
                Bless( oPC );
                break;
            case DC_SPELL_R_2:
                Barkskin( oPC, oTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "VDHHFAG6_20080111124435" ){
        switch( nSpell ){
            case DC_SPELL_R_8:
                CleansingMist( oPC, lTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "Q77FDRAN_20071208090203" ){
        switch( nSpell ){
            case DC_SPELL_S_6:
                EarthShield( oPC );
                break;
            case DC_SPELL_S_7:
                WindWalk( oPC, oTarget );
                break;
            case DC_SPELL_R_8:
                JungleOfThorns( oPC, lTarget );
                break;
            case DC_SPELL_R_9:
                DevouringEarth( oPC, lTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "QGMPP4J7_20100312130607" ){
        switch( nSpell ){
            case DC_SPELL_S_9:
                Sentinel( oPC );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "FTRWFQN4_20090104192309" ){
        switch( nSpell ){
            case DC_SPELL_R_2:
                ReadSchematicMain( oPC, oTarget );
                break;
            case DC_SPELL_S_4:
                LesserLeyRecall( oPC );
                break;
            case DC_SPELL_R_9:
                VortexOfIllFate( oPC, oTarget, lTarget );
                break;
            case DC_SPELL_S_9:
                TwistOfFate( oPC );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "QYUWTJA6_20101008214041" ){
        switch( nSpell ){
            case DC_SPELL_R_9:
                ParagonSlow( oPC, oTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "FT69YGWD_20081028200429" ){
        switch( nSpell ){
            case DC_SPELL_S_9:
                ArcaneStrike( oPC );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "QCRRAJ7F_20090723153708" ){
        switch( nSpell ){
            case DC_SPELL_S_6:
                DivineResilience( oPC );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "Q7RQ7F9T_20110802024042" ){
        switch( nSpell ){
            case DC_SPELL_R_9:
                BlackCoffin( oPC, oTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "QG6LM6W9_20090503102154" ){
        switch( nSpell ){
            case DC_SPELL_S_8:
                GhostlyVeil( oPC );
                break;
            case DC_SPELL_R_9:
                BlackCoffin( oPC, oTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "QGMPP4J7_20110429074804" ){
        switch( nSpell ){
            case DC_SPELL_R_7:
                Solipsism( oPC, oTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "QV4MWMW7_20111018064903" ){
        switch( nSpell ){
            case DC_SPELL_R_5:
                PersistantImage( oPC, lTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "VDHMQXFH_20100719152034" ){
        switch( nSpell ){
            case DC_SPELL_R_4:
                FreedomOfMovement( oPC, oTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "QV46DTHG_20100508174430" ){
        switch( nSpell ){
            case DC_SPELL_R_9:
                DracoBlast( oPC, lTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "FTML7Q4Q_20110704072553" ){
        switch( nSpell ){
            case DC_SPELL_S_8:
                LuminousCloud( oPC );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "QCRDTU4W_20110420195104" ){
        switch( nSpell ){
            case DC_SPELL_R_2:
                ReadSchematicMain( oPC, oTarget );
                break;
            case DC_SPELL_R_8:
                SkeletalDeliquescence( oPC, oTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "VDHJ3UTU_20110323022126" ){
        switch( nSpell ){
            case DC_SPELL_R_7:
                Foxfire( oPC, lTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "Q7RRKNYW_20110719024106" ){
        switch( nSpell ){
            case DC_SPELL_R_9:
                GreaterSandstorm( oPC, lTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else if( sPCKey == "QCRHRM3F_20120803114301" ) {
        switch( nSpell ){
            case DC_SPELL_R_8:
                IllusionaryPolymorph( oPC, oTarget );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "FTMCRGMY_20100104023815" ) {
        switch( nSpell ){
            case DC_SPELL_S_7:
                SurgeOfLunacy( oPC );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "FFUNHEU9_20120929184732" ) {
        switch( nSpell ){
            case DC_SPELL_R_5:
                DarknessInevitable( oPC, oTarget );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "QC4X9QYY_20071013212359" ) {
        switch( nSpell ){
            case DC_SPELL_S_8:
                Beatitudes( oPC );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "QGMP9NFF_20080320054855" ) {
        switch( nSpell ){
            case DC_SPELL_R_5:
                SpiritShield( oPC, oTarget );
                break;
            case DC_SPELL_R_9:
                Soothe( oPC, oTarget, lTarget );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "Q7KAHDJW_20130414154500" ) {
        switch( nSpell ){
            case DC_SPELL_R_3:
                EyesOfTheSandTracker( oPC, lTarget );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "QC7QX6DJ_20121207155013" ) {
        switch( nSpell ){
            case DC_SPELL_S_3:
                CupolaofAmplifiedSilence( oPC );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "QC76WY33_20110817235652" ) {
        switch( nSpell ){
            case DC_SPELL_R_7:
                SoulInfusion( oPC, oTarget );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "9WPY7TPQ_20091010134645" ) {
        switch( nSpell ){
            case DC_SPELL_S_1:
                SurgingSpite( oPC );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "QGM9X3V9_20091201141639" ) {
        switch( nSpell ){
            case DC_SPELL_R_7:
                ControlConstruct( oPC, oTarget );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "QLULPDQD_20110106112506" ) {
        switch( nSpell ){
            case DC_SPELL_R_4:
                WallofIce( oPC, oTarget );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "QV6PEUAM_20110424062312" ) {
        switch( nSpell ){
            case DC_SPELL_S_8:
                MassDeathWard( oPC );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "Q7736KPN_20130520043806" ) {
        switch( nSpell ){
            case DC_SPELL_S_5:
                Orcbane( oPC );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "QGMDEQHN_20130506071926" ) {
        switch( nSpell ){
            case DC_SPELL_R_9:
                EarthenGrasp( oPC, oTarget );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "Q77FDRAN_20071013212405" ) {
        switch( nSpell ){
            case DC_SPELL_S_5:
                PlanarAnchor( oPC );
                break;
           default:
                SendMessageToPC( oPC, "This spell does nothing!" );
       }
    }else if( sPCKey == "Q7RRL6CL_20120203141910" ){
        switch( nSpell ){
            case DC_SPELL_R_1:
                Antithetic( oPC, oTarget );
                break;
            case DC_SPELL_R_4:
                Ingenious( oPC, oTarget );
                break;
            case DC_SPELL_R_8:
                EdgeOfWilting( oPC, oTarget );
                break;
            default:
                SendMessageToPC( oPC, "This spell does nothing!" );
        }
    }else{
        SendMessageToPC( oPC, "This spell does nothing!" );
    }

}
void GreaterHeroism( object oPC, location lTarget ){
 if ( !TakeFeatUses( oPC, FEAT_BARD_SONGS, 1 ) ){

        return;
        }

        effect eVis = EffectVisualEffect(VFX_DUR_AURA_YELLOW);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        int nMetaMagic = GetMetaMagicFeat();
        effect eLink;
        eLink = EffectAttackIncrease(2);
        eLink = EffectLinkEffects(EffectSavingThrowIncrease(SAVING_THROW_ALL,2),eLink);
        eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_ALL_SKILLS,2),eLink);
        eLink = EffectLinkEffects(eVis,eLink);
        eLink = EffectLinkEffects(eDur,eLink);

        effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);
        effect eImpact2 = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
        int nDuration = GetCasterLevel(oPC);
        object oArea = GetArea(oPC);

        //Meta Magic check for extend
        if (nMetaMagic == METAMAGIC_EXTEND)
        {
            nDuration = nDuration *2;   //Duration is +100%
        }

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        object oTarget = GetFirstFactionMember(oPC,FALSE);
        //Cycle through the targets within the spell shape until an invalid object is captured or the number of
        //targets affected is equal to the caster level.
        while(GetIsObjectValid(oTarget))
        {
            //Make sure the member is in the same area
            if(GetArea(oTarget) == oArea)
            {
                float fDelay = GetRandomDelay(0.0, 1.0);
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oPC, DC_SPELL_R_5, FALSE));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact2, oTarget));
            }
            //Select the next target in the faction
            oTarget = GetNextFactionMember(oPC,FALSE);
        }
}

void AntiPyromanticCloud( object oPC, location lTarget ){
    //variable block
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOG_OF_BEWILDERMENT, "cs_fk_antipyro_a", "cs_fk_antipyro_c", "cs_fk_antipyro_b");
    int nDuration = GetCasterLevel(oPC) / 2;
    effect eImpact = EffectVisualEffect(191);
    //fire quick visual
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    if(nDuration < 1)
    {
        nDuration = 1;
    }

    //Apply the AOE object to the specified location
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

void Barkskin( object oPC, object oTarget ){
    // Pulled nearly identically from the Bioware Barkskin.

    //Declare major variables
    int nCasterLevel = GetCasterLevel( oPC );
    float fDuration  = NewHoursToSeconds( nCasterLevel );
    effect eVis      = EffectVisualEffect( VFX_DUR_PROT_BARKSKIN );
    effect eHead     = EffectVisualEffect( VFX_IMP_HEAD_NATURE );
    effect eDur      = EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE );
    effect eAC;
    int nBonus;

    //Signal spell cast at event
    SignalEvent( oTarget, EventSpellCastAt( oPC, SPELL_BARKSKIN, FALSE ) );

    //Determine AC Bonus based Level.
    if ( nCasterLevel <= 6 ) {

        nBonus = 3;
    }
    else{

        if ( nCasterLevel <= 12 ) {

            nBonus = 4;
        }
        else {

            nBonus = 5;
        }
    }

    //Make sure the Armor Bonus is of type Natural
    eAC          = EffectACIncrease( nBonus, AC_NATURAL_BONUS );
    effect eLink = EffectLinkEffects( eVis, eAC );
    eLink        = EffectLinkEffects( eLink, eDur );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eHead, oTarget );
}

void Bless( object oPC ){

    // Declare major variables.
    int nDuration   = 1 + GetCasterLevel( oPC );
    object oTarget;
    effect eVis = EffectVisualEffect( VFX_IMP_HEAD_HOLY );
    effect eDur = EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE );

    // Effects.
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    effect eAttack = EffectAttackIncrease(1);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);

    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eDur);

    float fDelay;

    // Apply Impact.
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oPC );

    //Get the first target in the radius around the caster
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            fDelay = GetRandomDelay(0.4, 1.1);
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLESS, FALSE));
            //Apply VFX impact and bonus effects
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration)));
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}

void CleansingMist( object oPC, location lTarget ){

    // Major variables.
    int     nCasterLvl  = GetCasterLevel( oPC );
    effect  eVFX1    = EffectVisualEffect( VFX_DUR_GLOW_WHITE );
    effect  eVFX2    = EffectVisualEffect( VFX_COM_HIT_SONIC );
    int     nDamage;
    float   fDelay;
    effect  eDam;
    int     nSpellDCBonus;

    // Limit caster level to 25.
    if ( nCasterLvl > 25 )
    {
        nCasterLvl = 25;
    }

    // Apply bonus DC from spell focuses.
    nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_NECROMANCY );

    // Create the base plc for all the other plc locations.
    object oMist;
    oMist = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_cle_mist", lTarget );
    DestroyObject( oMist, 4.0 );

    location lLocation;
    float fAngle;
    int x;

    // Create a circle of plcs around the base one.
    for ( x = 0; x < 9; x++ ) {
        lLocation   = GenerateNewLocationFromLocation( lTarget, 5.0, fAngle, 0.0 );
        oMist       = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_cle_mist", lLocation );
        fAngle      = fAngle + 45;
        DestroyObject( oMist, 4.0 );
    }

    // Gargantuan sphere shape. Cycle through all the targets.
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget );
    while ( GetIsObjectValid( oTarget ) )
    {
        // Get the distance between the effect and the PC to calculate a delay.
        fDelay = GetRandomDelay( 1.5, 2.5 );

        SignalEvent(oTarget, EventSpellCastAt(oPC, DC_SPELL_R_8));
        // Check for spell resistance, etc.
        if ( !MyResistSpell( OBJECT_SELF, oTarget, fDelay ) )
        {
            // Only works on undead.
            if( GetRacialType( oTarget ) == RACIAL_TYPE_UNDEAD && !GetIsReactionTypeFriendly( oTarget ) )
            {
                // Roll damage for each target. Will save against necromancy spell.
                nDamage = d8( nCasterLvl );
                if(MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC() + nSpellDCBonus, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                {
                    nDamage = nDamage / 2; // Halve the damage if they saved.
                }

                // Set the damage effect.
                eDam = EffectDamage( nDamage, DAMAGE_TYPE_POSITIVE );
                // Apply effects to the currently selected target.
                DelayCommand( fDelay + 1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget ) );
                DelayCommand( fDelay + 1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX1, oTarget, 2.0));
                DelayCommand( fDelay + 1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX2, oTarget) );
            }
        }
       // Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget);
    }
}

void WindWalk( object oPC, object oTarget ){

    // Declare major variables.
    int     nCL         = GetCasterLevel( oPC );
    int     nDuration   = 10+(nCL/6);

    int nMetaMagic = GetMetaMagicFeat();
    //Check for metamagic extension
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }

    effect  eSpeed      = EffectMovementSpeedIncrease( 90 );
    effect  eSanc       = EffectEthereal();
    effect  eHP         = EffectTemporaryHitpoints( nCL*5 );
    effect  eFail       = EffectSpellFailure( );
    effect  ePoly       = EffectPolymorph( 192 );
    effect  eVFX1       = EffectVisualEffect( VFX_DUR_GHOST_SMOKE );
    effect  eVFX2       = EffectVisualEffect( VFX_FNF_DISPEL_GREATER );

    // Link it all together.
    effect eLink = EffectLinkEffects( eVFX1, eSpeed );
    eLink = EffectLinkEffects( eSanc, eLink );
    eLink = EffectLinkEffects( eHP, eLink );
    eLink = EffectLinkEffects( eFail, eLink );
    eLink = EffectLinkEffects( ePoly, eLink );

    // Apply visual and effect.
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX2, GetLocation( oPC ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds( nDuration ) );
}

void Sentinel( object oPC ) {

    int     nDuration   = GetCasterLevel( oPC );
    effect  ePolymorph  = EffectPolymorph( 193 );
    effect  eVFX1       = EffectVisualEffect( 53 );
    effect  eVFX2       = EffectVisualEffect( VFX_FNF_MYSTICAL_EXPLOSION );

    // Apply visual and effect.
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX1, GetLocation( oPC ) );
    AssignCommand( oPC, PlaySound( "sff_summondrgn" ) );
    DelayCommand( 0.2, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX2, GetLocation( oPC ) ) );
    DelayCommand( 0.2, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePolymorph, oPC, TurnsToSeconds( nDuration ) ) );
}

void TwistOfFate( object oPC ) {

    int     nDuration   = GetCasterLevel( oPC );
    int     nPillar     = VFX_IMP_MAGICAL_VISION;
    effect  eVFX1       = EffectVisualEffect( VFX_IMP_DEATH_WARD );
    effect  eVFX2       = ExtraordinaryEffect( EffectVisualEffect( VFX_DUR_AURA_PULSE_BLUE_WHITE ) );

    if( GetLocalInt( oPC, "TwistOfFate" ) == 1 ) {
        FloatingTextStringOnCreature( "This magical effect is already active!", oPC, FALSE );
        return;
    }

    if( GetLocalInt( oPC, "TwistOfFateDelay" ) == 1 ) {
        FloatingTextStringOnCreature( "There is a 60 turn cooldown on this spell!", oPC, FALSE );
        return;
    }

    // Apply visual and effect.
    TLVFXPillar( nPillar, GetLocation( oPC ), 5, 0.1f,2.0f, 0.3f);
    DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC ) );
    DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX2, oPC, TurnsToSeconds( nDuration ) ) );

    SetLocalInt( oPC, "TwistOfFate", 1 );
    DelayCommand( TurnsToSeconds( 30 ), DeleteLocalInt( oPC, "TwistOfFate" ) );
    SetLocalInt( oPC, "TwistOfFate_Delay", 1 );
    DelayCommand( TurnsToSeconds( 60 ), DeleteLocalInt( oPC, "TwistOfFate_Delay" ) );
}

void ParagonSlow( object oPC, object oTarget ) {

    effect  eVFX1       = EffectVisualEffect( VFX_IMP_SLOW );
    effect  eVFX2       = EffectVisualEffect( VFX_FNF_TIME_STOP );

    effect  eDur        = EffectVisualEffect( VFX_DUR_FREEZE_ANIMATION );
    effect  eVis        = EffectVisualEffect( VFX_DUR_GLOBE_INVULNERABILITY );
    effect  eStop       = EffectCutsceneParalyze();
    effect  eSlow       = EffectSlow();

    int     nSpellDCBonus;
    int     nCasterLvl  = GetCasterLevel( oPC );

    // Checks to see if object is Creature
    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ) {
        SendMessageToPC( oPC, "You can't affect that!" );
        return;
    }

    nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_TRANSMUTATION );


    // Doesn't work on friendlies
    if( GetIsReactionTypeFriendly( oTarget ) ) {
        return;
    }

    effect eLink        = EffectLinkEffects( eDur, eVis );
           eLink        = EffectLinkEffects( eStop, eLink );

    SignalEvent(oTarget, EventSpellCastAt(oPC, DC_SPELL_R_9));

    //Make an SR check
    if (!MyResistSpell(oPC, oTarget))
    {
        if( MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC() + nSpellDCBonus, SAVING_THROW_TYPE_SPELL, OBJECT_SELF ) )
        {
            DelayCommand( 0.2, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oTarget ) );
            DelayCommand( 0.2, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds( nCasterLvl / 2 ) ) );
        }
        else
        {
            // Target fails save, it has visual effects applied.
            FloatingTextStringOnCreature( "- You find yourself encased in a time distortion, resulting in the time flow to pass over you as if you were not there! -", oTarget, FALSE );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oTarget );
            DelayCommand( 0.2, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oTarget ) );
            DelayCommand( 0.4, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oTarget ) );
            DelayCommand( 0.6, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget ) );

            DelayCommand( 0.6, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nCasterLvl / 2 ) ) );
        }
    }
}

void Fiendsburn( object oPC, object oTarget ) {

    int     nSpellDCBonus;
    int     nCasterLvl  = GetCasterLevel( oPC );
    int     nDamage     = d6( 10 );
    int     nDuration   = nCasterLvl / 5;
    effect  eDivineDmg;
    effect  eDaze       = EffectDazed();
    effect  eDur        = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MAJOR );
    effect  eVFX1       = EffectVisualEffect( VFX_FNF_STRIKE_HOLY );
    effect  eVFX2       = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );
    effect  eVFX3       = EffectVisualEffect( VFX_FNF_SUMMON_CELESTIAL );
    location lLocation;
    float   fAngle;

    // Checks to see if object is a creature
    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ) {
        SendMessageToPC( oPC, "You can't affect that!" );
        return;
    }

    // Doesn't work on friendlies
    if( GetIsReactionTypeFriendly( oTarget ) ) {
        return;
    }

    nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_CONJURATION );

    // Only works against True Fiends
    if ( GetRacialType( oTarget ) == RACIAL_TYPE_OUTSIDER &&
         GetAlignmentGoodEvil( oTarget ) == ALIGNMENT_EVIL &&
         !GetIsPC( oTarget ) ) {

         SignalEvent(oTarget, EventSpellCastAt(oPC, DC_SPELL_R_9));

        // Make a ranged touch attack
        if( TouchAttackRanged( oTarget, TRUE ) > 0 ) {

            //Make an SR check
            if ( !MyResistSpell( oPC, oTarget ) )
            {
                // Daze target if Fortitude failed
                if( !MySavingThrow( SAVING_THROW_FORT, oTarget, GetSpellSaveDC() + nSpellDCBonus, SAVING_THROW_TYPE_GOOD ) )
                {
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDaze, oTarget, 6.0 );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX2, oTarget, 6.0 );
                }

                // Apply damage
                eDivineDmg = EffectDamage( nDamage, DAMAGE_TYPE_DIVINE );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDivineDmg, oTarget );
                eDivineDmg = EffectDamage( nDamage / 2, DAMAGE_TYPE_DIVINE );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDivineDmg, oPC );

                // Play a circle of visuals at the target
                int x;
                for ( x = 0; x < 8; x++ ) {
                    lLocation   = GenerateNewLocationFromLocation( GetLocation( oTarget ), 2.5, fAngle, 0.0 );
                    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX1, lLocation );
                    fAngle      = fAngle + 45;
                }

                // Apply an instant visual
                ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX3, GetLocation( oTarget ) );

                // Apply DoT if not already there
                if( !GetLocalInt( oTarget, "FiendsburnDC" ) ) {
                    SetLocalInt( oTarget, "FiendsburnDC", GetSpellSaveDC() + nSpellDCBonus );
                    SetLocalInt( oTarget, "FiendsburnMaxDuration", nDuration );
                    SetLocalObject( oTarget, "FiendsburnCaster", oPC );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oTarget, 6.0 );
                    DelayCommand( 6.0, RunFiendsburnImpact( oTarget ) );
                }
            }
        }
    }
    else
    {
        SendMessageToPC( oPC, "This spell only affects True Fiends!" );
    }
}

void RunFiendsburnImpact( object oTarget )
{
    int     nDamage         = d6( 10 );
    int     nDC             = GetLocalInt( oTarget, "FiendsburnDC" );
    int     nDuration       = GetLocalInt( oTarget, "FiendsburnDuration" );
    int     nMaxDuration    = GetLocalInt( oTarget, "FiendsburnMaxDuration" );
    object  oPC             = GetLocalObject( oTarget, "FiendsburnCaster" );
    effect  eDur            = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MAJOR );
    effect  eVFX            = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );
    effect  eDivineDmg;
    effect  eDaze           = EffectDazed();

    // Stop if either target or PC dies
    if ( GetIsDead( oTarget ) == TRUE || GetIsDead( oPC ) == TRUE )
    {
        DeleteLocalInt( oTarget, "FiendsburnDC" );
        DeleteLocalInt( oTarget, "FiendsburnDuration" );
        DeleteLocalInt( oTarget, "FiendsburnMaxDuration" );
        DeleteLocalObject( oTarget, "FiendsburnCaster" );
        return;
    }

    // Stop if target moves out of range
    if( GetDistanceBetween( oPC, oTarget ) > 10.0 )
    {
        FloatingTextStringOnCreature( "* Target has moved out of range! *", oPC, FALSE );
        DeleteLocalInt( oTarget, "FiendsburnDC" );
        DeleteLocalInt( oTarget, "FiendsburnDuration" );
        DeleteLocalInt( oTarget, "FiendsburnMaxDuration" );
        DeleteLocalObject( oTarget, "FiendsburnCaster" );
        return;
    }

    SignalEvent(oTarget, EventSpellCastAt(oPC, DC_SPELL_R_9));

    int nAction = GetCurrentAction( oPC );
    // Caster doing anything that requires attention and breaks concentration.
    if ( nAction == ACTION_DISABLETRAP || nAction == ACTION_TAUNT
        || nAction == ACTION_PICKPOCKET || nAction ==ACTION_ATTACKOBJECT
        || nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP
        || nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL )
    {
        FloatingTextStringOnCreature( "* Concentration broken, spell ceases! *", oPC, FALSE );
        DeleteLocalInt( oTarget, "FiendsburnDC" );
        DeleteLocalInt( oTarget, "FiendsburnDuration" );
        DeleteLocalInt( oTarget, "FiendsburnMaxDuration" );
        DeleteLocalObject( oTarget, "FiendsburnCaster" );
        return;
    }

    // Daze if target failed Fortitude
    if( !MySavingThrow( SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_GOOD ) )
    {
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDaze, oTarget, 6.0 );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX, oTarget, 6.0 );
    }

    // Apply damage
    eDivineDmg = EffectDamage( nDamage, DAMAGE_TYPE_DIVINE );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDivineDmg, oTarget );
    eDivineDmg = EffectDamage( nDamage / 2, DAMAGE_TYPE_DIVINE );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDivineDmg, oPC );

    // Lasts a maximum of caster level divided by 5 rounds
    if( nDuration >= nMaxDuration )
    {
        DeleteLocalInt( oTarget, "FiendsburnDC" );
        DeleteLocalInt( oTarget, "FiendsburnDuration" );
        DeleteLocalInt( oTarget, "FiendsburnMaxDuration" );
        DeleteLocalObject( oTarget, "FiendsburnCaster" );
        return;
    }
    else
    {
        // Do this again in another round
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oTarget, 6.0 );
        nDuration = nDuration + 1;
        SetLocalInt( oTarget, "FiendsburnDuration", nDuration );
        DelayCommand( 6.0, RunFiendsburnImpact( oTarget ) );
    }
}

void ArcaneStrike( object oPC ) {

    int     nDamage     = DAMAGE_BONUS_5;
    effect  eVFX1       = EffectVisualEffect( VFX_IMP_GOOD_HELP );
    effect  eVFX2       = EffectVisualEffect( VFX_IMP_PULSE_HOLY );
    effect  eVFX3       = EffectVisualEffect( VFX_DUR_IOUNSTONE_YELLOW );

    effect  eAB         = EffectAttackIncrease( 9 );
    effect  eDamage     = EffectDamageIncrease( nDamage, DAMAGE_TYPE_MAGICAL );

    // prevent stacking with self
    if (GetHasSpellEffect(GetSpellId()))
    {
        RemoveEffectsFromSpell( oPC, GetSpellId() );
    }

    effect eLink = EffectLinkEffects( eDamage, eAB );
    eLink = EffectLinkEffects( eVFX3, eLink );

    // Apply visual and effect.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );
    DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oPC ) );
    DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds( 1 ) ) );
}

void DivineResilience( object oPC ) {

    effect  eVFX1       = EffectVisualEffect( VFX_FNF_SUMMON_CELESTIAL );
    effect  eVFX2       = EffectVisualEffect( VFX_IMP_PULSE_HOLY );
    effect  eVFX3       = EffectVisualEffect( VFX_DUR_GLOBE_MINOR );

    effect  eSaves      = EffectSavingThrowIncrease( SAVING_THROW_ALL, 5 );

    int     nDuration   = GetCasterLevel( oPC ) / 2;

    // prevent stacking with self
    if (GetHasSpellEffect(GetSpellId()))
    {
        RemoveEffectsFromSpell( oPC, GetSpellId() );
    }

    effect eLink = EffectLinkEffects( eSaves, eVFX3 );

    // Apply visual and effect.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );
    DelayCommand( 2.8, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oPC ) );
    DelayCommand( 2.9, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds( nDuration ) ) );
}

void BlackCoffin( object oPC, object oTarget ) {

    int     nCasterLvl  = GetCasterLevel( oPC );
    int     nDamage     = d6( 2 ) + 12;
    int     nDuration   = nCasterLvl;
    effect  eDamage;
    effect  eParalyze   = EffectParalyze();
    effect  eDur        = EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR );
    effect  eDur2       = EffectVisualEffect( VFX_DUR_AURA_PULSE_PURPLE_BLACK );
    effect  eVFX1       = EffectVisualEffect( VFX_FNF_LOS_EVIL_20 );
    effect  eVFX2       = EffectVisualEffect( VFX_IMP_PULSE_NEGATIVE );
    effect  eLink;
    object  oCoffin;
    object  oSparks;
    vector  vDown       = Vector( 0.0, 0.0, -0.15 );
    vector  vOrigin     = GetPositionFromLocation( GetLocation( oTarget ) );
    location lLocation  = Location( GetArea( oTarget ), vOrigin + vDown, GetFacing( oPC ) );

    // Starting visual
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oTarget );

    // Checks to see if object is a creature
    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ) {
        SendMessageToPC( oPC, "You can't affect that!" );
        return;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(oPC, DC_SPELL_R_9));
        //SR
        if( !MyResistSpell( OBJECT_SELF, oTarget ) )
        {
            int nCasterModifier = GetCasterAbilityModifier( OBJECT_SELF );
            int nCasterRoll = d20(1) + nCasterModifier + GetCasterLevel( OBJECT_SELF ) + 12 + -1;
            int nTargetRoll = GetAC( oTarget );

            // * grapple HIT succesful,
            if ( nCasterRoll >= nTargetRoll )
            {
                // * now must make a GRAPPLE check
                // * hold target for duration of spell

                nCasterRoll = d20( 1 ) + nCasterModifier + GetCasterLevel(OBJECT_SELF) + 12 + 4;
                nTargetRoll = d20( 1 ) + GetBaseAttackBonus( oTarget ) + GetSizeModifier( oTarget ) + GetAbilityModifier( ABILITY_STRENGTH, oTarget );

                if ( nCasterRoll >= nTargetRoll )
                {
                    // creatures immune to paralzation are still prevented from moving
                    if (GetIsImmune( oTarget, IMMUNITY_TYPE_PARALYSIS) || GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS ) )
                    {
                        eParalyze = EffectCutsceneImmobilize();
                    }

                    eDamage = EffectDamage( nDamage, DAMAGE_TYPE_NEGATIVE );
                    eLink = EffectLinkEffects( eDur, eParalyze );
                    eLink = EffectLinkEffects( eDur2, eLink );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );

                    // Apply DoT if not already there
                    if( !GetLocalInt( oTarget, "CoffinMaxDuration" ) ) {

                        SetLocalInt( oTarget, "CoffinMaxDuration", nDuration );
                        SetLocalObject( oTarget, "CoffinCaster", oPC );

                        // Apply damage
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0 );

                        if ( GetIsDead( oTarget ) == FALSE )
                        {
                            oCoffin = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_bla_coff", lLocation );
                            CreateObject( OBJECT_TYPE_PLACEABLE, "cus_bla_coff_spa", GetLocation( oCoffin ) );

                            DelayCommand( 1.0, AssignCommand( oCoffin, ActionPlayAnimation( ANIMATION_PLACEABLE_OPEN ) ) );
                            DelayCommand( 4.0, AssignCommand( oCoffin, ActionPlayAnimation( ANIMATION_PLACEABLE_CLOSE ) ) );
                            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eDur, oCoffin );

                            // Apply DoT
                            DelayCommand( 6.0, RunBlackCoffinImpact( oTarget ) );
                       }
                    }

                }
                else
                {
                    FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
                }
            }
        }
    }
}

void RunBlackCoffinImpact( object oTarget )
{
    int     nDamage         = d6( 2 ) + 12;
    int     nDuration       = GetLocalInt( oTarget, "CoffinDuration" );
    int     nMaxDuration    = GetLocalInt( oTarget, "CoffinMaxDuration" );
    int     nSpellActive    = 0;
    object  oCoffin         = GetNearestObjectByTag( "cus_bla_coff", oTarget );
    object  oSparks         = GetNearestObjectByTag( "cus_bla_coff_spa", oTarget );
    object  oPC             = GetLocalObject( oTarget, "CoffinCaster" );
    effect  eDur            = EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR );
    effect  eDur2           = EffectVisualEffect( VFX_DUR_AURA_PULSE_PURPLE_BLACK );
    effect  eDamage;
    effect  eParalyze       = EffectParalyze();

    int nAction = GetCurrentAction( oPC );
    // Caster doing anything that requires attention and breaks concentration.
    if ( nAction == ACTION_DISABLETRAP || nAction == ACTION_TAUNT
        || nAction == ACTION_PICKPOCKET || nAction ==ACTION_ATTACKOBJECT
        || nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP
        || nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL )
    {
        FloatingTextStringOnCreature( "* Concentration broken, spell ceases! *", oPC, FALSE );
        DeleteLocalInt( oTarget, "CoffinDuration" );
        DeleteLocalInt( oTarget, "CoffinMaxDuration" );
        DeleteLocalObject( oTarget, "CoffinCaster" );
        DestroyObject( oCoffin, 0.1 );
        DestroyObject( oSparks, 0.1 );
        return;
    }

    SignalEvent(oTarget, EventSpellCastAt(oPC, DC_SPELL_R_9));

    effect eBad = GetFirstEffect( oTarget );
    //Search for negative effects
    while( GetIsEffectValid( eBad ) )
    {
        if (GetEffectType(eBad) == EFFECT_TYPE_PARALYZE )
        {
            nSpellActive = 1;
        }
        eBad = GetNextEffect(oTarget);
    }

    if( GetAbilityScore( oTarget, ABILITY_DEXTERITY ) == 3 )
    {
        nSpellActive = 1;
    }

    if( nSpellActive == 0 )
    {
        DeleteLocalInt( oTarget, "CoffinDuration" );
        DeleteLocalInt( oTarget, "CoffinMaxDuration" );
        DeleteLocalObject( oTarget, "CoffinCaster" );
        DestroyObject( oCoffin, 0.1 );
        DestroyObject( oSparks, 0.1 );
        return;
    }

    // creatures immune to paralzation are still prevented from moving
    if (GetIsImmune( oTarget, IMMUNITY_TYPE_PARALYSIS) || GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS ) )
    {
        eParalyze = EffectCutsceneImmobilize();
    }

    eDamage = EffectDamage( nDamage, DAMAGE_TYPE_NEGATIVE );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );

    // Stop if either target or PC dies
    if ( GetIsDead( oTarget ) == TRUE || GetIsDead( oPC ) == TRUE )
    {
        DeleteLocalInt( oTarget, "CoffinDuration" );
        DeleteLocalInt( oTarget, "CoffinMaxDuration" );
        DeleteLocalObject( oTarget, "CoffinCaster" );
        DestroyObject( oCoffin, 0.1 );
        DestroyObject( oSparks, 0.1 );
        return;
    }

    effect eLink = EffectLinkEffects( eDur, eParalyze );
    eLink = EffectLinkEffects( eDur2, eLink );

    // Lasts a maximum of caster level
    if( nDuration >= nMaxDuration )
    {
        DeleteLocalInt( oTarget, "CoffinDuration" );
        DeleteLocalInt( oTarget, "CoffinMaxDuration" );
        DeleteLocalObject( oTarget, "CoffinCaster" );
        DestroyObject( oCoffin, 0.1 );
        DestroyObject( oSparks, 0.1 );
        return;
    }
    else
    {
        // Do this again in another round
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0 );
        nDuration = nDuration + 1;
        SetLocalInt( oTarget, "CoffinDuration", nDuration );
        DelayCommand( 6.0, RunBlackCoffinImpact( oTarget ) );
    }
}

void Solipsism( object oPC, object oTarget )
{
    effect  eVFX1       = EffectVisualEffect( VFX_IMP_CHARM );
    effect  eVFX2       = EffectVisualEffect( VFX_IMP_WILL_SAVING_THROW_USE );

    effect  eDur        = EffectVisualEffect( VFX_DUR_GHOST_SMOKE_2 );
    effect  eStop       = EffectCutsceneParalyze();

    int     nSpellDCBonus;
    int     nCasterLvl  = GetCasterLevel( oPC );

    int nMetaMagic = GetMetaMagicFeat();
    //Check for metamagic extension
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nCasterLvl = nCasterLvl * 2;  //Duration is +100%
    }

    // Checks to see if object is Creature
    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ) {
        SendMessageToPC( oPC, "You can't affect that!" );
        return;
    }

    nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_ILLUSION);


    // Doesn't work on friendlies
    if( GetIsReactionTypeFriendly( oTarget ) ) {
        return;
    }

    SignalEvent(oTarget, EventSpellCastAt(oPC, DC_SPELL_R_9));

    effect eLink        = EffectLinkEffects( eDur, eStop );

    //Make an SR check
    if (!MyResistSpell(oPC, oTarget))
    {
        if ( GetIsImmune( oTarget, IMMUNITY_TYPE_MIND_SPELLS ) )
        {
            SendMessageToPC( oPC, "Target is immune to spell." );
            return;
        }
        if( MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC() + nSpellDCBonus, SAVING_THROW_TYPE_SPELL, OBJECT_SELF ) )
        {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );
        }
        else
        {
            // Target fails save, it has visual effects applied.
            FloatingTextStringOnCreature( "- Pangs of loneliness grip you as you feel as if you are the only thing in existence. Nothing besides you is real: neither your surroundings nor your pain exist, so you simply stand there... existing. -", oTarget, FALSE );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oTarget );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nCasterLvl ) );
        }
    }
}

void GhostlyVeil( object oPC )
{
    effect  eVFX1       = EffectVisualEffect( VFX_IMP_DEATH_L );
    effect  eVFX2       = EffectVisualEffect( VFX_DUR_DEATH_ARMOR );
    effect  eVFX3       = EffectVisualEffect( VFX_DUR_PROTECTION_EVIL_MAJOR );

    effect  eBonus1     = EffectConcealment( 50 );
    effect  eBonus2     = EffectImmunity( IMMUNITY_TYPE_MIND_SPELLS );
    effect  eBonus3     = EffectDamageImmunityIncrease( DAMAGE_TYPE_NEGATIVE, 100 );
    effect  eBonus4     = EffectDamageImmunityDecrease( DAMAGE_TYPE_POSITIVE, 50 );
    effect  eBonus5     = EffectImmunity( IMMUNITY_TYPE_NEGATIVE_LEVEL );
    effect  eBonus6     = EffectImmunity( IMMUNITY_TYPE_ABILITY_DECREASE );

    int     nPMLevel    = GetLevelByClass( CLASS_TYPE_PALEMASTER, oPC );
    int     nDuration   = GetCasterLevel( oPC ) + nPMLevel;

    // prevent stacking with self
    if (GetHasSpellEffect(GetSpellId()))
    {
        RemoveEffectsFromSpell( oPC, GetSpellId() );
    }

    effect eLink = EffectLinkEffects( eBonus1, eBonus2 );
           eLink = EffectLinkEffects( eBonus3, eLink );
           eLink = EffectLinkEffects( eBonus4, eLink );
           eLink = EffectLinkEffects( eBonus5, eLink );
           eLink = EffectLinkEffects( eBonus6, eLink );
           eLink = EffectLinkEffects( eVFX2, eLink );
           eLink = EffectLinkEffects( eVFX3, eLink );

    SetLocalInt( oPC, "ghostly_drown_immune", 1 );

    // Apply visual and effect.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds( nDuration ) );
    DelayCommand( TurnsToSeconds( nDuration ), DeleteLocalInt( oPC, "ghostly_drown_immune" ) );
}

void PersistantImage( object oPC, location lTarget ) {

    effect  eVFX        = EffectVisualEffect( VFX_FNF_SMOKE_PUFF );
    effect  eStop       = EffectCutsceneParalyze();
    int     x           = 1;
    int     nDuration   = GetCasterLevel( oPC );
    object  oTarget;
    object  oImage;
    object  oItem;

    // Get the nearest placeable or creature
    oTarget = GetNearestObjectToLocation( OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE, lTarget, 1 );

    // Destroy object if it's created via this spell
    if( GetTag( oTarget ) == "persist_image" )
    {
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX, GetLocation( oTarget ) );
        SafeDestroyObject( oTarget );
        return;
    }

    // Determine whether it's a placeable or creature being copied
    if( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE )
    {
        // Copy away!
        oImage = CopyObjectFixed( oTarget, GetLocation( oTarget ), OBJECT_INVALID, "persist_image" );

        // To prevent XP, gold and loot generation
        SetLocalInt( oImage, "AI_INTEGER_I_AM_TOTALLY_DEAD", 1 );
        SetLocalInt( oImage, "ds_ai_dead", 1 );

        // Better make sure they don't drop their inventory, either
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_ARMS, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_ARROWS, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_BELT, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_BOLTS, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_BOOTS, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_BULLETS, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_CARMOUR, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_CHEST, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_CLOAK, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_CWEAPON_B, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_CWEAPON_L, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_HEAD, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_LEFTRING, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_NECK, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oImage ), FALSE );
        SetDroppableFlag( GetItemInSlot( INVENTORY_SLOT_RIGHTRING, oImage ), FALSE );

        // Tweak some things to make it behave better...
        ChangeToStandardFaction( oImage, STANDARD_FACTION_HOSTILE );
        SetImmortal( oImage, FALSE );
        SetPlotFlag( oImage, FALSE );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eStop, oImage );
    }
    else if( GetObjectType( oTarget ) == OBJECT_TYPE_PLACEABLE )
    {
        // Copy away!
        oImage = CreateObject( OBJECT_TYPE_PLACEABLE, GetResRef( oTarget ), GenerateNewLocationFromLocation( GetLocation( oTarget ), 2.5, 0.0, GetFacing( oTarget ) ), FALSE, "persist_image" );

        SetPlotFlag( oImage, FALSE );

        // Exploit prevention for placeables with an inventory.
        if( GetHasInventory( oImage ) )
        {
            SetUseableFlag( oImage, FALSE );
            SetPlotFlag( oImage, TRUE );
        }
    }

    // Make sure it doesn't have an inventory
    oItem = GetFirstItemInInventory( oImage );
    while ( GetIsObjectValid( oItem ) )
    {
        DestroyObject( oItem );
        oItem = GetNextItemInInventory( oImage );
    }

    // Remove any gold, too!
    ds_take_item( oImage, "NW_IT_GOLD001" );
    TakeGoldFromCreature( 100000000, oImage, TRUE );

    // More tweaking... it's meant to have 1-3 HP, no more.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetCurrentHitPoints( oImage ) - d3(), DAMAGE_TYPE_MAGICAL ), oImage );

    // Delete it after the spell duration is over
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX, GetLocation( oImage ) );
    DelayCommand( TurnsToSeconds( nDuration ) - 0.5, SetPlotFlag( oImage, FALSE ) );
    DelayCommand( TurnsToSeconds( nDuration ), SafeDestroyObject( oImage ) );
}

void FreedomOfMovement( object oPC, object oTarget ) {

    // Just stolen the regular Freedom spell script
    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(oPC);
    effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
    effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
    effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
    effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
    effect eVis = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Link effects
    effect eLink = EffectLinkEffects(eParal, eEntangle);
    eLink = EffectLinkEffects(eLink, eSlow);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eMove);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FREEDOM_OF_MOVEMENT, FALSE));

    //Search for and remove the above negative effects
    effect eLook = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eLook))
    {
        if(GetEffectType(eLook) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eLook) == EFFECT_TYPE_ENTANGLE ||
            GetEffectType(eLook) == EFFECT_TYPE_SLOW ||
            GetEffectType(eLook) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
        {
            RemoveEffect(oTarget, eLook);
        }
        eLook = GetNextEffect(oTarget);
    }
    //Meta-Magic Checks
    if(nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }
    //Apply Linked Effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}

void JungleOfThorns( object oPC, location lTarget ) {

    // Variables.
    int nCasterLevel    = GetCasterLevel( oPC );
    float fDuration     = RoundsToSeconds( nCasterLevel );

    // Used for spawning placeables.
    location lLocation;
    float fAngle;
    float fOrient       = IntToFloat( Random( 359 ) + 1 ); // Random angles on thorns
    object oArea        = GetAreaFromLocation(lTarget);
    vector vNewPos;

    // Create the center placeable. This is used for future location calculations.
    object oStorm = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_jun_thorns_2", lTarget );
    DestroyObject( oStorm, fDuration );

    int x;

    // Create a whole bunch of placeables to give the impression of a jungle.
    // Couldn't use GenerateNewLocationFromLocation for this because I needed to fiddle with their Z axis.
    // Not sure if I need to trim down how many placeables this spawns, for lag reasons... will give it some testing.
    // Look at all those for loops!
    for ( x = 0; x < 9; x++ )
    {
        vNewPos         = GetChangedPosition( GetPositionFromLocation(lTarget), 5.0, fAngle );
        lLocation       = Location( oArea, Vector( vNewPos.x, vNewPos.y, vNewPos.z + -1.00 ), fOrient );
        oStorm          = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_jun_thorns", lLocation );
        fAngle          = fAngle + 45;
        fOrient         = IntToFloat( Random( 359 ) + 1 );
        DestroyObject( oStorm, fDuration );
    }

    for ( x = 0; x < 9; x++ )
    {
        vNewPos         = GetChangedPosition( GetPositionFromLocation(lTarget), 3.0, fAngle );
        lLocation       = Location( oArea, Vector( vNewPos.x, vNewPos.y, vNewPos.z + -1.00 ), fOrient );
        oStorm          = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_jun_thorns", lLocation );
        fAngle          = fAngle + 45;
        fOrient         = IntToFloat( Random( 359 ) + 1 );
        DestroyObject( oStorm, fDuration );
    }

    for ( x = 0; x < 9; x++ )
    {
        vNewPos         = GetChangedPosition( GetPositionFromLocation(lTarget), 4.0, fAngle );
        lLocation       = Location( oArea, Vector( vNewPos.x, vNewPos.y, vNewPos.z + -0.50 ), fOrient );
        oStorm          = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_jun_thorns_2", lLocation );
        fAngle          = fAngle + 45;
        fOrient         = IntToFloat( Random( 359 ) + 1 );
        DestroyObject( oStorm, fDuration );
    }

    for ( x = 0; x < 9; x++ )
    {
        vNewPos         = GetChangedPosition( GetPositionFromLocation(lTarget), 2.0, fAngle );
        lLocation       = Location( oArea, Vector( vNewPos.x, vNewPos.y, vNewPos.z + -0.50 ), fOrient );
        oStorm          = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_jun_thorns_2", lLocation );
        fAngle          = fAngle + 45;
        fOrient         = IntToFloat( Random( 359 ) + 1 );
        DestroyObject( oStorm, fDuration );
    }

    // Create the area of effect
    effect eAOE         = EffectAreaOfEffect(AOE_PER_ENTANGLE, "cs_thorns_a", "cs_thorns_b", "cs_thorns_c");
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration );
}

void DracoBlast( object oPC, location lTarget ) {

    // Variables.
    object   oCaster      = oPC;
    int      nLevel       = GetCasterLevel( oCaster );
    int      nDC          = GetSpellSaveDC();
    int      nDamage;
    int      nHP;
    effect   eDur         = EffectVisualEffect( 498 );
    effect   ePCDamage    = EffectDamage( 20, DAMAGE_TYPE_FIRE);
    float    fDuration    = 12.0;
    effect   eDam;
    float    fDelay;
    float    fAngle;
    object   oFire;
    object   oScorch;
    location lLocation;
    int      x;

    // Caster takes initial damage.
    ApplyEffectToObject(DURATION_TYPE_INSTANT, ePCDamage, oCaster);

    // Create the center fire placeable.
    oFire   = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_flamemedium", lTarget );
    oScorch = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_weathmark", lTarget );
    DestroyObject( oFire, fDuration );
    DestroyObject( oScorch, fDuration * 10 );

    // Create a circle of plcs around the base one.
    for ( x = 0; x < 3; x++ ) {
        lLocation   = GenerateNewLocationFromLocation( lTarget, 3.0, fAngle, 0.0 );
        oFire       = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_flamemedium", lLocation );
        oScorch     = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_weathmark", lLocation );
        fAngle      = fAngle + 80 + Random(100);
        DestroyObject( oFire, fDuration );
        DestroyObject( oScorch, fDuration * 10 );
    }

    // Fireball visual.
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_FIREBALL ), lTarget );
    // Play a circle of visuals at the target
    for ( x = 0; x < 8; x++ ) {
        lLocation   = GenerateNewLocationFromLocation( lTarget, 2.0, fAngle, 0.0 );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PULSE_FIRE ), lLocation );
        fAngle      = fAngle + 45;
    }


    // Get first target in spell area.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
    while(GetIsObjectValid(oTarget)) {

        // Only affect hostiles.
        if(GetIsReactionTypeHostile(oTarget, oCaster)) {

            SignalEvent(oTarget, EventSpellCastAt(oPC, DC_SPELL_R_9));

            // Make SR check.
            if(!MyResistSpell(oCaster, oTarget)) {

                nDamage = d8( 20 );
                fDelay  = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                nHP     = GetCurrentHitPoints( oTarget );

                // Make a reflex saving throw.
                if( MySavingThrow( SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE ) ) {

                    // With evasion on success, damage is zero.
                    if ( GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget) )
                    {
                        nDamage = 0;
                    }
                    else
                    {
                       nDamage = nDamage / 2;
                    }

                    // Apply VFX and damage.
                    eDam    = EffectDamage( nDamage, DAMAGE_TYPE_FIRE );
                    DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget ) );
                    DelayCommand( fDelay, TLVFXPillar(VFX_IMP_FLAME_M, GetLocation(oTarget), 5, 0.1f,0.0f, 2.0f) );
                }
                else
                {
                    // With imp evasion on fail, damage is halved.
                    if ( GetHasFeat(FEAT_IMPROVED_EVASION, oTarget) ) {

                        nDamage = nDamage / 2;
                    }

                    // Apply VFX and initial damage.
                    eDam    = EffectDamage( nDamage, DAMAGE_TYPE_FIRE );
                    DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget) );
                    DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oTarget, 6.0 ));
                    DelayCommand( fDelay, TLVFXPillar(VFX_IMP_FLAME_M, GetLocation(oTarget), 5, 0.1f,0.0f, 2.0f));

                    DelayCommand( fDelay + 0.1, DracoBlastDeath( oTarget, nDC, nHP ) );
                }
            }
        }
        //Get next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
    }
}

void DracoBlastImpact( object oTarget )
{
    // Stop if they die
    if ( GetIsDead( oTarget ) == FALSE )
    {
        // Get the DC off the victim
        int     nDC      = GetLocalInt( oTarget, "DracoSpellDC" );
        effect  eDur     = EffectVisualEffect( 498 );

        if( !MySavingThrow( SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE ) ) {
            int    nDamage  = d6( 2 );
            effect eDmg     = EffectDamage(nDamage,DAMAGE_TYPE_FIRE);

            // Apply damage if reflex failed
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDmg, oTarget );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oTarget, 6.0 );

            // Do this again in another round
            DelayCommand( 6.0, DracoBlastImpact( oTarget ) );

        } else {

            // They saved, finish up spell
            DeleteLocalInt( oTarget, "DracoSpellDC" );
        }
    }
}

void DracoBlastDeath( object oTarget, int nDC, int nHP )
{
    effect   eDeath       = EffectDeath();
    eDeath                = SupernaturalEffect( eDeath );
    effect   eDeathVFX    = EffectVisualEffect(VFX_IMP_DEATH);

    if(nHP > GetCurrentHitPoints( oTarget ) )
    {
        // Make a fort save vs death
        if( MySavingThrow( SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH ) ) {

            // If they make the save, pass the DC to the impact function.
            SetLocalInt(oTarget,"DracoSpellDC", nDC);

            // And set the looped damage to run in one round.
            DelayCommand(6.0, DracoBlastImpact( oTarget ));
        }
        else
        {
            // If they fail, KEEEL them!
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeathVFX, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
        }
    }
}

void LuminousCloud( object oPC ) {

    // Variables.
    int     nLevel      = GetCasterLevel( oPC );
    float   fDuration   = RoundsToSeconds( nLevel );
    int     nMetaMagic  = GetMetaMagicFeat();
    effect  eAOEVFX     = EffectVisualEffect( VFX_DUR_AURA_COLD );
    effect  eAOE        = EffectAreaOfEffect( AOE_MOB_FROST, "cs_lumcloud_a", "cs_lumcloud_c", "cs_lumcloud_b" );
    effect  eLink       = EffectLinkEffects( eAOE, eAOEVFX );

    // Metamagic check for extend spell.
    if (nMetaMagic == METAMAGIC_EXTEND) {
        fDuration = fDuration * 2.0;   //Duration is +100%
    }

    // Prevent stacking.
    if ( GetIsBlocked( oPC, "luminous_cloud" ) > 0 ) {
        FloatingTextStringOnCreature( "This ability is already active! ", oPC, FALSE );
        return;
    }

    // !!DEBUG!!
    SendMessageToPC( oPC, IntToString( nLevel ) + " caster level and a duration in seconds of " + FloatToString( fDuration ) );

    // Apply the VFX and aura.
    eLink = ExtraordinaryEffect( eLink );
    DelayCommand( 0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration ) );

    // Set stackage prevention time.
    SetBlockTime( oPC, 0, FloatToInt(fDuration), "luminous_cloud" );
}


void VortexOfIllFate( object oPC, object oTarget, location lTarget ) {

    // General integers used for calculations.
    int     nSpellDCBonus;
    int     nCasterLvl  = GetCasterLevel( oPC );
    int     nDamage     = d6( 10 );
    int     x;

    // Used to generate the visuals properly floating in the air, and not on the ground.
    float fAngle;
    object oArea        = GetAreaFromLocation(lTarget);
    vector vNewPos;

    // Biiig bunch of effect variables... all declared here to save time later on.
    effect  eEffect1;
    effect  eEffect2;

    effect  eEffect1VFX;
    effect  eEffect2VFX;

    int     nEffect1;

    effect  eDamage     = EffectDamage( d6(10), DAMAGE_TYPE_MAGICAL );
    effect  eConfuse    = EffectConfused();
    effect  eStun       = EffectStunned();
    effect  eFear       = EffectFrightened();

    effect  eDeath      = EffectDeath( FALSE, TRUE );
            eDeath      = SupernaturalEffect( eDeath );

    effect  eGouge1     = EffectKnockdown();
    effect  eGouge2     = EffectBlindness();
    effect  eGouge3     = EffectDamage( d6(15), DAMAGE_TYPE_PIERCING );

    effect  eGouge      = EffectLinkEffects( eGouge1, eGouge2 );
            eGouge      = EffectLinkEffects( eGouge3, eGouge );

    effect  eCurse1     = EffectACDecrease( 4 );
    effect  eCurse2     = EffectCurse(2, 2, 2, 2, 2, 2);
    effect  eCurse3     = EffectAttackDecrease( 2 );

    effect  eCurse      = EffectLinkEffects( eCurse1, eCurse2 );
            eCurse      = EffectLinkEffects( eCurse3, eCurse );

    effect  eVFX1       = EffectVisualEffect( VFX_IMP_PULSE_WIND );
    effect  eVFX2       = EffectVisualEffect( VFX_IMP_REDUCE_ABILITY_SCORE );
    effect  eVFX3       = EffectVisualEffect( VFX_IMP_MAGICAL_VISION );
    effect  eVFX4       = EffectVisualEffect( VFX_FNF_PWSTUN );

    location lLocation;

    // Doesn't work on friendlies
    if( GetIsReactionTypeFriendly( oTarget ) ) {
        return;
    }

    nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_DIVINATION );

    // Display a ring of variables
    for ( x = 0; x < 9; x++ )
    {
        vNewPos         = GetChangedPosition( GetPositionFromLocation(lTarget), 5.0, fAngle );
        lLocation       = Location( oArea, Vector( vNewPos.x, vNewPos.y, vNewPos.z + 1.00 ), 0.0 );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX3, lLocation );
        fAngle          = fAngle + 45;
    }

    // Checks to see if object is a creature
    if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE )
    {
        SignalEvent(oTarget, EventSpellCastAt(oPC, DC_SPELL_R_9));

        // Make SR check.
        if(!MyResistSpell(oPC, oTarget))
        {
            // Will save
            if( MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC() + nSpellDCBonus, SAVING_THROW_TYPE_SPELL, OBJECT_SELF ) )
            {
                 // prevent stacking with self
                if (GetHasSpellEffect(GetSpellId()))
                {
                    RemoveEffectsFromSpell( oPC, GetSpellId() );
                }
                DelayCommand( 0.8, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget ) );
                DelayCommand( 0.8, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eCurse, oTarget, RoundsToSeconds( nCasterLvl ) ) );
            }
            else
            {
                // Random effects between six
                x = d6();

                switch( x ) {
                    case 1:
                        eEffect1 = eDamage;
                        eEffect1VFX = EffectVisualEffect( VFX_NONE );
                        nEffect1 = 1;
                        break;
                    case 2:
                        eEffect1 = eConfuse;
                        eEffect1VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );
                        nEffect1 = 2;
                        break;
                    case 3:
                        eEffect1 = eStun;
                        eEffect1VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_NEGATIVE );
                        nEffect1 = 3;
                        break;
                    case 4:
                        eEffect1 = eFear;
                        eEffect1VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR );
                        nEffect1 = 4;
                        break;
                    case 5:
                        eEffect1 = eGouge;
                        eEffect1VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );
                        nEffect1 = 5;
                        break;
                    case 6:
                        eEffect1 = eDeath;
                        eEffect1VFX = EffectVisualEffect( VFX_IMP_DEATH );
                        nEffect1 = 6;
                        break;
                    default:
                        eEffect1 = eDamage;
                        eEffect1VFX = EffectVisualEffect( VFX_NONE );
                        nEffect1 = 1;
                }

                // Second effect rolled - if statements used to make sure both effects are unique.
                x = d6();

                switch( x ) {
                    case 1:
                        if( nEffect1 == 1 )
                        {
                            eEffect2 = eConfuse;
                            eEffect2VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );
                        }
                        else
                        {
                            eEffect2 = eDamage;
                            eEffect2VFX = EffectVisualEffect( VFX_NONE );
                        }
                        break;
                    case 2:
                        if( nEffect1 == 2 )
                        {
                            eEffect2 = eStun;
                            eEffect2VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_NEGATIVE );
                        }
                        else
                        {
                            eEffect2 = eConfuse;
                            eEffect2VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );
                        }
                        break;
                    case 3:
                        if( nEffect1 == 3 )
                        {
                            eEffect2 = eFear;
                            eEffect2VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR );
                        }
                        else
                        {
                            eEffect2 = eStun;
                            eEffect2VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_NEGATIVE );
                        }
                        break;
                    case 4:
                        if( nEffect1 == 4 )
                        {
                            eEffect2 = eGouge;
                            eEffect2VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );
                        }
                        else
                        {
                            eEffect2 = eFear;
                            eEffect2VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR );
                        }
                        break;
                    case 5:
                        if( nEffect1 == 5 )
                        {
                            eEffect2 = eDeath;
                            eEffect2VFX = EffectVisualEffect( VFX_IMP_DEATH );
                        }
                        else
                        {
                            eEffect2 = eGouge;
                            eEffect2VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );
                        }
                        break;
                    case 6:
                        if( nEffect1 == 6 )
                        {
                            eEffect2 = eDamage;
                            eEffect2VFX = EffectVisualEffect( VFX_NONE );
                        }
                        else
                        {
                            eEffect2 = eDeath;
                            eEffect2VFX = EffectVisualEffect( VFX_IMP_DEATH );
                        }
                        break;
                    default:
                        eEffect2 = eDamage;
                }

                // Apply it all in one nice ugly bunch of code.
                DelayCommand( 0.8, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX4, oTarget ) );
                DelayCommand( 1.3, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget ) );
                DelayCommand( 1.3, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect1, oTarget, RoundsToSeconds( 3 ) ) );
                DelayCommand( 1.3, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect2, oTarget, RoundsToSeconds( 3 ) ) );
                DelayCommand( 1.3, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect1VFX, oTarget, RoundsToSeconds( 3 ) ) );
                DelayCommand( 1.3, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect2VFX, oTarget, RoundsToSeconds( 3 ) ) );
            }
        }
    }
    else
    {
        // Get first target in spell area.
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
        while(GetIsObjectValid(oTarget))
        {
            // Only affect hostiles.
            if(GetIsReactionTypeHostile(oTarget, oPC))
            {

                SignalEvent(oTarget, EventSpellCastAt(oPC, DC_SPELL_R_9));

                // Make SR check.
                if(!MyResistSpell(oPC, oTarget))
                {
                    if( !MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC() + nSpellDCBonus, SAVING_THROW_TYPE_SPELL, OBJECT_SELF ) )
                    {
                        // Random effects between six
                        x = d6();

                        switch( x ) {
                            case 1:
                                eEffect1 = EffectVisualEffect( VFX_NONE );
                                eEffect1VFX = EffectVisualEffect( VFX_NONE );
                                break;
                            case 2:
                                eEffect1 = eConfuse;
                                eEffect1VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );
                                break;
                            case 3:
                                eEffect1 = eStun;
                                eEffect1VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_NEGATIVE );
                                break;
                            case 4:
                                eEffect1 = eFear;
                                eEffect1VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR );
                                break;
                            case 5:
                                eEffect1 = eGouge;
                                eEffect1VFX = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );
                                break;
                            case 6:
                                eEffect1 = eDeath;
                                eEffect1VFX = EffectVisualEffect( VFX_IMP_DEATH );
                                break;
                            default:
                                eEffect1 = eDamage;
                                eEffect1VFX = EffectVisualEffect( VFX_NONE );
                        }

                        // Apply it all here.
                        DelayCommand( 0.8, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX4, oTarget ) );
                        DelayCommand( 1.3, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget ) );
                        DelayCommand( 1.3, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect1, oTarget, RoundsToSeconds( 3 ) ) );
                        DelayCommand( 1.3, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect1VFX, oTarget, RoundsToSeconds( 3 ) ) );
                    }
                }
            }
            //Get next target in the spell area
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
        }
    }
}

void ReadSchematicMain( object oPC, object oTarget)
{
    int nCasterLvl = GetCasterLevel( oPC );
    string sRace;
    effect eVis1 = EffectVisualEffect(VFX_DUR_IOUNSTONE_BLUE);
    effect eVis2 = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);

    // Checks to see if object is a creature
    if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE )
    {
        // Will save
        if( !MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, OBJECT_SELF ) )
        {
            //get racial information and set strings
            int iRace = GetRacialType(oTarget);
            string sSubRace = GetSubRace(oTarget);
            switch (iRace)
            {
                case RACIAL_TYPE_ABERRATION:
                    sRace = "Abberation";
                    break;
                case RACIAL_TYPE_ANIMAL:
                    sRace = "Animal";
                    break;
                case RACIAL_TYPE_BEAST:
                    sRace = "Beast";
                    break;
                case RACIAL_TYPE_CONSTRUCT:
                    sRace = "Construct";
                    break;
                case RACIAL_TYPE_DRAGON:
                    sRace = "Dragon";
                    break;
                case RACIAL_TYPE_DWARF:
                    sRace = "Dwarf";
                    break;
                case RACIAL_TYPE_ELEMENTAL:
                    sRace = "Elemental";
                    break;
                case RACIAL_TYPE_ELF:
                    sRace = "Elf";
                    break;
                case RACIAL_TYPE_FEY:
                    sRace = "Fey";
                    break;
                case RACIAL_TYPE_GIANT:
                    sRace = "Giant";
                    break;
                case RACIAL_TYPE_GNOME:
                    sRace = "Gnome";
                    break;
                case RACIAL_TYPE_HALFELF:
                    sRace = "Half Elf";
                    break;
                case RACIAL_TYPE_HALFLING:
                    sRace = "Halfling";
                    break;
                case RACIAL_TYPE_HALFORC:
                    sRace = "Half Orc";
                    break;
                case RACIAL_TYPE_HUMAN:
                    sRace = "Human";
                    break;
                case RACIAL_TYPE_HUMANOID_GOBLINOID:
                    sRace = "Goblinoid";
                    break;
                case RACIAL_TYPE_HUMANOID_MONSTROUS:
                    sRace = "Monstrous";
                    break;
                case RACIAL_TYPE_HUMANOID_ORC:
                    sRace = "Orc";
                    break;
                case RACIAL_TYPE_HUMANOID_REPTILIAN:
                    sRace = "Reptilian";
                    break;
                case RACIAL_TYPE_MAGICAL_BEAST:
                    sRace = "Magical Beast";
                    break;
                case RACIAL_TYPE_OOZE:
                    sRace = "Ooze";
                    break;
                case RACIAL_TYPE_OUTSIDER:
                    sRace = "Outsider";
                    break;
                case RACIAL_TYPE_SHAPECHANGER:
                    sRace = "Shapechanger";
                    break;
                case RACIAL_TYPE_UNDEAD:
                    sRace = "Undead";
                    break;
                case RACIAL_TYPE_VERMIN:
                    sRace = "Vermin";
                    break;
                default:
                    sRace = "Error: Unknown Race";
                    break;
                }

            //send information to PC
            string sName = GetName(oTarget);
            string sInfo = "Read Schematic for " +sName+ ": " +sRace+ ", " +sSubRace+ ".";
            SendMessageToPC(oPC, sInfo);

            //visuals
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis1, oTarget, 6.0);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oPC, 6.0);

            //run check for secondary effect
            DelayCommand(6.0, ReadSchematicConcentration(oPC, oTarget));
        }
    }

}

void ReadSchematicConcentration(object oPC, object oTarget)
{
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_MIND);
    int nAction = GetCurrentAction( oPC );

    // Caster has done nothing for the last round to break concentration?
    if ( nAction == ACTION_ANIMALEMPATHY || nAction == ACTION_ATTACKOBJECT
        || nAction == ACTION_CASTSPELL || nAction == ACTION_CLOSEDOOR
        || nAction == ACTION_COUNTERSPELL || nAction == ACTION_DIALOGOBJECT
        || nAction == ACTION_DISABLETRAP || nAction == ACTION_DROPITEM
        || nAction == ACTION_EXAMINETRAP || nAction == ACTION_FLAGTRAP
        || nAction == ACTION_FOLLOW || nAction == ACTION_HEAL
        || nAction == ACTION_ITEMCASTSPELL || nAction == ACTION_KIDAMAGE
        || nAction == ACTION_LOCK || nAction == ACTION_MOVETOPOINT
        || nAction == ACTION_OPENDOOR || nAction == ACTION_OPENLOCK
        || nAction == ACTION_PICKPOCKET || nAction == ACTION_PICKUPITEM
        || nAction == ACTION_RANDOMWALK || nAction == ACTION_RECOVERTRAP
        || nAction == ACTION_REST || nAction == ACTION_SETTRAP
        || nAction == ACTION_SIT || nAction == ACTION_SMITEGOOD
        || nAction == ACTION_TAUNT || nAction == ACTION_USEOBJECT )
    {
        SendMessageToPC(oPC, "You broke your concentration!");
    }
    else
    {
        //send visual cue of success to caster
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

        //set local int for use with other like spells
        SetLocalInt(oTarget, "ReadSchematic", 2);
        DelayCommand(60.0, SetLocalInt(oTarget, "ReadSchematic", 1));

        //send info messages to caster
        string sName = GetName(oTarget);
        string sMarked = "You have found a weakness within " + sName + "'s construction.";
        string sFaded = "Knowledge of " + sName + "'s weakness has faded from your mind.";
        SendMessageToPC(oPC, sMarked);
        DelayCommand(54.0, SendMessageToPC(oPC, sFaded));
    }
}

void Foxfire( object oPC, location lTarget )
{
    // General effect variables.
    int     nDamage;
    effect  eDamage;
    effect  eFear       = EffectFrightened();
    effect  eBlind      = EffectBlindness();
    effect  eWeakness   = EffectDamageImmunityDecrease( DAMAGE_TYPE_FIRE, 10 );

    effect  eImpactVis = EffectVisualEffect( VFX_DUR_PDK_FEAR );
    effect  eLightVis   = EffectVisualEffect( VFX_DUR_LIGHT_BLUE_10 );

    effect  eDamageVis  = EffectVisualEffect( VFX_IMP_FLAME_S );
    effect  eBlindVis   = EffectVisualEffect( VFX_IMP_BLIND_DEAF_M );
    effect  eFearVis    = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR );

    // General integers used for calculations.
    int     x;
    int     nDelay;
    int     nDelay2;
    float   fDelay;

    // Used to generate the visuals' location.
    float fAngle;
    object oArea        = GetAreaFromLocation( lTarget );
    vector vNewPos;
    location lLocation;

    // Create the base plc for all the other plc locations.
    object oPLC;
    oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_foxfire", lTarget );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eImpactVis, oPLC, 4.5 );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLightVis, oPLC, 4.5 );
    DestroyObject( oPLC, 6.5 );

    // Create a circle of plcs around the base one.
    for ( x = 0; x < 8; x++ )
    {
        lLocation   = GenerateNewLocationFromLocation( lTarget, 3.0, fAngle, 0.0 );
        oPLC        = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_foxfire", lLocation );
        fAngle      = fAngle + 45;

        nDelay = Random( 2 );
        nDelay2 = Random( 2 );

        DelayCommand( IntToFloat( nDelay ), ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eImpactVis, oPLC, 3.5 + IntToFloat( nDelay2 ) ) );
        DelayCommand( IntToFloat( nDelay ), ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLightVis, oPLC, 3.5 + IntToFloat( nDelay2 ) ) );

        DestroyObject( oPLC, 6.5 );
    }

    vNewPos     = GetChangedPosition( GetPositionFromLocation( lTarget ), 0.0, 0.0 );
    lTarget     = Location( oArea, Vector( vNewPos.x, vNewPos.y, vNewPos.z - 0.80 ), 0.0 );


    // Create the base plc for all the other plc locations.
    object oMist;
    oMist = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_cle_mist", lTarget );
    DestroyObject( oMist, 7.0 );

    // Create a circle of plcs around the base one.
    for ( x = 0; x < 4; x++ ) {
        lLocation   = GenerateNewLocationFromLocation( lTarget, 2.0, fAngle, 0.0 );
        oMist       = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_cle_mist", lLocation );
        fAngle      = fAngle + 90;
        DestroyObject( oMist, 7.0 );
    }

    // Get first target in spell area.
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget );
    while( GetIsObjectValid( oTarget ) )
    {
        // Only affect hostiles.
        if( GetIsReactionTypeHostile( oTarget, oPC ) )
        {
            SignalEvent( oTarget, EventSpellCastAt( oPC, DC_SPELL_R_7 ) );

            fDelay = GetRandomDelay(1.5, 2.5);
            // Make SR check.
            if( !MyResistSpell( oPC, oTarget ) )
            {
                if( !MySavingThrow( SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE ) )
                {
                    DelayCommand(fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds( 1 ) ) );
                    DelayCommand(fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eBlindVis, oTarget ) );
                }

                if( !MySavingThrow( SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE ) )
                {
                    DelayCommand(fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFear, oTarget, RoundsToSeconds( 1 ) ) );
                    DelayCommand(fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFearVis, oTarget, RoundsToSeconds( 1 ) ) );
                }

                nDamage     = d6( 15 );
                nDamage     = GetReflexAdjustedDamage( nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE );
                eDamage     = EffectDamage( nDamage, DAMAGE_TYPE_FIRE );

                if( nDamage > 0 )
                {
                    DelayCommand(fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget ) );
                }

                DelayCommand(fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eWeakness, oTarget, RoundsToSeconds( 10 ) ) );
                DelayCommand(fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamageVis, oTarget ) );
            }
        }
        //Get next target in the spell area
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget );
    }
}

void DevouringEarth( object oPC, location lTarget )
{
    //Declare major variables
    int nCasterLvl              = GetCasterLevel(OBJECT_SELF);
    int nDamage;
    int x;

    float fDelay;
    float fQuakeDelay;
    float fQuakeY1              = -3.0;
    float fQuakeY2              = 3.0;

    float fAngle;
    object oArea                = GetAreaFromLocation(lTarget);
    vector vNewPos;

    effect      eVFX1           = EffectVisualEffect( VFX_FNF_SCREEN_SHAKE );
    effect      eVFX2           = EffectVisualEffect( VFX_IMP_DUST_EXPLOSION );
    effect      eVFX3           = EffectVisualEffect( VFX_COM_CHUNK_STONE_MEDIUM );
    effect      eVFX4           = EffectVisualEffect( VFX_COM_CHUNK_RED_LARGE );

    effect      eDisappear      = EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY );
    effect      eParalyze       = EffectCutsceneParalyze();
    effect      eDeath          = SupernaturalEffect( EffectDeath() );

    effect      eDamage;

    location    lLocation;
    location    lLocationQuake;

    object      oPLC;

    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX1, lTarget );
    DelayCommand( 0.5, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX1, lTarget ) );

    // Create a circle of plcs around the base one.
    for ( x = 0; x < 7; x++ )
    {
        lLocation       = GenerateNewLocationFromLocation( lTarget, fQuakeY1, 0.0, 0.0 );
        DelayCommand( fQuakeDelay, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX3, lLocation ) );

        vNewPos         = GetChangedPosition( GetPositionFromLocation(lLocation), 0.0, 0.0 );
        lLocationQuake  = Location( oArea, Vector( vNewPos.x, vNewPos.y, vNewPos.z - 0.15 ), 0.0 );

        oPLC            = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_dev_hole", lLocationQuake );
        DestroyObject( oPLC, 6.0 + fQuakeDelay );

        fQuakeDelay     = fQuakeDelay + 0.08;
        fQuakeY1        = fQuakeY1 + 1.0;
    }

    fQuakeDelay = 0.0;
    fQuakeY1 = -3.0;

    // Create a circle of plcs around the base one.
    for ( x = 0; x < 3; x++ )
    {
        lLocation   = GenerateNewLocationFromLocation( lTarget, fQuakeY1, GetRandomDelay( -0.6, 0.6 ), 0.0 );
        DelayCommand( fQuakeDelay, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX2, lLocation ) );

        oPLC        = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_dev_plum", lLocation );
        DestroyObject( oPLC, 6.0 + fQuakeDelay );

        fQuakeDelay = fQuakeDelay + GetRandomDelay( 0.2, 0.4 );
        fQuakeY1    = fQuakeY1 + GetRandomDelay( 1.0, 4.0 );
    }

    fQuakeDelay = 0.0;

    DelayCommand( 6.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX1, lTarget ) );
    DelayCommand( 6.5, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX1, lTarget ) );

    // Create a circle of plcs around the base one.
    for ( x = 0; x < 7; x++ )
    {
        lLocation   = GenerateNewLocationFromLocation( lTarget, fQuakeY2, 0.0, 0.0 );
        DelayCommand( fQuakeDelay + 6.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX3, lLocation ) );
        fQuakeDelay = fQuakeDelay + 0.08;
        fQuakeY2    = fQuakeY2 - 1.0;
    }

    fQuakeDelay = 0.0;
    fQuakeY2 = 3.0;

    // Create a circle of plcs around the base one.
    for ( x = 0; x < 3; x++ )
    {
        lLocation   = GenerateNewLocationFromLocation( lTarget, fQuakeY2, GetRandomDelay( 0.0, 0.3 ), 0.0 );
        DelayCommand( fQuakeDelay + 6.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX2, lLocation ) );

        fQuakeDelay = fQuakeDelay + GetRandomDelay( 0.2, 0.4 );
        fQuakeY2    = fQuakeY2 - GetRandomDelay( 1.0, 4.0 );
    }


    //Get the first target in the spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE);
    while ( GetIsObjectValid( oTarget ) )
    {
        if( !GetIsReactionTypeFriendly( oTarget ) )
        {
            fDelay = GetRandomDelay(0.5, 1.0);
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, DC_SPELL_R_9));

            if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                FloatingTextStringOnCreature( "You feel the earth tremble beneath your feet before it suddenly cracks open and gravity takes its toll, trying to pull you down!", oTarget, FALSE );
                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
                {
                    if(MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
                    {
                        nDamage = d8( 12 );
                        eDamage = EffectDamage( nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_FIVE );

                        DelayCommand( fDelay + 6.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget ) );
                        DelayCommand( fDelay, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX3, GetLocation( oTarget ) ) );
                        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDisappear, oTarget, 6.0 ) );
                        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eParalyze, oTarget, 6.0 ) );
                        DelayCommand( fDelay + 6.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX3, oTarget ) );
                    }
                    else
                    {
                        DelayCommand( fDelay, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX3, GetLocation( oTarget ) ) );
                        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDisappear, oTarget, 6.0 ) );
                        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eParalyze, oTarget, 6.0 ) );
                        DelayCommand( fDelay + 6.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX3, oTarget ) );
                        DelayCommand( fDelay + 6.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX4, oTarget ) );
                        DelayCommand( fDelay + 6.2, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDeath, oTarget ) );
                    }
                }
           }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE);
    }
}

void VoxCelestia( object oPC )
{
    // General effect variables.
    int         nCasterLevel    = GetCasterLevel( oPC );
    int         nDamage;

    int         nCurrentHP      = GetCurrentHitPoints( oPC );

    effect      eDamage;
    effect      eStun           = EffectStunned();
    effect      eBanish         = SupernaturalEffect( EffectDeath() );

    effect      eVFX1           = EffectVisualEffect( VFX_FNF_WORD );
    effect      eVFX2           = EffectVisualEffect( 623 );
    effect      eVFX3           = EffectVisualEffect( VFX_FNF_STRIKE_HOLY );

    effect      eVFXStun        = EffectVisualEffect( VFX_IMP_STUN );
    effect      eVFXBanish      = EffectVisualEffect( VFX_IMP_UNSUMMON );
    effect      eVFXDmg         = EffectVisualEffect( 685 );

    location    lTarget         = GetLocation( oPC );
    location    lLocation;

    object      oPLC;

    float       fAngle          = 45.0;
    float       fDelay;
    int         x;


    // Create a circle of plcs around the base one.
    for ( x = 0; x < 4; x++ )
    {
        lLocation   = GenerateNewLocationFromLocation( lTarget, 8.0, fAngle, 0.0 );
        oPLC        = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_vox_celes", lLocation );
        fAngle      = fAngle + 90;

        DelayCommand( 0.1, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX3, GetLocation( oPLC ) ) );

        DestroyObject( oPLC, 3.5 );
    }

    DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( nCurrentHP / 2, DAMAGE_TYPE_DIVINE ), oPC ) );
    DelayCommand( 1.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX1, lTarget ) );

    for ( x = 0; x < 4; x++ )
    {
        lLocation   = GenerateNewLocationFromLocation( lTarget, 4.0, fAngle, 0.0 );
        fAngle      = fAngle + 90;

        DelayCommand( 1.5, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVFX2, lLocation ) );
    }

    // Get first target in spell area.
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget );
    while( GetIsObjectValid( oTarget ) )
    {
        // Only affect hostiles.
        if( GetIsReactionTypeHostile( oTarget, oPC ) )
        {
            SignalEvent( oTarget, EventSpellCastAt( oPC, DC_SPELL_S_9 ) );
            fDelay = GetRandomDelay(1.5, 2.5);
            // Make SR check.
            if( !MyResistSpell( oPC, oTarget ) )
            {
                if( !MySavingThrow( SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SONIC ) )
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, 6.0));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFXStun, oTarget, 6.0));
                }

                if( GetAlignmentGoodEvil( oTarget ) == ALIGNMENT_EVIL )
                {
                    if( !MySavingThrow( SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_GOOD ) )
                    {
                        nDamage = d6( nCasterLevel );
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);

                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFXDmg, oTarget));
                    }

                    if( GetRacialType( oTarget ) == RACIAL_TYPE_OUTSIDER )
                    {
                        if( !MySavingThrow( SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_GOOD ) )
                        {
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBanish, oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFXBanish, oTarget));
                        }
                    }
                }
            }
        }
        //Get next target in the spell area
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget );
    }
}

void GreaterSandstorm( object oPC, location lTarget )
{
    // Variables for effects and visuals.
    effect eAOE     = EffectAreaOfEffect( AOE_MOB_DRAGON_FEAR, "cs_sandstorm_a", "cs_sandstorm_b", "cs_sandstorm_c" );
    effect eAOE2    = EffectAreaOfEffect( AOE_PER_FOG_OF_BEWILDERMENT, "****", "****", "****" );
    effect eImpact  = EffectVisualEffect( VFX_FNF_LOS_NORMAL_20 );
    effect eDur     = EffectVisualEffect( 679 );
    effect eDur2    = EffectVisualEffect( 320 );

    // Duration is 1 round/level.
    int nDuration   = GetCasterLevel( oPC );

    // For visual location calculations.
    float fDelay;
    float fAngle;
    object oPLC;
    location lLocation;

    // Play a circle of visuals at the target
    int x;
    for ( x = 0; x < 8; x++ )
    {
        lLocation   = GenerateNewLocationFromLocation( lTarget, 4.0, fAngle, 0.0 );
        DelayCommand( fDelay, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, lLocation ) );
        fAngle      = fAngle + 45;
        fDelay      = fDelay + 0.1;
    }

    fAngle = 0.0;

    for ( x = 0; x < 8; x++ )
    {
        lLocation   = GenerateNewLocationFromLocation( lTarget, 5.0, fAngle, 0.0 );
        oPLC        = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_foxfire", lLocation );
        DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oPLC, RoundsToSeconds( nDuration ) ) );
        fAngle      = fAngle + 45;
    }

    fAngle = 0.0;

    for ( x = 0; x < 4; x++ )
    {
        lLocation   = GenerateNewLocationFromLocation( lTarget, 4.5, fAngle, 0.0 );
        DelayCommand( 1.0, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE2, lLocation, RoundsToSeconds( nDuration ) ) );
        fAngle      = fAngle + 90;
    }

    //Apply the AOE object to the specified location
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds( nDuration ) );
}

void IllusionaryPolymorph( object oPC, object oTarget )
{
    effect  eVFX1       = EffectVisualEffect( VFX_IMP_DEATH );
    effect  eVFX2       = EffectVisualEffect( VFX_IMP_WILL_SAVING_THROW_USE );

    effect  eDur1       = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR );
    effect  eDur2       = EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR );
    effect  eDur3       = EffectVisualEffect( VFX_DUR_TENTACLE );
    effect  eStun       = EffectStunned();

    int     nSpellDCBonus;
    int     nCasterLvl  = GetCasterLevel( oPC ) / 3;

    int nMetaMagic = GetMetaMagicFeat();
    //Check for metamagic extension
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nCasterLvl = nCasterLvl * 2;  //Duration is +100%
    }

    // Checks to see if object is Creature
    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ) {
        SendMessageToPC( oPC, "You can't affect that!" );
        return;
    }

    nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_ILLUSION );


    SignalEvent(oTarget, EventSpellCastAt(oPC, DC_SPELL_R_8));

    effect eLink        = EffectLinkEffects( eDur1, eStun );
    eLink               = EffectLinkEffects( eDur2, eLink );
    eLink               = EffectLinkEffects( eDur3, eLink );

    // Can't damage friendlies, prevents damaging party members, No PvP abuse etc.
    if( !GetIsReactionTypeFriendly( oTarget ) )
    {
        // Count for keeping track of targets hit, delay for allowing time for the beam to hit.
        float fDelay = 0.2;

        //Make an SR check
        if (!MyResistSpell(oPC, oTarget))
        {
            if( !MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC() + nSpellDCBonus, SAVING_THROW_TYPE_SPELL, OBJECT_SELF ) )
            {
                // Target fails save, it has visual effects applied.
                FloatingTextStringOnCreature( "- Your mind becomes wracked with horror as your body begins morph into a terrifying monstrosity. You have become a creature that stalks your nightmares, that feeds on your fear, and the change cannot be reconciled by your mind. Paralysing terror is all that remains... -", oTarget, FALSE );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oTarget );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nCasterLvl ) );
            }
            else
            {
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );
                return;
            }

            SetLocalInt( oTarget, "illusion_poly_block", 1 );
            DelayCommand( 4.0, DeleteLocalInt( oTarget, "illusion_poly_block" ) );

            //Get the first target in the spell shape
            object oNextTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation( oTarget ), TRUE, OBJECT_TYPE_CREATURE );
            while( GetIsObjectValid( oNextTarget ) )
            {
                //Make sure the caster's faction is not hit and the first target is not hit
                if ( !GetIsReactionTypeFriendly( oNextTarget ) || oNextTarget == oPC )
                {
                    if( !GetLocalInt( oNextTarget, "illusion_poly_block" ) )
                    {
                        SetLocalInt( oNextTarget, "illusion_poly_block", 1 );
                        DelayCommand( 4.0, DeleteLocalInt( oNextTarget, "illusion_poly_block" ) );

                        //Make an SR check
                        if (!MyResistSpell(oPC, oNextTarget))
                        {
                            if( !MySavingThrow(SAVING_THROW_WILL, oNextTarget, GetSpellSaveDC() + nSpellDCBonus, SAVING_THROW_TYPE_SPELL, OBJECT_SELF ) )
                            {
                                // Target fails save, it has visual effects applied.
                                if( !GetIsImmune( oNextTarget, IMMUNITY_TYPE_MIND_SPELLS ) && !GetIsImmune( oNextTarget, IMMUNITY_TYPE_STUN ) )
                                {
                                    DelayCommand( fDelay, FloatingTextStringOnCreature( "- Your mind becomes wracked with horror as your body begins morph into a terrifying monstrosity. You have become a creature that stalks your nightmares, that feeds on your fear, and the change cannot be reconciled by your mind. Paralysing terror is all that remains... -", oNextTarget, FALSE ) );
                                }
                                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oNextTarget ) );
                                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oNextTarget, RoundsToSeconds( nCasterLvl ) ) );
                            }
                            else
                            {
                                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oNextTarget ) );
                                return;
                            }
                        }
                    }
                }

                fDelay = fDelay + 0.1f;
                // Find the next target.
                oNextTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oNextTarget), TRUE, OBJECT_TYPE_CREATURE);
            }
        }
    }
}

void SurgeOfLunacy( object oPC )
{
    int     nCasterLevel    =  GetCasterLevel( oPC );

    effect  eSkill1         = EffectSkillIncrease( SKILL_SPOT, nCasterLevel / 2 );
    effect  eSkill2         = EffectSkillIncrease( SKILL_LISTEN, nCasterLevel / 2 );
    effect  eUltra          = EffectUltravision();
    effect  eImmune1        = EffectImmunity( IMMUNITY_TYPE_CHARM );
    effect  eImmune2        = EffectImmunity( IMMUNITY_TYPE_FEAR );
    effect  eImmune3        = EffectImmunity( IMMUNITY_TYPE_CONFUSED );
    effect  eTempHP         = EffectTemporaryHitpoints( nCasterLevel );
    effect  eWillSave       = EffectSavingThrowIncrease( SAVING_THROW_WILL, nCasterLevel / 3 );
    effect  eMovement       = EffectMovementSpeedIncrease( 10 );

    effect  eVFX1           = EffectVisualEffect( VFX_FNF_STRIKE_HOLY );
    effect  eVFX2           = EffectVisualEffect( 1046 );
    effect  eVFX3           = EffectVisualEffect( 685 );
    effect  eVFX4           = EffectVisualEffect( VFX_IMP_HOLY_AID );

    effect  eDur            = EffectVisualEffect( VFX_DUR_AURA_PULSE_YELLOW_WHITE );

    effect  eLink;

    float   fDelay;
    float   fRadius;

    string sAOETag;

    object  oArea           = GetArea( oPC );
    int     nDay            = GetIsDay();
    int     nOutside        = GetIsAreaAboveGround( oArea );

    int nMetaMagic = GetMetaMagicFeat();
    //Check for metamagic extension
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nCasterLevel = nCasterLevel * 2;  //Duration is +100%
    }

    if( nDay == TRUE && nOutside == TRUE )
    {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );

        fRadius = 6.5f;

        eLink   = EffectLinkEffects( eWillSave, eLink );
    }
    else if( nDay == TRUE && nOutside == FALSE )
    {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );

        fRadius = 6.5f;

        eLink   = EffectLinkEffects( eWillSave, eLink );
        eLink   = EffectLinkEffects( eSkill1, eLink );
        eLink   = EffectLinkEffects( eSkill2, eLink );
        eLink   = EffectLinkEffects( eUltra, eLink );
    }
    else if( nDay == FALSE && nOutside == FALSE )
    {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );
        DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX2, oPC, 3.0 ) );

        fRadius = 10.0f;

        eLink   = EffectLinkEffects( eWillSave, eLink );
        eLink   = EffectLinkEffects( eSkill1, eLink );
        eLink   = EffectLinkEffects( eSkill2, eLink );
        eLink   = EffectLinkEffects( eUltra, eLink );
        eLink   = EffectLinkEffects( eImmune1, eLink );
        eLink   = EffectLinkEffects( eImmune2, eLink );
        eLink   = EffectLinkEffects( eImmune3, eLink );
        eLink   = EffectLinkEffects( eTempHP, eLink );
    }
    else if( nDay == FALSE && nOutside == TRUE )
    {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );
        DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX2, oPC, 3.0 ) );

        fRadius = 15.0f;

        eLink   = EffectLinkEffects( eWillSave, eLink );
        eLink   = EffectLinkEffects( eSkill1, eLink );
        eLink   = EffectLinkEffects( eSkill2, eLink );
        eLink   = EffectLinkEffects( eUltra, eLink );
        eLink   = EffectLinkEffects( eImmune1, eLink );
        eLink   = EffectLinkEffects( eImmune2, eLink );
        eLink   = EffectLinkEffects( eImmune3, eLink );
        eLink   = EffectLinkEffects( eTempHP, eLink );
        eLink   = EffectLinkEffects( eMovement, eLink );
    }

    if( nDay == FALSE && nOutside == TRUE )
    {
        DelayCommand( 1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX3, oPC, 2.0 ));
    }
    else
    {
        DelayCommand( 1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX4, oPC ));
    }

    //Get the first target in the radius around the caster
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation( oPC ), FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT );
    while(GetIsObjectValid(oTarget))
    {
        sAOETag = GetTag(oTarget);
        if ( sAOETag == "VFX_PER_DARKNESS" )
        {
            DestroyObject(oTarget);
        }

        if(GetIsReactionTypeFriendly(oTarget) )
        {
            // prevent stacking with self
            if ( GetHasSpellEffect( GetSpellId(), oTarget ) )
            {
                RemoveEffectsFromSpell( oTarget, GetSpellId() );
            }

            fDelay = GetRandomDelay(0.4, 1.1);
            //Apply VFX impact and bonus effects
            DelayCommand( 1.0 + fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nCasterLevel)));
            DelayCommand( 1.0 + fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, TurnsToSeconds(nCasterLevel)));

            if( nDay == FALSE && nOutside == TRUE )
            {
                DelayCommand( 1.0 + fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX3, oTarget, 2.0 ));
            }
            else
            {
                DelayCommand( 1.0 + fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX4, oTarget));
            }
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation( oPC ), FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT );
    }
}

void EarthShield( object oPC )
{
    int nDuration   = GetCasterLevel( oPC );

    int nDamage1    = GetCasterLevel( oPC );
    int nDamage2    = ( nDamage1 / 2 ) - 1;

    effect eShield1 = EffectDamageShield( nDamage1, DAMAGE_BONUS_1d6, DAMAGE_TYPE_BLUDGEONING );
    effect eShield2 = EffectDamageShield( nDamage2, DAMAGE_BONUS_1, DAMAGE_TYPE_SLASHING );

    effect eResist1 = EffectDamageResistance( DAMAGE_TYPE_BLUDGEONING, 5 );
    effect eResist2 = EffectDamageResistance( DAMAGE_TYPE_SLASHING, 5 );
    effect eResist3 = EffectDamageResistance( DAMAGE_TYPE_PIERCING, 5 );

    effect eVFX1    = EffectVisualEffect( 1043 );
    effect eVFX2    = EffectVisualEffect( 1044 );

    int nMetaMagic = GetMetaMagicFeat();
    //Check for metamagic extension
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }

    // prevent stacking with self
    if (GetHasSpellEffect(GetSpellId()))
    {
        RemoveEffectsFromSpell( oPC, GetSpellId() );
    }

    effect eLink = EffectLinkEffects( eShield1, eShield2 );
    eLink = EffectLinkEffects( eResist1, eLink );
    eLink = EffectLinkEffects( eResist2, eLink );
    eLink = EffectLinkEffects( eResist3, eLink );
    eLink = EffectLinkEffects( eVFX1, eLink );
    eLink = EffectLinkEffects( eVFX2, eLink );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds( nDuration ) );
}

void DarknessInevitable( object oPC, object oTarget )
{
    if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(647, oTarget) == TRUE)
    {
        RemoveSpellEffects(647, OBJECT_SELF, oTarget);
    }

    if (GetHasSpellEffect(SPELL_MASS_HASTE, oTarget) == TRUE)
    {
        RemoveSpellEffects(SPELL_MASS_HASTE, OBJECT_SELF, oTarget);
    }


    effect eHaste   = EffectHaste();
    effect eVFX1    = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    effect eVFX2    = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    effect eVFX3    = EffectVisualEffect(VFX_DUR_TENTACLE);
    effect eVFX4    = EffectBeam( VFX_BEAM_BLACK, oTarget, BODY_NODE_CHEST );

    effect  eLink    = EffectLinkEffects(eHaste, eVFX2);
            eLink    = EffectLinkEffects(eLink, eVFX3);
            eLink    = EffectLinkEffects(eLink, eVFX4);

    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HASTE, FALSE));
    //Check for metamagic extension
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }
    // Apply effects to the currently selected target.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX1, oTarget);
}

void SpiritShield( object oPC, object oTarget )
{
    if( oPC == oTarget )
    {
        FloatingTextStringOnCreature( "Cannot target self!", oPC, FALSE );
        return;
    }


    int nDuration   = GetCasterLevel(oPC);
    int nMetaMagic  = GetMetaMagicFeat();

    //Check for metamagic extension
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }

    //Declare major variables
    effect eVFX1    = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect eVFX2    = EffectVisualEffect(685);

    effect eDeath   = EffectImmunity(IMMUNITY_TYPE_DEATH);

    int nHP         = d4( 10 );
    effect eDamage  = EffectDamage( nHP );
    effect eHPGain  = EffectTemporaryHitpoints( nHP );

    effect eLink    = EffectLinkEffects(eDeath, eVFX2);

    // prevent stacking with self
    if (GetHasSpellEffect(GetSpellId()))
    {
        RemoveEffectsFromSpell( oPC, GetSpellId() );
    }

    //Apply VFX impact and death immunity effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHPGain, oTarget, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX1, oPC);

    SetBlockTime( oTarget, nDuration, 0, "Deathtouch_Immune" );
}

void Beatitudes( object oPC )
{
    //variable block
    effect eAOE     = EffectAreaOfEffect( 47, "cs_beatitudes_a", "****", "cs_beatitudes_b" );
    int nDuration   = GetCasterLevel( oPC );
    effect eVFX1    = EffectVisualEffect( 688 );
    effect eVFX2    = EffectVisualEffect( 631 );

    effect eAB      = EffectAttackIncrease( 5 );
    effect eSkill   = EffectSkillIncrease( 6, SKILL_CONCENTRATION );
    effect eFear    = EffectImmunity( IMMUNITY_TYPE_FEAR );

    if ( GetHasSpellEffect( GetSpellId() ) )
    {
        RemoveEffectsFromSpell( oPC, GetSpellId() );
    }

    if ( GetHasSpellEffect( SPELL_TENSERS_TRANSFORMATION, oPC ) )
    {
        RemoveEffectsFromSpell( oPC, SPELL_TENSERS_TRANSFORMATION );
    }

    if( GetMetaMagicFeat() == METAMAGIC_EXTEND )
        nDuration *= 2;

    effect eLink = EffectLinkEffects( eSkill, eFear );
           eLink = EffectLinkEffects( eLink, eAB );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eAOE, oPC, TurnsToSeconds( nDuration ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds( nDuration ) );
}

void EyesOfTheSandTracker( object oPC, location lTarget ){

    effect eAOE         = EffectAreaOfEffect( AOE_PER_CUSTOM_AOE, "cs_eyessand", "****", "****" );
    int nDuration       = GetCasterLevel( oPC );
    //Update with real tag for the sand component
    object oComponent   = GetItemPossessedBy(  oPC, "ds_j_res_425" );
    object oPLC;

    if( !GetIsObjectValid( oComponent ) ){

        SendMessageToPC( oPC, "You do not have the required component to cast this spell!" );
        return;
    }

    DestroyObject( oComponent );
    oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_eyes_sand", lTarget );
    SetLocalObject( oPLC, "caster", oPC );
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lTarget, TurnsToSeconds( nDuration ) );
    AssignCommand( oPLC, DestroyObject( oPLC, TurnsToSeconds( nDuration ) ) );
}

void CupolaofAmplifiedSilence( object oPC ){

    effect eAOE         = EffectAreaOfEffect( AOE_MOB_DRAGON_FEAR, "cs_cupsil_ent", "****", "cs_cupsil_lef" );
    effect eSpell       = EffectLinkEffects( eAOE, EffectSilence( ) );
           eSpell       = EffectLinkEffects( eSpell, EffectVisualEffect( VFX_DUR_CESSATE_NEUTRAL ) );
           eSpell       = EffectLinkEffects( eSpell, EffectSkillIncrease( SKILL_LISTEN, 5 ) );
           eSpell       = EffectLinkEffects( eSpell, EffectSkillIncrease( SKILL_MOVE_SILENTLY, 5 ) );
    int nDuration       = GetCasterLevel( oPC );

    if( GetHasSpellEffect( GetSpellId(), oPC ) ){

        RemoveEffectsFromSpell( oPC, GetSpellId() );
    }

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSpell, oPC, TurnsToSeconds( nDuration ) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SOUND_BURST_SILENT ), oPC );
}

void SoulInfusion( object oPC, object oTarget ){

    int nSpellDCBonus;

    nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_NECROMANCY );

    if( GetCurrentHitPoints( oPC ) < 2 || oTarget == oPC || GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE || GetChallengeRating( oTarget ) > 40.0 || GetRacialType( oTarget ) == RACIAL_TYPE_CONSTRUCT ){

        SendMessageToPC( oPC, "The spell failed!" );
        return;
    }

    if( !GetIsReactionTypeFriendly( oTarget, oPC ) ){

        SignalEvent(oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_FINGER_OF_DEATH, TRUE ) );

        if( TouchAttackRanged( oTarget, TRUE ) > 0 ){

            if( MyResistSpell( oPC, oTarget ) < 1 ){

                if( FortitudeSave( oTarget, GetSpellSaveDC( )+nSpellDCBonus, SAVING_THROW_TYPE_POSITIVE, oPC ) < 1 ){

                    //Kill with style because we're igoring death immunity
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetMaxHitPoints( oTarget ) + Random( 100 ) + 10,DAMAGE_TYPE_POSITIVE ), oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DESTRUCTION ), oTarget );
                }
                else{

                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( d10(5),DAMAGE_TYPE_POSITIVE ), oTarget );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_COM_HIT_DIVINE ), oTarget );
                }
            }

            //Not sure if this is where we want the self-damage part
            //I assume the spell is "invested" as it was when hits
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetCurrentHitPoints( oPC )/2,DAMAGE_TYPE_POSITIVE ), oPC );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_COM_HIT_DIVINE ), oPC );
        }
    }
}

//This a blatant copy from the restroation script and should conform to Amias standards
void SootheRestore( object oTarget, int nCL ){

    // Variables.
    object oPC          = oTarget;
    effect eEffect      = GetFirstEffect( oPC );


    // Cycle the player's effects.
    while( GetIsEffectValid( eEffect ) ){

        // Variables.
        int nEffectType = GetEffectType( eEffect );

        switch( nEffectType ){

            // Ill effects.
            case EFFECT_TYPE_ABILITY_DECREASE:
            case EFFECT_TYPE_AC_DECREASE:
            case EFFECT_TYPE_ATTACK_DECREASE:
            case EFFECT_TYPE_DAMAGE_DECREASE:
            case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
            case EFFECT_TYPE_SAVING_THROW_DECREASE:
            case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
            case EFFECT_TYPE_SKILL_DECREASE:
            case EFFECT_TYPE_BLINDNESS:
            case EFFECT_TYPE_DEAF:
            case EFFECT_TYPE_PARALYZE:
            case EFFECT_TYPE_NEGATIVELEVEL:{

                //remove if it isn't a custom spell effect
                if ( GetName( GetEffectCreator( eEffect ) ) != "ds_norestore" ){

                    RemoveEffect( oPC, eEffect );
                }

                break;

            }

            default:
                break;

        }

        // Get the next effect on the player.
        eEffect         = GetNextEffect( oPC );

    }

    ApplyAreaAndRaceEffects( oPC );

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect( VFX_IMP_RESTORATION ),
        oPC );

    SignalEvent(oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_RESTORATION, FALSE ) );

    effect eHP = EffectLinkEffects( EffectTemporaryHitpoints( d4( nCL ) ), EffectVisualEffect( VFX_DUR_CESSATE_NEUTRAL ) );

    //Add our temp hps here
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eHP, oTarget, RoundsToSeconds( nCL ) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HEAD_HOLY ), oTarget );
}

void Soothe( object oPC, object oTarget, location lTarget ){

    int nSpellDCBonus;

    nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_NECROMANCY );

    int nCL = GetCasterLevel( oPC );
    int nCNT = nCL/2;

    if( !GetIsObjectValid( oTarget ) || GetIsReactionTypeHostile( oTarget, oPC ) ){

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_STRIKE_HOLY ), lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_WORD ), lTarget );

        oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
        while( GetIsObjectValid( oTarget ) ){

            if( GetIsReactionTypeHostile( oTarget, oPC ) ){

                if( GetRacialType( oTarget ) == RACIAL_TYPE_UNDEAD && nCNT > 0 && GetChallengeRating( oTarget ) < 41.0 ){

                    SignalEvent(oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_UNDEATH_TO_DEATH, TRUE ) );

                    if( FortitudeSave( oTarget, GetSpellSaveDC( )+nSpellDCBonus, SAVING_THROW_TYPE_NONE, oPC ) < 1 ){

                        //KILL!
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetMaxHitPoints( oTarget ) + Random( 100 ) + 10,DAMAGE_TYPE_DIVINE ), oTarget );
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HEAD_HOLY ), oTarget );

                    }
                    else{
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( d4( nCL ),DAMAGE_TYPE_DIVINE ), oTarget );
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HEAD_HOLY ), oTarget );
                    }
                    nCNT--;
                }
            }
            else{
                SootheRestore( oTarget, nCL );
            }

            oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
        }
    }
    else if( GetIsObjectValid( oTarget ) ){
        SootheRestore( oTarget, nCL );
    }
}

void SurgingSpite( object oPC ){

    SignalEvent( oPC, EventSpellCastAt( OBJECT_SELF, SPELL_TRUE_STRIKE, FALSE ) );

    if( GetIsImmune( oPC, IMMUNITY_TYPE_MIND_SPELLS, oPC ) ){

        SendMessageToPC( oPC, "You are immune to mind effects!" );
        return;
    }

    effect  eAwesome = EffectLinkEffects( EffectAttackIncrease( 10 ), EffectDamageIncrease( DAMAGE_BONUS_10 ) );
            eAwesome = EffectLinkEffects( eAwesome, EffectSavingThrowIncrease( SAVING_THROW_WILL, 5 ) );
            eAwesome = EffectLinkEffects( eAwesome, EffectVisualEffect( VFX_DUR_AURA_PULSE_RED_BLACK ) );
            eAwesome = EffectLinkEffects( eAwesome, EffectVisualEffect( VFX_DUR_CESSATE_NEUTRAL ) );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eAwesome, oPC, 9.1 );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HEAD_ODD ), oPC );
}

void ControlConstruct( object oPC, object oTarget ){

    int nSpellDCBonus;

    nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_TRANSMUTATION );
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, DC_SPELL_R_7));

    if( GetRacialType( oTarget ) == RACIAL_TYPE_CONSTRUCT && !GetIsPC( oTarget ) && GetChallengeRating( oTarget ) < 41.0 && GetIsReactionTypeHostile( oTarget, oPC ) ){

        if( MyResistSpell( oPC, oTarget ) < 1 ){

            if( WillSave( oTarget, GetSpellSaveDC( )+nSpellDCBonus, SAVING_THROW_TYPE_NONE, oPC ) < 1 ){

                effect eControl = EffectDominated();
                effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
                effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
                effect eLink = EffectLinkEffects(eMind, eControl);
                eLink = EffectLinkEffects(eLink, eDur);
                eLink = EffectLinkEffects(eLink, EffectVisualEffect( VFX_DUR_MAGIC_RESISTANCE ) );

                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellID( eLink, SPELL_CONTROL_UNDEAD ), oTarget, NewHoursToSeconds(GetCasterLevel( oPC ))));
            }
        }
    }
    else
        SendMessageToPC( oPC, "Spell failed!" );
}

void WallofIce( object oPC, object oTarget ) {

    effect eIce = EffectVisualEffect( VFX_DUR_ICESKIN );
    effect eStorm = EffectVisualEffect( VFX_FNF_ICESTORM );
    effect eBurst = EffectVisualEffect( VFX_IMP_FROST_L );
    location lTarget = GetSpellTargetLocation( );
    int nCasterLvl  = GetCasterLevel( oPC );

    //duration
    float fDur = TurnsToSeconds( nCasterLvl );
    if( GetMetaMagicFeat() == METAMAGIC_EXTEND )
    {
        float fDur = ( fDur * 2 );
    }

    //requires crystal from the job system
    if ( !HasItemByTag( oPC, "ds_j_res_197" ) )
    {
        SendMessageToPC( oPC, "You've run out of crystal and your spell fails!" );
        return;
    }
    DestroyObject( GetItemPossessedBy( oPC, "ds_j_res_197" ) );

    // Checks to see if target is the Caster, creates a Sphere, else a Wall
    if ( oTarget == oPC )
    {
        //prep sphere's new tag based on how many spheres already cast (for tracking)
        int nSphere = GetLocalInt( oPC, "IceSphere" );
        nSphere = nSphere + 1;
        string sSphere = IntToString( nSphere );
        SetLocalInt( oPC, "IceSphere", nSphere );

        SetFacing( 90.0 );

        float fDir = GetFacing( oPC );
        float fAngle45 = GetHalfLeftDirection( fDir );
        float fAngle135 = GetFarLeftDirection( fDir );
        float fAngle225 = GetFarRightDirection( fDir );
        float fAngle315 = GetHalfRightDirection( fDir );
        location lSphere1 = GenerateNewLocation( oPC, DISTANCE_SHORT, fAngle315, fDir);
        location lSphere2 = GenerateNewLocation( oPC, DISTANCE_SHORT, fAngle135, fDir);
        location lSphere3 = GenerateNewLocation( oPC, DISTANCE_SHORT, fAngle45, fDir);
        location lSphere4 = GenerateNewLocation( oPC, DISTANCE_SHORT, fAngle225, fDir);
        location lPC = GetLocation( oPC );

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eStorm, lPC);

        CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "pc_ice_sphere", lSphere1, FALSE, "SphereFR_"+sSphere, fDur );
        CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "pc_ice_sphere", lSphere2, FALSE, "SphereBL_"+sSphere, fDur );
        CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "pc_ice_sphere", lSphere3, FALSE, "SphereFL_"+sSphere, fDur );
        CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "pc_ice_sphere", lSphere4, FALSE, "SphereBR_"+sSphere, fDur );
        DelayCommand( 0.1, SetFacing( 90.0 ) );
        DelayCommand( 0.2, AssignCommand( GetNearestObjectByTag( "SphereFR_"+sSphere ), (SetFacing( 270.0 ) ) ) );
        DelayCommand( 0.3, SetFacing( 270.0 ) );
        DelayCommand( 0.4, AssignCommand( GetNearestObjectByTag( "SphereBL_"+sSphere ), (SetFacing( 90.0 ) ) ) );
        DelayCommand( 0.5, SetFacing( 180.0 ) );
        DelayCommand( 0.6, AssignCommand( GetNearestObjectByTag( "SphereFL_"+sSphere ), (SetFacing( 0.0 ) ) ) );
        DelayCommand( 0.7, SetFacing( 0.0 ) );
        DelayCommand( 0.8, AssignCommand( GetNearestObjectByTag( "SphereBR_"+sSphere ), (SetFacing( 180.0 ) ) ) );
        DelayCommand( 0.9, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eIce, GetNearestObjectByTag( "SphereFR_"+sSphere ) ) );
        DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eIce, GetNearestObjectByTag( "SphereBL_"+sSphere ) ) );
        DelayCommand( 1.1, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eIce, GetNearestObjectByTag( "SphereFL_"+sSphere ) ) );
        DelayCommand( 1.2, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eIce, GetNearestObjectByTag( "SphereBR_"+sSphere ) ) );
        DelayCommand( 1.3, SetLocalInt( GetNearestObjectByTag( "SphereFR_"+sSphere), "CasterLevel", nCasterLvl ) );
        DelayCommand( 1.4, SetLocalInt( GetNearestObjectByTag( "SphereBL_"+sSphere), "CasterLevel", nCasterLvl ) );
        DelayCommand( 1.5, SetLocalInt( GetNearestObjectByTag( "SphereFL_"+sSphere), "CasterLevel", nCasterLvl ) );
        DelayCommand( 1.6, SetLocalInt( GetNearestObjectByTag( "SphereBR_"+sSphere), "CasterLevel", nCasterLvl ) );
        DelayCommand( 1.7, SetLocalInt( GetNearestObjectByTag( "SphereFR_"+sSphere), "SphereNumber", nSphere ) );
        DelayCommand( 1.8, SetLocalInt( GetNearestObjectByTag( "SphereBL_"+sSphere), "SphereNumber", nSphere ) );
        DelayCommand( 1.9, SetLocalInt( GetNearestObjectByTag( "SphereFL_"+sSphere), "SphereNumber", nSphere ) );
        DelayCommand( 2.0, SetLocalInt( GetNearestObjectByTag( "SphereBR_"+sSphere), "SphereNumber", nSphere ) );
    }
    else
    {
        if( ReflexSave( oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, OBJECT_SELF ) >= 1 )
        {
            //if save is successful, don't make a wall
            return;
        }
        //prep wall's new tag based on how many walls already cast (for tracking)
        int nWall = GetLocalInt( oPC, "IceWall" );
        nWall = nWall + 1;
        string sWall = IntToString( nWall );
        sWall = "wall_of_ice_"+sWall;
        SetLocalInt( oPC, "IceWall", nWall );

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eStorm, lTarget );

        //small wall if pre-epic, large wall if epic caster
        if( nCasterLvl >= 21 )
        {
            CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "pc_big_ice_wall", lTarget, FALSE, sWall, fDur );
        }
        else if( nCasterLvl <= 20 )
        {
            CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "pc_ice_wall", lTarget, FALSE, sWall, fDur );
        }
        DelayCommand( 0.1, TurnToFaceObject( oPC, GetNearestObjectByTag( sWall ) ) );
        DelayCommand( 0.2, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eIce, GetNearestObjectByTag( sWall ) ) );
        DelayCommand( 0.3, SetLocalInt( GetNearestObjectByTag( sWall), "CasterLevel", nCasterLvl ) );
    }
}

void ShieldofPeace( object oPC ){


    int nSpellDCBonus;

    nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_ABJURATION );

    if ( GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD) ) {
        RemoveEffectsBySpell(oPC, SPELL_ELEMENTAL_SHIELD );
    }
    if ( GetHasSpellEffect(SPELL_DEATH_ARMOR) ) {
        RemoveEffectsBySpell(oPC, SPELL_DEATH_ARMOR );
    }
    if ( GetHasSpellEffect(SPELL_WOUNDING_WHISPERS) ) {
        RemoveEffectsBySpell(oPC, SPELL_WOUNDING_WHISPERS );
    }
    if ( GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH) ) {
        RemoveEffectsBySpell(oPC, SPELL_MESTILS_ACID_SHEATH );
    }

    int nCL = GetCasterLevel( oPC );

    effect eOwStopthat = EffectDamageShield( nCL*2, DAMAGE_BONUS_1d6, DAMAGE_TYPE_DIVINE );
           eOwStopthat = EffectLinkEffects( eOwStopthat, EffectVisualEffect( VFX_DUR_AURA_PULSE_ORANGE_WHITE ) );
           //We'll set the effect to be death armor so the other spells don't stack
           eOwStopthat = SetEffectSpellID( eOwStopthat, SPELL_DEATH_ARMOR );
           eOwStopthat = SetEffectScript( eOwStopthat, "td_effect_end" );
           eOwStopthat = SetEffectCasterLevel( eOwStopthat, nCL );

    object oArmor = GetItemInSlot( INVENTORY_SLOT_CHEST, oPC );

    if( GetIsObjectValid( oArmor ) ){

        SetLocalString( oArmor, "onhit_script", "td_cust_onhit" );
        SetLocalInt( oArmor, "onhit_type", 1 );
        SetLocalInt( oArmor, "ShieldOfPeaceDC", GetSpellSaveDC( )+nSpellDCBonus );
        SetLocalInt( oArmor, "ShieldOfPeaceEffect", GetEffectID( eOwStopthat ) );
        itemproperty ip = ItemPropertyOnHitCastSpell( IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, nCL );
        AddItemProperty( DURATION_TYPE_TEMPORARY, ip, oArmor, RoundsToSeconds( nCL ) );
    }
    else
        SendMessageToPC( oPC, "Onhit daze ignored! You're naked!" );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eOwStopthat, oPC, RoundsToSeconds( nCL ) );
    DelayCommand( 6.0, Concentration( oPC, SPELL_DEATH_ARMOR ) );
}

void SkeletalDeliquescence( object oPC, object oTarget )
{
    effect ePolymorph = EffectPolymorph( 215, TRUE );
    effect eDaze = EffectDazed();
    effect eSlow = EffectMovementSpeedDecrease(61);
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    effect eLink = EffectLinkEffects( ePolymorph, eDaze );
           eLink = EffectLinkEffects( eSlow, eLink );
           eLink = EffectLinkEffects( eImmune, eLink);
           eLink = SupernaturalEffect(eLink);

    effect eVFX1 = EffectVisualEffect( VFX_IMP_SLOW );
    effect eVFX2 = EffectVisualEffect( VFX_FNF_PWSTUN );
    effect eVFX3 = EffectVisualEffect( VFX_IMP_FORTITUDE_SAVING_THROW_USE );
    float fDelay = GetRandomDelay( 0.4, 1.1 );
    int nSpellDCBonus;
    int nCasterLvl = GetCasterLevel( oPC );
    int nSave;

    // Checks to see if object is Creature
    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE )
    {
        SendMessageToPC( oPC, "You can't Polymorph that!" );
        return;
    }

    //Doesn't work if they don't have a skeletal structure
    if( GetRacialType( oTarget ) == RACIAL_TYPE_CONSTRUCT ||
        GetRacialType( oTarget ) == RACIAL_TYPE_ELEMENTAL ||
        GetRacialType( oTarget ) == RACIAL_TYPE_OOZE )
    {
        SendMessageToPC( oPC, "You can't Polymorph that!" );
        return;
    }


    // Doesn't work on friendlies
    if( GetIsReactionTypeFriendly( oTarget ) )
    {
        return;
    }

    // Only proceed on successful ranged touch attack
    if( TouchAttackRanged( oTarget ) == 0 )
    {
        return;
    }


    nSpellDCBonus = SetSpellSchool( oPC, SPELL_SCHOOL_TRANSMUTATION );

    //Make an SR check
    if( !MyResistSpell( oPC, oTarget, fDelay ) )
    {
        SignalEvent( oTarget, EventSpellCastAt( oPC, DC_SPELL_R_8 ) );

        if( GetLocalInt( oTarget, "ReadSchematic") != 2 )
        {
            nSave = MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC() + nSpellDCBonus, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay);
        }
        else
        {
            nSave = 0;
        }

        if(nSave == 0)
        {
            // Target fails save, it has visual effects applied.
            string sName = GetName( oTarget );
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX1, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX2, oTarget);
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePolymorph, oTarget, TurnsToSeconds( nCasterLvl ) );

            AssignCommand( oTarget, SpeakString( "*collapses into a heap as all bones and hard tissue are turned to mush, reducing "+sName+" to an immobile, ooze-like shape*" ) );
        }
        else
        {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX3, oTarget );
        }
    }
}

void MassDeathWard( object oPC )
{
    //Declare major variables
    effect eDeath = EffectImmunity(IMMUNITY_TYPE_DEATH);
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    float fDelay;

    int nDuration = GetCasterLevel(oPC);
    int nMaxTarget = nDuration / 3;
    int nTarget;

    if( nMaxTarget < 1 )
    {
        nMaxTarget = 1;
    }

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC));
    while(GetIsObjectValid(oTarget) && nTarget < nMaxTarget)
    {
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            fDelay = GetRandomDelay(0.4, 1.1);
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DEATH_WARD, FALSE));
            //Apply VFX impact and death immunity effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeath, oTarget, NewHoursToSeconds(nDuration));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            nTarget++;
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC));
    }
}

void LesserLeyRecall( object oPC )
{
    effect eVis = EffectVisualEffect(472);
    //check for hostiles
    object oEnemy = GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC );
    if ( GetIsObjectValid( oEnemy ) && GetDistanceBetween( oPC, oEnemy ) < 20.0 ){

        SendMessageToPC( oPC, "Your cowardly portal fails to materialise because hostiles are nearby." );
        return;
    }

     //go to home location
    object oWP = GetWaypointByTag( GetStartWaypoint( oPC, TRUE ) );

    object oPLC;
    oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_ley_light", GetLocation( oPC ) );
    DestroyObject( oPLC, 4.0 );
    DelayCommand( 2.5, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, GetLocation( oPC ) ) );
    DelayCommand( 3.0, JumpToObject( oWP ) );
}

void Orcbane( object oPC )
{
    object oWeapon = IPGetTargetedOrEquippedMeleeWeapon();

    effect eVis1    = EffectVisualEffect( VFX_IMP_PULSE_HOLY );
    int nCasterLevel = GetCasterLevel(oPC);
    int nDamage;

    // Configure the damage.
    if( nCasterLevel >= 20 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d8;
    else
        nDamage                     = IP_CONST_DAMAGEBONUS_1d6;

    itemproperty ipDamage  = ItemPropertyDamageBonusVsRace( IP_CONST_RACIALTYPE_HUMANOID_ORC, IP_CONST_DAMAGETYPE_MAGICAL, nDamage );
    itemproperty ipSlay    = ItemPropertyOnHitProps( IP_CONST_ONHIT_SLAYRACE, IP_CONST_ONHIT_SAVEDC_20, IP_CONST_RACIALTYPE_HUMANOID_ORC );
    itemproperty ipVFX     = ItemPropertyVisualEffect( ITEM_VISUAL_HOLY );

    // Apply effects.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis1, oPC );
    IPSafeAddItemProperty( oWeapon, ipDamage, TurnsToSeconds( nCasterLevel ), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );
    IPSafeAddItemProperty( oWeapon, ipSlay, TurnsToSeconds( nCasterLevel ), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );
    IPSafeAddItemProperty( oWeapon, ipVFX, TurnsToSeconds( nCasterLevel ), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );
}

void EarthenGrasp( object oPC, object oTarget )
{
    effect  eVFX1       = EffectVisualEffect( VFX_IMP_PULSE_NATURE );
    effect  eVFX2       = EffectVisualEffect( VFX_IMP_REFLEX_SAVE_THROW_USE );

    effect  eDur1       = EffectVisualEffect( VFX_DUR_STONEHOLD );
    effect  eStop       = EffectCutsceneImmobilize();

    int     nDuration   = GetCasterLevel( oPC ) / 2 ;

    // Checks to see if object is Creature
    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE ) {
        SendMessageToPC( oPC, "You can't affect that!" );
        return;
    }

    SignalEvent(oTarget, EventSpellCastAt(oPC, DC_SPELL_R_9));

    effect eLink        = EffectLinkEffects( eDur1, eStop );

    // Can't damage friendlies, prevents damaging party members, No PvP abuse etc.
    if( !GetIsReactionTypeFriendly( oTarget ) )
    {
        if( !MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL, OBJECT_SELF ) )
        {
            // Target fails save, it has visual effects applied.
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oTarget );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nDuration ) );
            DelayCommand( 6.0, Concentration( oPC, DC_SPELL_R_9, oTarget ) );
        }
        else
        {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oTarget );
        }
    }
}

void PlanarAnchor( object oPC )
{
    int nCL = GetCasterLevel( oPC );

    //Check for metamagic extension
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nCL = nCL * 2;  //Duration is +100%
    }

    effect eVFX     = EffectVisualEffect( VFX_FNF_SOUND_BURST_SILENT );
    effect eVFX2    = EffectVisualEffect( VFX_IMP_KNOCK );
    effect eBeam;
    effect eImmune1 = EffectSpellImmunity( SPELL_DISMISSAL );
    effect eImmune2 = EffectSpellImmunity( SPELL_BANISHMENT );
    effect eImmune3 = EffectSpellImmunity( SPELL_WORD_OF_FAITH );

    object oPLC;
    object oLastPLC;
    object oFirstPLC;
    object oArea = GetArea( oPC );

    location lLocation;
    location lTarget         = GetLocation( oPC );

    float fAngle;

    vector vNewPos;

    SignalEvent(oPC, EventSpellCastAt(oPC, DC_SPELL_S_5));

    effect eLink = EffectLinkEffects( eImmune1, eImmune2 );
    eLink        = EffectLinkEffects( eLink, eImmune3 );

    // Create a circle of plcs around the base one.
    int x;
    for ( x = 0; x < 6; x++ )
    {
        vNewPos         = GetChangedPosition( GetPositionFromLocation(lTarget), 3.0, fAngle );
        lLocation       = Location( oArea, Vector( vNewPos.x, vNewPos.y, vNewPos.z + 1.00 ), 0.0 );
        oPLC            = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_anchor", lLocation );
        fAngle          = fAngle + 60;

        if( x > 0 )
        {
            eBeam = EffectBeam( VFX_BEAM_CHAIN, oLastPLC, BODY_NODE_CHEST );
            DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oPLC, 3.5 ) );
        }
        else
        {
            oFirstPLC = oPLC;
        }

        DelayCommand( 0.6, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oPLC ) );

        oLastPLC = oPLC;

        DestroyObject( oPLC, 2.5 );
    }

    eBeam = EffectBeam( VFX_BEAM_CHAIN, oLastPLC, BODY_NODE_CHEST );
    DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oFirstPLC, 3.0 ) );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, HoursToSeconds( nCL ) );
}

void Antithetic( object oPC, object oTarget )
{
    if( !GetIsBlocked( oTarget, "synthesis_on" ) )
    {
        SendMessageToPC( oPC, "The target does not have an affinity with the shade." );
        return;
    }

    if( d20() == 1 )
    {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetCurrentHitPoints( oPC ) / 2, DAMAGE_TYPE_MAGICAL ), oPC );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DESTRUCTION ), oPC );
        SendMessageToPC( oPC, "Catastrophic failure!" );
        return;
    }

    if( ( !GetSlashingWeapon( GetWeapon( oTarget ) ) ) && ( !GetPiercingWeapon( GetWeapon( oTarget ) ) ) )
    {
        SendMessageToPC( oPC, "This ability only works on slashing and piercing weapons!" );
        return;
    }

    object oWeapon = IPGetTargetedOrEquippedMeleeWeapon();

    if ( GetHasSpellEffect( SPELL_DARKFIRE, oWeapon ) || GetHasSpellEffect( SPELL_FLAME_WEAPON, oWeapon ) )
    {
        SendMessageToPC( oPC, "This ability may not be used with Flame Weapon or Darkfire!" );
        return;
    }

    if ( GetHasSpellEffect( 873, oWeapon ) || GetHasSpellEffect( 879, oWeapon ) || GetHasSpellEffect( 887, oWeapon ) )
    {
        RemoveEffectsFromSpell( oWeapon, 873 );
        RemoveEffectsFromSpell( oWeapon, 879 );
        RemoveEffectsFromSpell( oWeapon, 887 );
        SendMessageToPC( oPC, "Removing previous Augmentation..." );
    }

    effect eVis1    = EffectVisualEffect( VFX_IMP_PULSE_COLD );

    float fDuration = TurnsToSeconds( GetLevelByClass( CLASS_TYPE_WIZARD, oPC ) + GetLevelByClass( CLASS_TYPE_BARD, oPC ) + GetLevelByClass( CLASS_TYPE_SORCERER, oPC ) );
    int nCasterLevel = GetLevelByClass( CLASS_TYPE_WIZARD, oPC ) + GetLevelByClass( CLASS_TYPE_BARD, oPC ) + GetLevelByClass( CLASS_TYPE_SORCERER, oPC );
    int nDamage;

    // Configure the damage.
    if(         nCasterLevel >= 21 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d8;
    else if(    nCasterLevel >= 15 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d6;
    else if(    nCasterLevel >= 10 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d4;
    else
        nDamage                     = IP_CONST_DAMAGEBONUS_1;

    itemproperty ipDamage = ItemPropertyDamageBonus( IP_CONST_DAMAGETYPE_COLD, nDamage );

    // Apply effects.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis1, oTarget );
    IPSafeAddItemProperty( oWeapon, ipDamage, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );
}

void Ingenious( object oPC, object oTarget )
{
    if( !GetIsBlocked( oTarget, "synthesis_on" ) )
    {
        SendMessageToPC( oPC, "The target does not have an affinity with the shade." );
        return;
    }

    if( d20() == 1 )
    {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetCurrentHitPoints( oPC ) / 2, DAMAGE_TYPE_MAGICAL ), oPC );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DESTRUCTION ), oPC );
        SendMessageToPC( oPC, "Catastrophic failure!" );
        return;
    }

    if( ( !GetSlashingWeapon( GetWeapon( oTarget ) ) ) && ( !GetPiercingWeapon( GetWeapon( oTarget ) ) ) )
    {
        SendMessageToPC( oPC, "This ability only works on slashing and piercing weapons!" );
        return;
    }

    object oWeapon = IPGetTargetedOrEquippedMeleeWeapon();

    if ( GetHasSpellEffect( SPELL_DARKFIRE, oWeapon ) || GetHasSpellEffect( SPELL_FLAME_WEAPON, oWeapon ) )
    {
        SendMessageToPC( oPC, "This ability may not be used with Flame Weapon or Darkfire!" );
        return;
    }

    if ( GetHasSpellEffect( 873, oWeapon ) || GetHasSpellEffect( 879, oWeapon ) || GetHasSpellEffect( 887, oWeapon ) )
    {
        RemoveEffectsFromSpell( oWeapon, 873 );
        RemoveEffectsFromSpell( oWeapon, 879 );
        RemoveEffectsFromSpell( oWeapon, 887 );
        SendMessageToPC( oPC, "Removing previous Augmentation..." );
    }

    effect eVis1    = EffectVisualEffect( VFX_IMP_PULSE_NATURE );

    float fDuration = TurnsToSeconds( GetLevelByClass( CLASS_TYPE_WIZARD, oPC ) + GetLevelByClass( CLASS_TYPE_BARD, oPC ) + GetLevelByClass( CLASS_TYPE_SORCERER, oPC ) );
    int nCasterLevel = GetLevelByClass( CLASS_TYPE_WIZARD, oPC ) + GetLevelByClass( CLASS_TYPE_BARD, oPC ) + GetLevelByClass( CLASS_TYPE_SORCERER, oPC );
    int nDamage;

    // Configure the damage.
    if(         nCasterLevel >= 21 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d8;
    else if(    nCasterLevel >= 15 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d6;
    else if(    nCasterLevel >= 10 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d4;
    else
        nDamage                     = IP_CONST_DAMAGEBONUS_1;

    itemproperty ipDamage       = ItemPropertyDamageBonus( IP_CONST_DAMAGETYPE_BLUDGEONING, nDamage );
    itemproperty ipMeleeType    = ItemPropertyExtraMeleeDamageType( IP_CONST_DAMAGETYPE_BLUDGEONING );

    // Apply effects.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis1, oTarget );
    IPSafeAddItemProperty( oWeapon, ipDamage, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );
    IPSafeAddItemProperty( oWeapon, ipMeleeType, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );
}

void EdgeWoundEffect( object oPC ) {

    // Variables
    int nWoundDamage = 0;

    // Set damage based on how many wounding effects are currently active.
    if ( GetIsBlocked( oPC, "EOW_WOUND_5" ) ) {

        nWoundDamage = nWoundDamage + 2;
    }
    if ( GetIsBlocked( oPC, "EOW_WOUND_4" ) ) {

        nWoundDamage = nWoundDamage + 2;
    }
    if ( GetIsBlocked( oPC, "EOW_WOUND_3" ) ) {

        nWoundDamage = nWoundDamage + 2;
    }
    if ( GetIsBlocked( oPC, "EOW_WOUND_2" ) ) {

        nWoundDamage = nWoundDamage + 2;
    }
    if ( GetIsBlocked( oPC, "EOW_WOUND_1" ) ) {

        nWoundDamage = nWoundDamage + 2;
    }

    // If player is resting or dead, end the effects.
    if ( ( GetIsResting( oPC ) ) || ( GetIsDead( oPC ) ) ) {

        SetBlockTime( oPC, 0, 0, "EOW_WOUND_1" );
        SetBlockTime( oPC, 0, 0, "EOW_WOUND_2" );
        SetBlockTime( oPC, 0, 0, "EOW_WOUND_3" );
        SetBlockTime( oPC, 0, 0, "EOW_WOUND_4" );
        SetBlockTime( oPC, 0, 0, "EOW_WOUND_5" );

    } else {

        // If any wounding damage, apply it and set the function to run next round.
        if ( nWoundDamage ) {

            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( nWoundDamage, DAMAGE_TYPE_MAGICAL ), oPC );
            DelayCommand( 6.0, EdgeWoundEffect( oPC ) );
        }
    }
}

void EdgeOfWilting( object oPC, object oTarget ) {

    // Variables.
    object          oWeapon         = IPGetTargetedOrEquippedMeleeWeapon();
    effect          eVis1           = EffectVisualEffect( VFX_IMP_PULSE_NEGATIVE );
    int             nCasterLevel    = GetLevelByClass( CLASS_TYPE_WIZARD, oPC ) + GetLevelByClass( CLASS_TYPE_BARD, oPC ) + GetLevelByClass( CLASS_TYPE_SORCERER, oPC );
    float           fDuration       = TurnsToSeconds( nCasterLevel );
    int             nDamage;
    itemproperty    ipDamage;
    itemproperty    ipOnHitDaze     = ItemPropertyOnHitProps( IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS );
    itemproperty    ipEvilGlow      = ItemPropertyVisualEffect( ITEM_VISUAL_EVIL );

    if( !GetIsBlocked( oTarget, "synthesis_on" ) ) {

        SendMessageToPC( oPC, "The target does not have an affinity with the shade." );
        return;
    }

    if( d20() == 1 ) {

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetCurrentHitPoints( oPC ) / 2, DAMAGE_TYPE_MAGICAL ), oPC );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DESTRUCTION ), oPC );
        SendMessageToPC( oPC, "Catastrophic failure!" );
        return;
    }

    if( ( !GetSlashingWeapon( GetWeapon( oTarget ) ) ) && ( !GetPiercingWeapon( GetWeapon( oTarget ) ) ) ) {

        SendMessageToPC( oPC, "This ability only works on slashing and piercing weapons!" );
        return;
    }

    if ( GetHasSpellEffect( SPELL_DARKFIRE, oWeapon ) || GetHasSpellEffect( SPELL_FLAME_WEAPON, oWeapon ) ) {

        SendMessageToPC( oPC, "This ability may not be used with Flame Weapon or Darkfire!" );
        return;
    }

    if ( GetHasSpellEffect( 873, oWeapon ) || GetHasSpellEffect( 879, oWeapon ) || GetHasSpellEffect( 887, oWeapon ) ) {
        RemoveEffectsFromSpell( oWeapon, 873 );
        RemoveEffectsFromSpell( oWeapon, 879 );
        RemoveEffectsFromSpell( oWeapon, 887 );
        SendMessageToPC( oPC, "Removing previous Augmentation..." );
    }

    // Configure the damage.
    if(         nCasterLevel >= 21 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d8;
    else if(    nCasterLevel >= 15 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d6;
    else if(    nCasterLevel >= 10 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d4;
    else
        nDamage                     = IP_CONST_DAMAGEBONUS_1;

    ipDamage = ItemPropertyDamageBonus( IP_CONST_DAMAGETYPE_MAGICAL, nDamage );

    // Apply effects.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis1, oTarget );
    IPSafeAddItemProperty( oWeapon, ipDamage, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );
    IPSafeAddItemProperty( oWeapon, ipOnHitDaze, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE );
    IPSafeAddItemProperty( oWeapon, ipEvilGlow, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE );

    // Configure wounding effect.
    if ( GetIsBlocked( oPC, "EOW_WOUND_5" ) ) {

        // If five wounding effects are active, don't create another.
        return;

    } else if ( GetIsBlocked( oPC, "EOW_WOUND_4" ) ) {

        // Set a fifth block time.
        SetBlockTime( oPC, 0, FloatToInt( fDuration ), "EOW_WOUND_5" );

    } else if ( GetIsBlocked( oPC, "EOW_WOUND_3" ) ) {

        // Set a fourth block time.
        SetBlockTime( oPC, 0, FloatToInt( fDuration ), "EOW_WOUND_4" );

    } else if ( GetIsBlocked( oPC, "EOW_WOUND_2" ) ) {

        // Set a third block time.
        SetBlockTime( oPC, 0, FloatToInt( fDuration ), "EOW_WOUND_3" );

    } else if ( GetIsBlocked( oPC, "EOW_WOUND_1" ) ) {

        // Set a second block time.
        SetBlockTime( oPC, 0, FloatToInt( fDuration ), "EOW_WOUND_2" );

    } else {

        // Set the first block time, and start the wound function.
        SetBlockTime( oPC, 0, FloatToInt( fDuration ), "EOW_WOUND_1" );
        DelayCommand( 6.0, EdgeWoundEffect( oPC ) );
    }
}
