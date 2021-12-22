#include "nwnx_effects"

void TeneborusTempoEnd( object oPC );
void ShieldOfPeaceEnd( object oPC );

void main( ){

    effect eEffect = GetLastEffect( );
    object oPC     = OBJECT_SELF;

    switch( GetEffectSpellId( eEffect ) ){

        //Teneborus Tempo
        case 9630: TeneborusTempoEnd( oPC ); break;
        case SPELL_DEATH_ARMOR: ShieldOfPeaceEnd( oPC ); break;
        default: break;
    }
}

void ShieldOfPeaceEnd( object oPC ){

    object oArmor = GetItemInSlot( INVENTORY_SLOT_CHEST, oPC );
    if( GetIsObjectValid( oArmor ) ){

        itemproperty ip = GetFirstItemProperty( oArmor );
        while( GetIsItemPropertyValid( ip ) ){

            if( GetItemPropertyDurationType( ip ) == DURATION_TYPE_TEMPORARY && GetItemPropertyType( ip ) == ITEM_PROPERTY_ONHITCASTSPELL ){
                RemoveItemProperty( oArmor, ip );
            }

            ip = GetNextItemProperty( oArmor );
        }

        DeleteLocalInt( oArmor, "ShieldOfPeaceDC" );
        DeleteLocalInt( oArmor, "ShieldOfPeaceEffect" );
        DeleteLocalInt( oArmor, "onhit_type" );
        DeleteLocalString( oArmor, "onhit_script" );
    }
}

void TeneborusTempoEnd( object oPC ){

    effect eEffect = GetFirstEffect( oPC );
    while( GetIsEffectValid( eEffect ) ){

        if( GetEffectSpellId( eEffect ) == 9630 ){

            RemoveEffect( oPC, eEffect );
        }

        eEffect = GetNextEffect( oPC );
    }

    if( GetIsInCombat( oPC ) ){

        SendMessageToPC( oPC, "Tenebrous Tempo: You are in combat!" );
        return;
    }

    int nD20 = d20();
    int nTumble = GetSkillRank( SKILL_TUMBLE, oPC );

    if( ( nD20 + nTumble ) < 55 ){

        SendMessageToPC( oPC, "Tenebrous Tempo: *Failure* "+IntToString( nD20 )+" + "+IntToString( nTumble )+ " = "+IntToString( nD20+nTumble )+" Vs. DC: 55" );
        return;
    }
    else
        SendMessageToPC( oPC, "Tenebrous Tempo: *Success* "+IntToString( nD20 )+" + "+IntToString( nTumble )+ " = "+IntToString( nD20+nTumble )+" Vs. DC: 55" );

    effect eShadow = EffectLinkEffects( EffectMovementSpeedIncrease( 50 ), EffectVisualEffect( VFX_DUR_AURA_PULSE_GREY_BLACK ) );
    eShadow = SetEffectScript( eShadow, "td_effect_end" );
    eShadow = SetEffectSpellID( eShadow, 9630 );
    //eShadow = SetEffectExpireOnHostileAction( eShadow );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( eShadow ), oPC, RoundsToSeconds( 5 ) );

}

