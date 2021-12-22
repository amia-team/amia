//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: mod_unacq_item
//group: module events
//used as: OnUnacquireitem
//date: 2008-06-03
//author: Disco (copied & cleaned from old scripts)

// 2009-09-12  Disco   Added rental housing support
// 2009/09/30  disco   Item counter
// 2012/02/21  PoS     Trap stack prevention

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
// Checks if a Thayvian Crafted item was lost and still cursed.  If so,
// brands the item with the PC that lost it.
void CheckThayvian( object oPC, object oItem );

void VerifyAddedFeat( int nFeat, object oPC, int nCount );

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_rental"
#include "inc_ds_traps"
#include "inc_lua"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main( ){

    object oPC      = GetModuleItemLostBy( );

    if ( !GetIsPC( oPC ) ){

        return;
    }

    object oItem    = GetModuleItemLost( );
    string sTag     = GetTag( oItem );

    //count items
    SetLocalInt( oPC, "items", GetLocalInt( oPC, "items" ) - 1 );

    //tweak that prevents people to lose stuff if Disarmed, returns weapon to inventory
    if ( GetIsWeapon( oItem ) && GetIsInCombat( oPC ) )
    {
        CopyItemFixed( oItem, oPC, TRUE );
        DestroyObject( oItem );
        return;
    }

    if ( GetBaseItemType( oItem ) == BASE_ITEM_TRAPKIT ){

        AssignCommand( oPC, SetTrapMode( oPC ) );
        DelayCommand( 0.1, AssignCommand( oPC, ClearAllActions() ) );
        return;
    }

    if ( sTag == "ds_pckey" ){

        DelayCommand( 0.5, FlushPCKEY( oPC, GetName( oItem ) ) );
        return;
    }

    //rental key
    if ( GetResRef( oItem ) == RNT_KEY_TAG ){

        DeleteLocalString( oPC, RNT_PCKEY );
        SendMessageToPC( oPC, "Debug: mod_unacq_item: unloading rental key from PC." );
        return;
    }

    if ( sTag == "ds_grove" ){

        DeleteLocalObject( oPC, "ds_bark" );
        return;
    }

    if ( sTag == "dg_fall" ){

        //This deletes the localint that checks whether the PC is fallen
        DeleteLocalInt( oPC, "Fallen" );

        if ( GetLevelByClass( CLASS_TYPE_PALADIN, oPC ) ){

            if ( !GetHasFeat( FEAT_DIVINE_GRACE, oPC ) ){

                VerifyAddedFeat( FEAT_DIVINE_GRACE, oPC, 5 );

            }

        }


        //unfall
        //AssignCommand( oPC, ActionCastSpellAtObject( 832, oPC, 1, TRUE, 0, 1, TRUE ) );

        //Feedback
        SendMessageToPC( oPC, "You are redeemed." );
        SendMessageToAllDMs( GetName( oPC ) + " has been redeemed." );
    }

    if( GetSubString( sTag, 0, 6 ) == "x2_is_" )
    {
        //from any ioun stones (including self)
        effect eEffect = GetFirstEffect(OBJECT_SELF);
        while (GetIsEffectValid(eEffect) == TRUE)
        {
            if(GetEffectSpellId(eEffect) > 553 && GetEffectSpellId(eEffect) < 561
            || GetEffectSpellId(eEffect) == 918 || GetEffectSpellId(eEffect) == 919 )
            {
                RemoveEffect(OBJECT_SELF, eEffect);
            }
            eEffect = GetNextEffect(OBJECT_SELF);
        }
    }

    CheckThayvian( oPC, oItem );
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
void CheckThayvian( object oPC, object oItem ){

    int isTCS = ( GetStringLeft(GetTag(oItem), 3) == "tc_" ? TRUE : FALSE );
    int isCursed = GetItemCursedFlag( oItem );

    if ( isTCS && isCursed ) {

        // One final check to see if the item was sold.
        object oPossessor = GetItemPossessor( oItem );

        if ( GetObjectType(oPossessor) != OBJECT_TYPE_STORE ){

            SetLocalObject( oItem, "AR_Owner", oPC );
        }
    }
}

void VerifyAddedFeat( int nFeat, object oPC, int nCount ){

    int nReVerify = 0;

    if (!GetHasFeat( nFeat, oPC ) ){

        //NWNXFuncs_AddFeat(oPC, nFeat);
        ExecuteLuaString(oPC,"nwn.AddFeat(OBJECT_SELF,"+IntToString(nFeat)+",0);");
        nReVerify = 1;

    }

    nCount--;

    if ( nReVerify ){

         if ( nCount > 0 ){

            DelayCommand( 1.0, VerifyAddedFeat( nFeat, oPC, nCount ) );

         }
         else{

             SendMessageToPC( oPC, "Tried to verify that a feat was added but failed." );

         }

    }
    else{

        SendMessageToPC( oPC, "Verified that a feat was added." );

    }

}

