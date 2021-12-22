//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_thay_mythal
//group:   MCS
//used as: OnUse script
//date:    May 05 2007
//author:  disco

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
int Convert( object oPC, object oItem, object oTarget );
int GetMythalFromThay( object oItem );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC     = GetLastUsedBy();
    object oSource = GetNearestObjectByTag( "ds_thay_box" );
    object oTarget = GetNearestObjectByTag( "ds_mythal_box" );
    int nResult    = 0;
    effect eTake   = EffectVisualEffect( VFX_IMP_CHARM );
    effect eGive   = EffectVisualEffect( VFX_IMP_BREACH );

    object oItem = GetFirstItemInInventory( oSource );

    while ( GetIsObjectValid( oItem ) == TRUE ) {

        nResult = nResult  + Convert( oPC, oItem, oTarget );

        oItem = GetNextItemInInventory( oSource );
    }

    if ( nResult ){

        SendMessageToPC( oPC, IntToString( nResult )+" Thayvian item(s) converted to Mythals." );

        //eyecandy
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eTake, oSource );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eGive, oTarget );
    }
    else{

        SendMessageToPC( oPC, "There are no Thayvian items in the left box." );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
int Convert( object oPC, object oItem, object oTarget ){

    //check if item is Thay
    int nMythal     = GetMythalFromThay( oItem );
    int nFee        = nMythal * nMythal * 10;
    string sResRef  = "mythal"+IntToString( nMythal );

    if ( nMythal > 0 ){

        if ( GetGold( oPC ) >= nFee ){

            //take gold
            TakeGoldFromCreature( nFee, oPC, TRUE );

            //create mythal in target container
            CreateItemOnObject( sResRef, oTarget );

            //destroy thay item
            DestroyObject( oItem );

            return 1;
        }
        else{

            SendMessageToPC( oPC, "You don't have enough gold for this!" );
            return 0;
        }
    }

    return 0;
}

int GetMythalFromThay( object oItem ){

    string sResRef = GetResRef( oItem );
    string sPrefix = GetStringLeft( sResRef, 4 );
    string sNumber = GetStringRight( sResRef, 1 );

    if ( sPrefix != "tcc_" ){

        // return if no thay item
        return 0;
    }

    //regen
    if ( sResRef == "tcc_regen1" ){ return 3; }
    if ( sResRef == "tcc_regen2" ){ return 4; }
    if ( sResRef == "tcc_regen3" ){ return 5; }

    //enhancement and damage (only look at the number)
    if ( sNumber == "1" ){ return 1; }
    if ( sNumber == "2" ){ return 2; }
    if ( sNumber == "3" ){ return 3; }
    if ( sNumber == "4" ){ return 4; }
    if ( sNumber == "5" ){ return 5; }

    //abilities
    if ( sResRef == "tcc_str" ){ return 5; }
    if ( sResRef == "tcc_dex" ){ return 5; }
    if ( sResRef == "tcc_con" ){ return 5; }
    if ( sResRef == "tcc_wis" ){ return 5; }
    if ( sResRef == "tcc_int" ){ return 5; }
    if ( sResRef == "tcc_char" ){ return 5; }

    //OnHit
    if ( sResRef == "tcc_blind" ){ return 4; }
    if ( sResRef == "tcc_daze" ){ return 4; }
    if ( sResRef == "tcc_fear" ){ return 4; }
    if ( sResRef == "tcc_poison" ){ return 4; }
    if ( sResRef == "tcc_slow" ){ return 4; }
    if ( sResRef == "tcc_stun" ){ return 4; }
    if ( sResRef == "tcc_wounding" ){ return 4; }

    //keen
    if ( sResRef == "tcc_keen" ){ return 6; }

    return 0;
}
