/*  Amia :: Class- and Level-based Function Library

    --------
    Verbatim
    --------

    Disabled the Bioware RDD Breath Weapon feat, we're now using a wand for it instead.


    Level/Class-based Item Issuer.

        o   Blackguard rank 1+: Corrupt Weapon.
        o   Blackguard rank 3+: Demon Flesh.
        o   Blackguard rank 3+: Aura of Despair.
        o   Blackguard rank 3+: Veil of Shadow.
        o   Blackguard rank 3+: Darkness.
        o   Blackguard rank 6+: Deeper Darkness.
        o   Blackguard rank 6+: Abyssal Might.
        o   Blackguard rank 8+: Unholy Sword.

    ---

    Prerequisite Class Level Feat Checker

        o   Monk rank 3+ only allowed the Monk AC feat.
        o   Shadowdancer rank 6+ only allowed the Hide in Plain Sight feat.

    ---

    Revision History
    ----------------------------------------------------------------------------
    Date        Name        Reason
    ----------------------------------------------------------------------------
    12302005    kfw         New release.
    05232006    kfw         Code optimization and Added: Class-/Level-based item issuer.
    08112006    kfw         Bugfix: Fixed shifter support.
    08292006    kfw         Disabled RDD Breath Weapon feat (using a wand for it instead so it could be modified).
    20080603    disco       Added RDD and Paladin stuff from OnCLientEnter
    20090228    disco       Added custom RDD support
    20120217    Selmak      SDs have HIPS feat removed, applies now to creature hide.
    20140427    Glim        Added Blackguard Aura of Despair to module entry and levelup application.
    20150427    PoS         Reverted Aura of Despair behaviour to being widget based.
    20160130    FW          No longer needed HiPS fixing here.
    20180917    Hroth       Added RemoveInvis Procedure
    20190407    Tarnus      Replaced Leto calls with nwnx_creature functions

*/


// Includes
#include "nwnx_creature"
#include "logger"
#include "inc_ds_records"

/*  Prototypes  */

// Modifies character to meet Amia's specific class level and feat requirements.
void ResolvePrereqFeats( object oPC );

// Issues item to the character based on their class and levels.
void ResolveClassLevelItems( object oPC );

// Checks whether the character is polymorphed or not.
//int GetIsPolymorphed( object oPC );

// Remove invisibility as part of using a class ability.
void RemoveInvis( object oPC );

/*  Function Definitions    */

// Modifies character to meet Amia's specific class level and feat requirements.
void ResolvePrereqFeats( object oPC ){

    // Variables.
    int nRDDLevel               = GetLevelByClass( CLASS_TYPE_DRAGON_DISCIPLE, oPC );
    int nBGLevel                = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );
    int nBGAura                 = GetLocalInt( oPC, "AuraOfDespair" );
    int nShadowdancerLevel      = GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC );
    int nHasHideInPlainSight    = GetHasFeat( FEAT_HIDE_IN_PLAIN_SIGHT, oPC );
    int nHasHotPants            = GetHasFeat( FEAT_DRAGON_IMMUNE_FIRE, oPC );
    string szModification       = "";
    string szMessage            =   "- You'll be booted in 6 seconds to modify your "  +
                                    "feats according to Amia's prerequisites. -";

    // Remove RDD fire immunity
    if ( nRDDLevel ){

        if ( nHasHotPants ){

            NWNX_Creature_RemoveFeat(oPC, FEAT_DRAGON_IMMUNE_FIRE);
        }

        // rdd customizer
        SetLocalInt( oPC, "ds_RDD", GetPCKEYValue( oPC, "ds_RDD" ) );
    }

    /*  Hide in Plain Sight Prerequisite
    // Remove Feat: All SDs will now have the feat removed and re-applied to an
    // equipped creature hide (see nwnx_events).

    if( nHasHideInPlainSight ){

        //Check to see if character has a creature hide equipped
        object oHide = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oPC );

        if ( !GetIsObjectValid( oHide ) ){

            //If not, the feat must be from the feat list, remove
            szModification+="replace 'Feat', 433, DeleteParent;";

        }
        else{

            //If there is a hide, see if it has the HIPS bonus feat,
            //if not, the feat must be from the feat list, remove
            itemproperty ipHIPS = ItemPropertyBonusFeat( IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT );
            if ( !IPGetItemHasProperty( oHide, ipHIPS, DURATION_TYPE_PERMANENT ) ){

                szModification+="replace 'Feat', 433, DeleteParent;";

            }

        }
    }
    */

    //if( nHasHideInPlainSight && nShadowdancerLevel < 6 ){
    //
    //    szModification+="replace 'Feat', 433, DeleteParent;";
    //}
    //else if( !nHasHideInPlainSight && nShadowdancerLevel > 5 ){

    //    szModification+="add /FeatList/Feat, 433, gffWord;";
    //}

    /*  CHARACTER MODIFICATION  , Shifter protection.*/
    if( szModification != "" && !GetIsPolymorphed( oPC ) ){

        //freeze player
        effect eFreeze = EffectCutsceneImmobilize();
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFreeze, oPC, 4.0 );

        // Track and Report modification entry for Security purposes.
        // Variables.
        string szPlayerName     = GetPCPlayerName( oPC );
        string szCharacterName  = GetName( oPC );

        // Record in the logfiles
        WriteTimestampedLogEntry( "ResolvePrereqFeats()" );
        WriteTimestampedLogEntry( szModification );
        WriteTimestampedLogEntry( szPlayerName );
        WriteTimestampedLogEntry( szCharacterName );

        // Notify the Player.
        SendMessageToPC( oPC, szMessage );

        // Update the character.
        ExportSingleCharacter( oPC );

    }

    return;
}
void RemoveInvis( object oPC ){

    effect eEffect = GetFirstEffect( oPC );
    int nType;

    // Cycles through effects and remove invisibility, if applicable.
    while( GetIsEffectValid( eEffect ) ) {

        nType = GetEffectType( eEffect );

        if( nType == EFFECT_TYPE_INVISIBILITY ||
            nType == EFFECT_TYPE_ETHEREAL ||
            nType == EFFECT_TYPE_SANCTUARY )

            RemoveEffect( oPC, eEffect );

        eEffect = GetNextEffect( oPC );
    }
}

