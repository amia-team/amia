#include "nwnx_effects"

//Terrah: this script is the generic onhit script

void ShieldOfPeaceProc( object oItem, object oCaster, object oTarget );
void RemoveShieldOfPeace( object oArmor );

void main( ){

    object oItem = GetSpellCastItem( );
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject( );

    if( GetIsObjectValid( oItem ) ){

        int nType = GetLocalInt( oItem, "onhit_type" );
        switch( nType ){

            case 1: ShieldOfPeaceProc( oItem, oCaster, oTarget ); break;
        }
    }
}

void RemoveShieldOfPeace( object oArmor ){

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

void ShieldOfPeaceProc( object oItem, object oCaster, object oTarget ){

    int nDC = GetLocalInt( oItem, "ShieldOfPeaceDC" );
    int nEffectID = GetLocalInt( oItem, "ShieldOfPeaceEffect" );

    if( nDC == 0 || nEffectID == 0 ){
        RemoveShieldOfPeace( oItem );
        return;
    }

    int nCL = 0;
    effect eEffect = GetFirstEffect( oCaster );
    while( GetIsEffectValid( eEffect ) ){

        if( GetEffectID( eEffect ) == nEffectID ){

            nCL=GetEffectCasterLevel( eEffect );
            break;
        }
        eEffect = GetNextEffect( oCaster );
    }

    if( nCL == 0 ){
        RemoveShieldOfPeace( oItem );
        return;
    }

    if( WillSave( oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster ) < 1 ){

        //Duration only 1 round for ranged
        if( GetWeaponRanged( GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oTarget ) ) )
            nCL = 1;

        effect eBraindamage = EffectLinkEffects( EffectDazed( ), EffectVisualEffect( VFX_DUR_MIND_AFFECTING_NEGATIVE ) );
               eBraindamage = EffectLinkEffects( eBraindamage, EffectVisualEffect( VFX_DUR_CESSATE_NEGATIVE ) );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBraindamage, oTarget, RoundsToSeconds( nCL ) );
    }
}
