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
    ------------------------------------------------------------------
*/

//includes
#include "inc_ds_records"



// Checks if item sResRef is in oPC's inventory
// returns item object if it is, OBJECT_INVALID if it isn't
object GetResRefInInventory( object oPC, string sResRef );

void main(){

    // Variables.

    object oPC      = GetLastSpeaker( );
    object oDark    = OBJECT_SELF;
    effect eFX      = EffectVisualEffect( VFX_IMP_HARM );
    int nClass      = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );
    int nLawChaos   = GetAlignmentLawChaos(oPC);
    int nGoodEvil   = GetAlignmentGoodEvil(oPC);

    //ExecuteScript("nw_c2_default4", OBJECT_SELF);

    //  If you're not a Blackguard, shoo!
    if ( nClass == 0){

        ActionSpeakString( "Begone mortal, I have nothing to teach thee.", TALKVOLUME_TALK );
        return;
    }
    //  If you are a Blackguard but a Chaotic Evil one, you have to go elsewhere!
    if ( nLawChaos == ALIGNMENT_CHAOTIC ){

        ActionSpeakString( "*stares at you oddly for a few moments... then simply turns his gaze away with an evident frown*", TALKVOLUME_TALK );
        return;
    }

    if ( GetLocalInt( oPC, "bgtalk1" ) == 0 ){

        ActionSpeakString( "Only the darkest of souls may ride with the power of the Nine. Thou shalt be tested.", TALKVOLUME_TALK);
        SetLocalInt( oPC, "bgtalk1", 1 );
        return;
    }


    //  Unlike the other items, Aura of Despair is a special ability that is
    //  available to level 3 Blackguards regardless of wisdom score.

    if ( nClass > 2 && GetLocalInt( oPC, "bg_spells3" ) != 1 ){

        if ( GetResRefInInventory( oPC, "bg_spells3" ) == OBJECT_INVALID ){

            ActionCastFakeSpellAtObject(SPELL_HARM, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oPC);
            CreateItemOnObject("bg_spells3", oPC, 1);
            DelayCommand(3.0, ActionSpeakString("Let the Blessing of Despair instill dread in all those who dare to ride against thee.", TALKVOLUME_TALK));
            SetLocalInt( oPC, "bg_spells3", 1 );
            return;
        }
    }

    //  He's been milked dry of widgets.
    ActionSpeakString("I have nothing more to teach thee.", TALKVOLUME_TALK);
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
