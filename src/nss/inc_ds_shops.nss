//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_ds_shops
//group:   transmutation
//used as: action script
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "ds_inc_randstore"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
//make sure sStore equals both resref and tag of the shop
//returns the store on succes or OBJECT_INVALID on failure
//If the pc has the right race it will allow up to 20% appraise
//if the pc has the wrong race it will allow half appraise, up to 10%
object OpenRacialStore( object oPC, object oMerchant, string sStore );



//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
//make sure sStore equals both resref and tag of the shop
//returns the store on succes or OBJECT_INVALID on failure
object OpenRacialStore( object oPC, object oMerchant, string sStore ){

    //bug out on error
    if ( GetLocalInt( oMerchant, "Error" ) ){

        AssignCommand( oMerchant, SpeakString( "[Error: Shop is unavailable. Please post this on the forums.]" ) );

        return OBJECT_INVALID;
    }

    //store spawn routine
    object oStore   = GetLocalObject( OBJECT_SELF, sStore );

    if ( !GetIsObjectValid( oStore ) ){

        oStore = CreateObject( OBJECT_TYPE_STORE , sStore, GetLocation( oMerchant ) );

        if ( GetIsObjectValid( oStore ) ){

            //store store on object for future use
            SetLocalObject( OBJECT_SELF, sStore, oStore );

            //inject random items, if any are set
            InjectIntoStore( oStore );

        }
        else{

            SetLocalInt( oMerchant, "Error", 1 );

            AssignCommand( oMerchant, SpeakString( "[Error: Shop is unavailable. Please post this on the forums.]" ) );

            return OBJECT_INVALID;
        }
    }
    else{

        //If the store is valid, check to see if it is time to inject new items!
        //inject random items, if any are set
        InjectIntoStore( oStore );

    }
    //I store favoured subraces as variables on the merchant
    //this counters issues with NPCs not having a proper subrace
    //and some subraces being complimentary (Stronghearts and Ghostwise, for instance)
    int nPlayerSubRace   = GetRaceInteger( GetRacialType( oPC ), GetSubRace( oPC ) );
    int nAppraise        = GetSkillRank( SKILL_APPRAISE, oPC ) / 3;
    int nModifier        = 0;

