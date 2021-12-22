//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_random_basic
//group:   random item stores
//used as: OnOpenStore script
//date:    dec 12 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_inc_randstore"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void CreateMasterworkArmour( );
void CreateMeleeWeapons( itemproperty ipAdd, string sPrefix, int nTagStolen=0 );
void CreateAmmo( itemproperty ipAdd, string sPrefix, int nTagStolen=0 );
void CreateThrownWeapons( itemproperty ipAdd, string sPrefix, int nTagStolen=0 );
void CreateRangedWeapons( itemproperty ipAdd, string sPrefix, int nTagStolen=0 );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    //make sure this script is only run once
    if ( GetLocalInt( OBJECT_SELF, "blocked" ) == 1 ){

        return;
    }

    SetLocalInt( OBJECT_SELF, "blocked", 1 );

    //create gear based on store name
    string sType            = GetName( OBJECT_SELF );
    itemproperty ipAdd;

    if ( sType == "General, Forge" ){

        CreateMasterworkArmour( );

        ipAdd = ItemPropertyAttackBonus( 1 );
        CreateMeleeWeapons( ipAdd, "Masterwork" );
    }
    else if ( sType == "Cordor, Fletcher" ){

        ipAdd = ItemPropertyAttackBonus( 1 );
        CreateRangedWeapons( ipAdd, "Masterwork" );
        CreateThrownWeapons( ipAdd, "Masterwork" );

        ipAdd = ItemPropertyDamageBonus( IP_CONST_DAMAGETYPE_FIRE, 1 );
        CreateAmmo( ipAdd, "Masterwork" );
    }
    else if ( sType == "General: Trainer Store" ){

        ipAdd = ItemPropertyNoDamage( );
        CreateMeleeWeapons( ipAdd, "Training", 1 );
        CreateRangedWeapons( ipAdd, "Training", 1 );
        CreateAmmo( ipAdd, "Training", 1 );
    }
}



//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void CreateMasterworkArmour( ){

    int i;
    float fDelay;
    object oItem;
    itemproperty ipAdd;

    for( i=1; i<18; ++i ){

        ipAdd = ItemPropertyACBonusVsDmgType( Random( 3 ), 1 );

        fDelay = i/10.0;

        oItem = CreateItemOnObject( GetBaseItemResRef( i ), OBJECT_SELF, 1, "m_"+GetBaseItemResRef( i ) );

        AddItemProperty( DURATION_TYPE_PERMANENT, ipAdd, oItem );

        SetName( oItem, "Masterwork "+GetName( oItem ) );

        SetInfiniteFlag( oItem );
    }
}

void CreateMeleeWeapons( itemproperty ipAdd, string sPrefix, int nTagStolen=0 ){

    int i;
    float fDelay;
    object oItem;

    for( i=20; i<50; ++i ){

        fDelay = i/10.0;

        oItem = CreateItemOnObject( GetBaseItemResRef( i ), OBJECT_SELF, 1, "m_"+GetBaseItemResRef( i ) );

        AddItemProperty( DURATION_TYPE_PERMANENT, ipAdd, oItem );

        SetName( oItem, sPrefix+" "+GetName( oItem ) );

        if ( nTagStolen ){

            SetStolenFlag( oItem, TRUE );
        }

        SetInfiniteFlag( oItem );
    }
}

void CreateRangedWeapons( itemproperty ipAdd, string sPrefix, int nTagStolen=0 ){

    int i;
    float fDelay;
    object oItem;

    for( i=60; i<66; ++i ){

        fDelay = i/10.0;

        oItem = CreateItemOnObject( GetBaseItemResRef( i ), OBJECT_SELF, 1, "m_"+GetBaseItemResRef( i ) );

        AddItemProperty( DURATION_TYPE_PERMANENT, ipAdd, oItem );

        SetName( oItem, sPrefix+" "+GetName( oItem ) );

        if ( nTagStolen ){

            SetStolenFlag( oItem, TRUE );
        }

        SetInfiniteFlag( oItem );
    }
}

void CreateAmmo( itemproperty ipAdd, string sPrefix, int nTagStolen=0 ){

    int i;
    float fDelay;
    object oItem;

    for( i=70; i<73; ++i ){

        fDelay = i/10.0;

        oItem = CreateItemOnObject( GetBaseItemResRef( i ), OBJECT_SELF, 25, "m_"+CreateRandomTag() );

        AddItemProperty( DURATION_TYPE_PERMANENT, ipAdd, oItem );

        SetName( oItem, sPrefix+" "+GetName( oItem ) );

        if ( nTagStolen ){

            SetStolenFlag( oItem, TRUE );
        }

        SetInfiniteFlag( oItem );
    }
}

void CreateThrownWeapons( itemproperty ipAdd, string sPrefix, int nTagStolen=0 ){

    int i;
    float fDelay;
    object oItem;

    for( i=80; i<83; ++i ){

        fDelay = i/10.0;

        oItem = CreateItemOnObject( GetBaseItemResRef( i ), OBJECT_SELF, 25, "m_"+CreateRandomTag() );

        AddItemProperty( DURATION_TYPE_PERMANENT, ipAdd, oItem );

        SetName( oItem, sPrefix+" "+GetName( oItem ) );

        if ( nTagStolen ){

            SetStolenFlag( oItem, TRUE );
        }

        SetInfiniteFlag( oItem );
    }
}
