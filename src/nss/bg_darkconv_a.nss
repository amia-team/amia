/*  NPC Dark Figure :: Blackguard Item Issuer

    --------
    Verbatim
    --------
    This script scrutinizes the character for Blackguard PrC spell widgets,
    and issues them based on the PrC rank and wisdom score.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    060106    Aleph       Initial release.
    20070517  disco       simplification
    20071118  Disco       Using inc_ds_records now
    20120927  Glim        Changed to LE and NE only alignments for Hells pact
                          Trainer on Server A & changed spoken text.
    20150509  PoS         Restructured to combine Amia A and B scripts together
    ------------------------------------------------------------------
*/

//includes
#include "inc_ds_records"



// Checks if item sResRef is in oPC's inventory
// returns item object if it is, OBJECT_INVALID if it isn't
object GetResRefInInventory( object oPC, string sResRef );

// Returns the text appropriate to alignment/spell
string GetSpokenText( int nText );

void main(){

    // Variables.

    object oPC      = GetLastSpeaker( );
    object oDark    = OBJECT_SELF;
    object oModule  = GetModule();

    effect eFX      = EffectVisualEffect( VFX_IMP_HARM );
    int nClass      = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );
    int nModule     = GetLocalInt( oModule, "Module" );
    int nLawChaos   = GetAlignmentLawChaos(oPC);
    int nGoodEvil   = GetAlignmentGoodEvil(oPC);

    if ( nClass == 0 ){
        if ( nModule == 1 ) {
            ActionSpeakString( "Begone mortal, I have nothing to teach thee.", TALKVOLUME_TALK );
        } else {
            ActionSpeakString( "Begone mortal, I have nothing to teach your kind.", TALKVOLUME_TALK );
        }
        return;
    }
    if ( nModule == 1 && nLawChaos == ALIGNMENT_CHAOTIC ) {

        ActionSpeakString( "*stares at you oddly for a few moments... then simply turns his gaze away with an evident frown*", TALKVOLUME_TALK );
        return;
    }
    if ( nModule == 2 && nLawChaos == ALIGNMENT_LAWFUL ){

        ActionSpeakString( "*a deep rumble resonates within the creature, but it doesn't speak*", TALKVOLUME_TALK );
        return;
    }
    if ( GetLocalInt( oPC, "bgtalk1" ) == 0 ){
        if ( nModule == 1 ) {
            ActionSpeakString( "Only the darkest of souls may ride with the power of the Nine. Thou shalt be tested.", TALKVOLUME_TALK);
        } else {
            ActionSpeakString( "Prove yourself in blood, mortal and then I will teach you true power.", TALKVOLUME_TALK);
        }
        SetLocalInt( oPC, "bgtalk1", 1 );
        return;
    }

    //  Check for Blackguard level, base wisdom score, and make sure the player
    //  doesn't get more than one item by checking the variable.  If passed,
    //  hand out a widget.

    if ( GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) > 10 && GetLocalInt( oPC, "bg_spells1" ) != 1 ){

        if ( GetResRefInInventory( oPC, "bg_spells1" ) == OBJECT_INVALID ){

            ActionCastFakeSpellAtObject(SPELL_HARM, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oPC);
            CreateItemOnObject("bg_spells1", oPC, 1);
            DelayCommand(3.0, ActionSpeakString(GetSpokenText(1), TALKVOLUME_TALK));
            SetLocalInt( oPC, "bg_spells1", 1 );
            return;
        }
    }

    if ( GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) > 10 && GetLocalInt( oPC, "bg_spells2" ) != 1 ){

        if ( GetResRefInInventory( oPC, "bg_spells2") == OBJECT_INVALID ){

            ActionCastFakeSpellAtObject(SPELL_HARM, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oPC);
            CreateItemOnObject("bg_spells2", oPC, 1);
            DelayCommand(3.0, ActionSpeakString(GetSpokenText(2), TALKVOLUME_TALK));
            SetLocalInt( oPC, "bg_spells2", 1 );
            return;
        }
    }

    //  Unlike the other items, Aura of Despair is a special ability that is
    //  available to level 3 Blackguards regardless of wisdom score.

    if ( nClass > 2 && GetLocalInt( oPC, "bg_spells3" ) != 1 ){

        if ( GetResRefInInventory( oPC, "bg_spells3" ) == OBJECT_INVALID ){

            ActionCastFakeSpellAtObject(SPELL_HARM, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oPC);
            CreateItemOnObject("bg_spells3", oPC, 1);
            DelayCommand(3.0, ActionSpeakString(GetSpokenText(3), TALKVOLUME_TALK));
            SetLocalInt( oPC, "bg_spells3", 1 );
            return;
        }
    }

    if ( GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) > 11 && nClass > 2 && GetLocalInt( oPC, "bg_spells4" ) != 1 ){

        if ( GetResRefInInventory( oPC, "bg_spells4") == OBJECT_INVALID ){

            ActionCastFakeSpellAtObject(SPELL_HARM, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oPC);
            CreateItemOnObject("bg_spells4", oPC, 1);
            DelayCommand(3.0, ActionSpeakString(GetSpokenText(4), TALKVOLUME_TALK));
            SetLocalInt( oPC, "bg_spells4", 1 );
            return;
        }
    }


    if ( GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) > 11 && nClass > 4 && GetLocalInt( oPC, "bg_spells5" ) != 1 ){

        if ( GetResRefInInventory( oPC, "bg_spells5") == OBJECT_INVALID ){

            ActionCastFakeSpellAtObject(SPELL_HARM, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oPC);
            CreateItemOnObject("bg_spells5", oPC, 1);
            DelayCommand(3.0, ActionSpeakString(GetSpokenText(5), TALKVOLUME_TALK));
            SetLocalInt( oPC, "bg_spells5", 1 );
            return;
        }
    }

    if ( GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) > 12 && nClass > 5 && GetLocalInt( oPC, "bg_spells6" ) != 1 ){

        if ( GetResRefInInventory( oPC, "bg_spells6") == OBJECT_INVALID ){

            ActionCastFakeSpellAtObject(SPELL_HARM, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oPC);
            CreateItemOnObject("bg_spells6", oPC, 1);
            DelayCommand(3.0, ActionSpeakString(GetSpokenText(6), TALKVOLUME_TALK));
            SetLocalInt( oPC, "bg_spells6", 1 );
            return;
        }
    }

    if ( GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) > 12 && nClass > 6 && GetLocalInt( oPC, "bg_spells7" ) != 1 ){

        if ( GetResRefInInventory( oPC, "bg_spells7") == OBJECT_INVALID ){

            ActionCastFakeSpellAtObject(SPELL_HARM, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oPC);
            CreateItemOnObject("bg_spells7", oPC, 1);
            DelayCommand(3.0, ActionSpeakString(GetSpokenText(7), TALKVOLUME_TALK));
            SetLocalInt( oPC, "bg_spells7", 1 );
            return;
        }
    }

    if ( GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) > 13 && nClass > 7 && GetLocalInt( oPC, "bg_spells8" ) != 1 ){

        if ( GetResRefInInventory( oPC, "bg_spells8") == OBJECT_INVALID ){

            ActionCastFakeSpellAtObject(SPELL_HARM, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oPC);
            CreateItemOnObject("bg_spells8", oPC, 1);
            DelayCommand(3.0, ActionSpeakString(GetSpokenText(8), TALKVOLUME_TALK));
            DelayCommand(4.0,ActionPlayAnimation(ANIMATION_FIREFORGET_BOW, 1.0));
            SetLocalInt( oPC, "bg_spells8", 1 );
            return;
        }
    }

    //  He's been milked dry of widgets.
    if ( nModule == 1 ) {
        ActionSpeakString("I have nothing more to teach thee.", TALKVOLUME_TALK);
    } else {
        ActionSpeakString("I have nothing more for you, mortal.", TALKVOLUME_TALK);
    }
}