    //if there's no fr_ variable we take the base race of the NPC
    if ( !GetLocalInt( oMerchant, "fr_custom" ) ){

        int nMerchantRace = GetRacialType( oMerchant );

        if ( nMerchantRace == 0 ){

            //dwarf
            switch ( nPlayerSubRace ) {

                case 01:  nModifier = -5;  break;
                case 02:  nModifier = -5;  break;
                case 08:  nModifier = -5;  break;
                case 09:  nModifier = -5;  break;
                case 11:  nModifier = -5;  break;
                case 13:  nModifier = 5;  break;
                case 16:  nModifier = -5;  break;
                case 20:  nModifier = -5;  break;
                case 23:  nModifier = -5;  break;
                case 25:  nModifier = -5;  break;
                case 26:  nModifier = 5;  break;
                case 30:  nModifier = -5;  break;
                case 31:  nModifier = -5;  break;
                case 38:  nModifier = 5;  break;
                case 44:  nModifier = -5;  break;
            }
        }
        else if ( nMerchantRace == 1 ){

            //elf
            switch ( nPlayerSubRace ) {

                case 01:  nModifier = -5;  break;
                case 02:  nModifier = -5;  break;
                case 08:  nModifier = -5;  break;
                case 09:  nModifier = -5;  break;
                case 11:  nModifier = -5;  break;
                case 16:  nModifier = -5;  break;
                case 23:  nModifier = -5;  break;
                case 25:  nModifier = -5;  break;
                case 27:  nModifier = 5;  break;
                case 29:  nModifier = 5;  break;
                case 30:  nModifier = -5;  break;
                case 31:  nModifier = -5;  break;
                case 39:  nModifier = 5;  break;
                case 44:  nModifier = -5;  break;
            }
        }
        else if ( nMerchantRace == 2 ){

            //gnome
            switch ( nPlayerSubRace ) {

                case 01:  nModifier = -5;  break;
                case 02:  nModifier = -5;  break;
                case 08:  nModifier = -5;  break;
                case 09:  nModifier = -5;  break;
                case 11:  nModifier = -5;  break;
                case 16:  nModifier = -5;  break;
                case 20:  nModifier = -5;  break;
                case 23:  nModifier = -5;  break;
                case 25:  nModifier = -5;  break;
                case 30:  nModifier = -5;  break;
                case 31:  nModifier = -5;  break;
                case 40:  nModifier = 5;  break;
                case 44:  nModifier = -5;  break;
            }
        }
        else if ( nMerchantRace == 3 ){

            //halfling
            switch ( nPlayerSubRace ) {

                case 01:  nModifier = -5;  break;
                case 02:  nModifier = -5;  break;
                case 05:  nModifier = 5;  break;
                case 06:  nModifier = 5;  break;
                case 08:  nModifier = -5;  break;
                case 09:  nModifier = -5;  break;
                case 11:  nModifier = -5;  break;
                case 16:  nModifier = -5;  break;
                case 20:  nModifier = -5;  break;
                case 23:  nModifier = -5;  break;
                case 25:  nModifier = -5;  break;
                case 30:  nModifier = -5;  break;
                case 31:  nModifier = -5;  break;
                case 42:  nModifier = 5;  break;
                case 44:  nModifier = -5;  break;
            }
        }
        else if ( nMerchantRace == 4 ){

            //half elf
            switch ( nPlayerSubRace ) {

                case 01:  nModifier = -5;  break;
                case 02:  nModifier = -5;  break;
                case 08:  nModifier = -5;  break;
                case 09:  nModifier = -5;  break;
                case 11:  nModifier = -5;  break;
                case 16:  nModifier = -5;  break;
                case 17:  nModifier = 5;  break;
                case 18:  nModifier = 5;  break;
                case 19:  nModifier = 5;  break;
                case 23:  nModifier = -5;  break;
                case 25:  nModifier = -5;  break;
                case 27:  nModifier = 5;  break;
                case 29:  nModifier = 5;  break;
                case 30:  nModifier = -5;  break;
                case 31:  nModifier = -5;  break;
                case 32:  nModifier = 5;  break;
                case 33:  nModifier = 5;  break;
                case 34:  nModifier = 5;  break;
                case 35:  nModifier = 5;  break;
                case 36:  nModifier = 5;  break;
                case 37:  nModifier = 5;  break;
                case 39:  nModifier = 5;  break;
                case 41:  nModifier = 5;  break;
                case 43:  nModifier = 5;  break;
                case 44:  nModifier = -5;  break;
            }
        }
        else if ( nMerchantRace == 5 ){

            //half orc
            switch ( nPlayerSubRace ) {

                case 01:  nModifier = -5;  break;
                case 02:  nModifier = -5;  break;
                case 08:  nModifier = -5;  break;
                case 09:  nModifier = -5;  break;
                case 11:  nModifier = -5;  break;
                case 20:  nModifier = -5;  break;
                case 23:  nModifier = -5;  break;
                case 30:  nModifier = -5;  break;
                case 44:  nModifier = 5;  break;
            }
        }
        else if ( nMerchantRace == 6 ){

            //human
            switch ( nPlayerSubRace ) {

                case 01:  nModifier = -5;  break;
                case 02:  nModifier = -5;  break;
                case 08:  nModifier = -5;  break;
                case 09:  nModifier = -5;  break;
                case 11:  nModifier = -5;  break;
                case 16:  nModifier = -5;  break;
                case 17:  nModifier = 5;  break;
                case 18:  nModifier = 5;  break;
                case 19:  nModifier = 5;  break;
                case 20:  nModifier = -5;  break;
                case 23:  nModifier = -5;  break;
                case 25:  nModifier = -5;  break;
                case 30:  nModifier = -5;  break;
                case 31:  nModifier = -5;  break;
                case 32:  nModifier = 5;  break;
                case 33:  nModifier = 5;  break;
                case 34:  nModifier = 5;  break;
                case 35:  nModifier = 5;  break;
                case 36:  nModifier = 5;  break;
                case 37:  nModifier = 5;  break;
                case 43:  nModifier = 5;  break;
            }
        }
    }
    else{

        //this merchant uses custom subraces
        nModifier = GetLocalInt( oMerchant, "fr_"+IntToString( nPlayerSubRace ) );
    }

    if ( nModifier == 5 ){

        SendMessageToPC( oPC, "<c þ >Merchant: favourable reaction." );
    }
    else if ( nModifier == -5 ){

        SendMessageToPC( oPC, "<cþ  >Merchant: unfavourable reaction." );
    }
    else{

        SendMessageToPC( oPC, "<c þþ>Merchant: neutral reaction." );
    }

    if( GetLocalInt( oPC, "jj_trade_domain" ) )
    {
        nModifier = nModifier + 5;
        SendMessageToPC( oPC, "<c þ >The power of the Trade domain ensures a good deal." );
    }

    //I need to make this negative instead of positive
    //OpenStore must be the most counter-intuitive fucntion ever
    nAppraise = nAppraise + nModifier;

    //cap at 20% discount
    if ( nAppraise > 20 ){

        nAppraise = 20;
    }

    if ( nAppraise > 0 ){

        SendMessageToPC( oPC, "You get "+IntToString( abs( nAppraise ) )+"% discount." );
    }
    else if ( nAppraise < 0 ){

        SendMessageToPC( oPC, "The shopkeeper rips you off for "+IntToString( nAppraise )+"%." );
    }
    else{

        SendMessageToPC( oPC, "You get no discount." );
    }

    //finally open the store
    OpenStore( oStore, oPC, ( 0 - nAppraise ), nAppraise );

    SetStoreIdentifyCost( oStore, ( 100 - nAppraise ) );

    //trace store use
    db_trace_shop( oPC, oStore, OBJECT_SELF );

    return oStore;
}

