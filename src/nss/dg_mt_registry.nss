/*  dg_mt_registry

    --------
    Verbatim
    --------
    If the player has an insignia, he/she awakens the registry.  At that point
    a second player without an insignia and enough caster levels can bind to
    the registry and receive an insignia thenselves.  If the registry is awake
    and a player attempts to use it without enough levels, they turn into a chicken.

    ---------
    Changelog
    ---------

    Date        Name        Reason
    ------------------------------------------------------------------
    032008      dg          Initial Release
    ------------------------------------------------------------------


*/

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


void PlaySuccessVisual( object oPC )
{
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION),
        oPC
    );

    ActionResumeConversation( );
}

void PlayFailureVisual( object oPC )
{
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1),
        oPC
    );

    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        EffectPolymorph(POLYMORPH_TYPE_CHICKEN),
        oPC,
        15.0
    );

    ActionResumeConversation( );
}


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = GetLastUsedBy();
    object oTome    = OBJECT_SELF;
    int nAwake      = GetLocalInt( oTome, "Awake" );
    effect eChicken = EffectPolymorph( POLYMORPH_TYPE_CHICKEN, TRUE );
    effect eMorph   = EffectVisualEffect( VFX_IMP_POLYMORPH );
    effect eSleep   = EffectVisualEffect( VFX_IMP_SLEEP );
    effect eAwake   = EffectVisualEffect( VFX_IMP_IMPROVE_ABILITY_SCORE );

    //I am not sure if nHasInsignia is the same as the registry being 'Awakened'.
    //I am scripting it as such.

    //If the registry is alseep & the player has the insignia,
    if( nAwake == 0 && GetPCKEYValue( oPC, "bp_2" ) == 2 ){

        //The registry is renamed to Awakened
        SetName( oTome, "Awakened Registry" );

        //and the variable is set to true (awake)
        SetLocalInt( oTome, "Awake", 1 );

        //This applies a little effect to show that it is awake.
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eAwake, oTome );

        AssignCommand( oTome, SpeakString( "*yawns* Ooooawww. Whassup?" ) );

        RecomputeStaticLighting( GetArea( OBJECT_SELF ) );

        //This makes the tome show it's going back to sleep.
        DelayCommand( 20.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eSleep, oTome ));

        //Set the variable back to 0 (asleep)
        DelayCommand( 20.0, SetLocalInt( oTome, "Awake", 0 ));

        //Change the name back to Slumbering
        DelayCommand( 20.0, SetName( oTome, "Slumbering Registry" ));

        //Change the name back to Slumbering
        DelayCommand( 20.0, AssignCommand( oTome, SpeakString( "*falls asleep*" ) ) );

        //Change the name back to Slumbering
        DelayCommand( 20.0, RecomputeStaticLighting( GetArea( OBJECT_SELF ) ) );
    }
    else if( nAwake == 1 && GetPCKEYValue( oPC, "bp_2" ) != 2 ){

        int nArcaneLevels = GetLevelByClass( CLASS_TYPE_BARD, oPC );
        nArcaneLevels    += GetLevelByClass( CLASS_TYPE_SORCERER, oPC );
        nArcaneLevels    += GetLevelByClass( CLASS_TYPE_WIZARD, oPC );

        ActionPauseConversation( );
        ActionCastFakeSpellAtObject( SPELL_SUMMON_CREATURE_VIII, oPC );

        if ( nArcaneLevels >= 3 ) {

            object oInsignia = GetItemPossessedBy( oPC, "ds_insignia" );

            if ( GetIsObjectValid( oInsignia ) ){

                DestroyObject( oInsignia );
            }

            oInsignia = CreateItemOnObject( "ds_insignia", oPC );

            SetName( oInsignia, "Arcane Insignia" );

            SetPCKEYValue( oPC, "bp_2", 2 );

            DelayCommand( 2.5, PlaySuccessVisual(oPC) );

            AssignCommand( oTome, SpeakString( "Can I go back to sleep now?" ) );
        }
        else {

            DelayCommand( 2.5, PlayFailureVisual(oPC) );
            AssignCommand( oTome, SpeakString( "Go away! I don't want to wake up for those not experienced in the Arts!" ) );
        }
    }

    //If the tome is not awakened and the player does not have the insignia,
    //this happens.
    else if( nAwake == 0 && GetPCKEYValue( oPC, "bp_2" ) != 2 ){

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eSleep, oTome );
        AssignCommand( oTome, SpeakString( "*The Registry is fast asleep*" ) );
    }
}
