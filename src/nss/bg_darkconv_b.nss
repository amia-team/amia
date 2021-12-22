/*  NPC Dark Figure :: Blackguard Item Issuer

    --------
    Verbatim
    --------
    This script scrutinizes the character for Blackguard PrC spell widgets,
    and issues them based on the PrC rank and wisdom score.

    ---------
    Changelog
    ---------
    Date     Name        Reason
    ----------------------------------------------------------------------------
    060106   Aleph       Initial release.
    20070517 Disco       simplification
    20071118 Disco       Using inc_ds_records now
    20120716 Glim        Changed to CE and NE only alignments for Abyss Pact
                         Trainer on Server B & changed spoken text.
    ----------------------------------------------------------------------------
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

        ActionSpeakString( "Begone mortal, I have nothing to teach your kind.", TALKVOLUME_TALK );
        return;
    }
    //  If you are a Blackguard but a Lawful Evil one, you have to go elsewhere!
    if ( nLawChaos == ALIGNMENT_LAWFUL ){

        ActionSpeakString( "*a deep rumble resonates within the Glabrezu, but it doesn't speak*", TALKVOLUME_TALK );
        return;
    }

    if ( GetLocalInt( oPC, "bgtalk1" ) == 0 ){

        ActionSpeakString( "Prove yourself in blood, mortal and then I will teach you true power.", TALKVOLUME_TALK);
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
            DelayCommand(3.0, ActionSpeakString("Let all mortals look upon you and know Despair, as they see certain doom in this dark Blessing.", TALKVOLUME_TALK));
            SetLocalInt( oPC, "bg_spells3", 1 );
            return;
        }
    }

    //  He's been milked dry of widgets.
    ActionSpeakString("I have nothing more for you, mortal.", TALKVOLUME_TALK);
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
