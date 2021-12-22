#include "amia_include"

void MakeUndead( object oPC, string szSummonResRef  ){

    object oSummon = GetAssociate( ASSOCIATE_TYPE_SUMMONED, oPC );

    if ( GetResRef( oSummon )  != szSummonResRef  ){

        SendMessageToPC( oPC, "No animated corpse found to assign Undead abilities to!" );

        return;
    }

    if ( GetRacialType( oSummon ) == RACIAL_TYPE_UNDEAD ){

        return;
    }

    SetName( oSummon, GetName( oSummon )+" Zombie"  );

    effect eFlies   = SupernaturalEffect( EffectVisualEffect( VFX_DUR_FLIES ) );
    effect eAura    = SupernaturalEffect( EffectVisualEffect( VFX_DUR_AURA_GREEN_DARK ) );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eFlies, oSummon );
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eAura, oSummon );

    object oNewHide = CreateItemOnObject( "ds_zombiehide", oSummon );
    object oOldHide = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oSummon );

    DestroyObject( oOldHide );

    AssignCommand( oSummon, ActionEquipItem( oNewHide, INVENTORY_SLOT_CARMOUR ) );

    //for turning
    SetLocalInt( oSummon, "is_undead", 1 );
}

void main(){

    object oPC     = OBJECT_SELF;
    string sResRef = GetLocalString( GetArea( oPC ), "ds_raise" );
    float fCR      = GetLocalFloat( GetArea( oPC ), "ds_cr" );

    if ( sResRef == "" || fCR == 0.0f ){

        SendMessageToPC( oPC, "There's no corpse to raise in this area!" );
        return;
    }

    if ( fCR <= ( GetHitDice( oPC ) * 1.5 ) ){

        effect eSummon = EffectSummonCreature( sResRef, VFX_FNF_SUMMON_UNDEAD, 0.5f );

        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSummon, GetLocation( oPC ), NewHoursToSeconds( 24 ) );

        DelayCommand( 3.0, MakeUndead( oPC, sResRef ) );

        return;
    }

    SendMessageToPC( oPC, "The CR of the Zombie would be more than 1,5 times your own level!" );
}


