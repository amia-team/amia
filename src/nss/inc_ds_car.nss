
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "nw_i0_spells"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

object GetInsanityCaster();

void ApplyInsanity( object oPC );

void AddInsanity( object oPC, int nDC=16 );

void DeductInsanity( object oPC );


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


object GetInsanityCaster(){

    object oModule   = GetModule();
    object oInsanity = GetLocalObject( oModule, "insanity" );

    if ( !GetIsObjectValid( oInsanity ) ){

        oInsanity = GetObjectByTag( "ds_insanity" );

        SetLocalObject( oModule, "insanity", oInsanity );
    }

    return oInsanity;
}


void ApplyInsanity( object oPC ){

    effect eEffect = GetFirstEffect( oPC );

    while ( GetIsEffectValid( eEffect ) ){

        if ( GetEffectCreator( eEffect ) == OBJECT_SELF ){

            RemoveEffect( oPC, eEffect );
        }

        eEffect = GetNextEffect( oPC );
    }

    int nInsanityPoints = GetPCKEYValue( oPC, "insanity" );
    int nSaveNerf;
    int nAbilNerf;

    if ( nInsanityPoints == 2 ){

        SendMessageToPC( oPC, "*Mental state: Not optimal.*" );
        nSaveNerf = 1;
    }
    else if ( nInsanityPoints == 3 ||  nInsanityPoints == 4 ){

        SendMessageToPC( oPC, "*Mental state: You're going slightly mad.*" );
        nSaveNerf = 1;
        nAbilNerf = 1;
    }
    else if ( nInsanityPoints == 5 ){

        SendMessageToPC( oPC, "*Mental state: Your mental hygiene has been severely compromised.*" );
        nSaveNerf = 2;
        nAbilNerf = 1;
    }
    else if ( nInsanityPoints == 6 ||  nInsanityPoints == 7 ){

        SendMessageToPC( oPC, "*Mental state: You're with one foot in the loony bin.*" );
        nSaveNerf = 2;
        nAbilNerf = 2;
    }
    else if ( nInsanityPoints == 8 ){

        SendMessageToPC( oPC, "*Mental state: You're quite insane.*" );
        nSaveNerf = 3;
        nAbilNerf = 2;
    }
    else if ( nInsanityPoints >= 9 ){

        SendMessageToPC( oPC, "*Mental state: You're stark raving mad, completely bonkers, or in other words: utterly insane.*" );
        nSaveNerf = 3;
        nAbilNerf = 3;
    }

    if ( nAbilNerf > 0 ){

        effect eAbilNerf = EffectAbilityDecrease( ABILITY_CHARISMA, nAbilNerf );
               eAbilNerf = EffectLinkEffects( EffectAbilityDecrease( ABILITY_INTELLIGENCE, nAbilNerf ), eAbilNerf );
               eAbilNerf = EffectLinkEffects( EffectAbilityDecrease( ABILITY_WISDOM, nAbilNerf ), eAbilNerf );
               eAbilNerf = SupernaturalEffect( eAbilNerf );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eAbilNerf, oPC );
    }

    if ( nSaveNerf > 0 ){

        effect eSaveNerf = EffectSavingThrowDecrease( SAVING_THROW_WILL, nSaveNerf );
               eSaveNerf = SupernaturalEffect( eSaveNerf );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eSaveNerf, oPC );
    }

    DelayCommand( IntToFloat( d10( 10 ) ), ExecuteScript( "rua_insanity", oPC ) );
}

void AddInsanity( object oPC, int nDC=16 ){

    int nInsanityPoints = GetPCKEYValue( oPC, "insanity" );

    if ( WillSave( oPC, nDC ) < 1 ){

        ++nInsanityPoints;
    }
    else{

        return;
    }

    if (  nInsanityPoints > 10 ){

        nInsanityPoints = 10;
    }

    SetPCKEYValue( oPC, "insanity", nInsanityPoints );

    AssignCommand( GetInsanityCaster(), ApplyInsanity( oPC ) );
}

void DeductInsanity( object oPC ){

    int nInsanityPoints = GetPCKEYValue( oPC, "insanity" );

    if ( !nInsanityPoints ){

        return;
    }

    int nDie = d12();

    if ( nDie == 1 ){

        ++nInsanityPoints;

        FloatingTextStringOnCreature( "*The treatment is a spectacular failure: you sink deeper into insanity.*", oPC, FALSE );
    }
    else if ( nDie == 12 ){

        nInsanityPoints = 0;

        FloatingTextStringOnCreature( "*The treatment is a great success: you are completely cured.*", oPC, FALSE );
    }
    else if ( nDie > nInsanityPoints ){

        --nInsanityPoints;

        FloatingTextStringOnCreature( "*The treatment works: you are slightly less insane.*", oPC, FALSE );
    }
    else{

        FloatingTextStringOnCreature( "*The treatment is a failure: you're still as bonkers as before.*", oPC, FALSE );

        return;
    }

    if (  nInsanityPoints > 10 ){

        nInsanityPoints = 10;
    }

    SetPCKEYValue( oPC, "insanity", nInsanityPoints );

    AssignCommand( GetInsanityCaster(), ApplyInsanity( oPC ) );
}