object GetResRefInInventory( object oPC, string sResRef ){

    object oItem = GetFirstItemInInventory( oPC );

    while ( GetIsObjectValid( oItem ) == TRUE ){

        if ( GetResRef( oItem ) == sResRef ){

            return oItem;
        }

        oItem = GetNextItemInInventory( oPC );
    }

    return OBJECT_INVALID;

}

string GetSpokenText( int nText ) {

    object oModule = GetModule();
    int    nModule = GetLocalInt( oModule, "Module" );

    string sText   = "";

    string sTextC1 = "With the Blessing of Corruption, your blade will become as tainted as your heart and will be as fire to those of pure intent.";
    string sTextC2 = "The Blessing of the Flesh will toughen the useless sac you call skin, more akin now to the hide of a Tanar'ri. Prove yourself further and more power awaits you.";
    string sTextC3 = "Let all mortals look upon you and know Despair, as they see certain doom in this dark Blessing.";
    string sTextC4 = "And may this Blessing cloak you in Shadow, servant of darkness. Return to me when you have grown to understand your newfound power.";
    string sTextC5 = "Use the Blessing of Darkness to give your enemies a mere taste of what awaits them in the Abyss. Return to me when you are ready for the next Blessing.";
    string sTextC6 = "Harness the Blessing of Deeper Darkness to banish the light once and for all. Make your enemies truly fear the black of night and then return to me.";
    string sTextC7 = "Draw upon this Blessing of Abyssal Might to rend the soft flesh of your enemies and fortify your own black soul. More power awaits you when you have proven yourself further.";
    string sTextC8 = "You are ready for the Final Blessing, that of the Unholy Blade. Your blade will become an instrument of death, a focus for the blackness of your soul to lay waste to the pure of heart. Go now, and use this power to champion the darkness.";
    string sTextL1 = "Thee hast proven thyself worthy of two of the Blessings, dark one. First, may the Blessing of Corruption taint thy blade to deliver exquisite agony to the pure of heart.";
    string sTextL2 = "And second, may the Blessing of the Flesh toughen thine own skin against those who would oppose thee.  Ride forth in His name... we shall speak again when it is time.";
    string sTextL3 = "Let the Blessing of Despair instill dread in all those who dare to ride against thee.";
    string sTextL4 = "And may the Blessing of Shadow cloak thee, servant of the Nine, that you may carry out His will. Return to me when thou art ready for the next Blessing.";
    string sTextL5 = "Use the Blessing of Darkness to show thine enemies the blackness of your soul. Bear witness as they lament in their doom; only then will we speak again.";
    string sTextL6 = "Harness the Blessing of Deeper Darkness to banish the light once and for all, let none bear witness to the death that descends upon them. Return to me when thou art ready.";
    string sTextL7 = "Draw upon the Blessing of Abyssal Might to strengthen thy blows and fortify thy soul. Ride out and prove yourself worthy of the final Blessing.";
    string sTextL8 = "Thou art ready for the Final Blessing, Dark One, the Blessing of the Unholy Blade. Now thy weapon can focus the might of He Who Rides, to lay waste to the pure of heart in service to the Lords Nine. Go now, and use the knowledge I have gifted you to champion their cause.";

    if ( nModule == 1 ) {
        switch( nText ) {
            case 1: sText = sTextL1;
            case 2: sText = sTextL2;
            case 3: sText = sTextL3;
            case 4: sText = sTextL4;
            case 5: sText = sTextL5;
            case 6: sText = sTextL6;
            case 7: sText = sTextL7;
            case 8: sText = sTextL8;
        }
    } else {
        switch( nText ) {
            case 1: sText = sTextC1;
            case 2: sText = sTextC2;
            case 3: sText = sTextC3;
            case 4: sText = sTextC4;
            case 5: sText = sTextC5;
            case 6: sText = sTextC6;
            case 7: sText = sTextC7;
            case 8: sText = sTextC8;
        }
    }
    return sText;
}
