//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_dm_xpwand
//group:   DM tools
//used as: activation script
//date:    20080930
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//Gives oPC nPercentage of the amount of XP need to go from his current to next his level.
//nMode = 0 - Give oPC XP
//nMode = 1 - Give oPC and people standing around him XP
//nMode = 2 - Give oPC and his partymembers in the area XP
void GiveXPpercentage( object oPC, object oTarget, int nPercentage, int nMode=0 );

//Give oPC and people standing around him nXP
void GiveXPnearby( object oPC, object oTarget, int nXP );

int CalculatePercentage( object oPC, object oTarget, int nPercentage=10 );



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC       = OBJECT_SELF;
    object oTarget   = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );

    switch ( nNode ) {

        case 01:     GiveXPpercentage( oPC, oTarget, 1 );    break;
        case 02:     GiveXPpercentage( oPC, oTarget, 5 );    break;
        case 03:     GiveXPpercentage( oPC, oTarget, 10 );   break;
        case 04:     GiveXPpercentage( oPC, oTarget, 25 );   break;
        case 05:     GiveXPpercentage( oPC, oTarget, 50 );   break;
        case 06:     GiveCorrectedXP( oPC, 500, "DM" );    break;
        case 07:     GiveCorrectedXP( oPC, 1000, "DM" );    break;
        case 08:     GiveCorrectedXP( oPC, 1500, "DM" );    break;
        case 09:     GiveCorrectedXP( oPC, 2000, "DM" );    break;
        case 10:     GiveCorrectedXP( oPC, 2500, "DM" );    break;
        case 11:     GiveXPpercentage( oPC, oTarget, 1, 1 );    break;
        case 12:     GiveXPpercentage( oPC, oTarget, 5, 1 );    break;
        case 13:     GiveXPpercentage( oPC, oTarget, 10, 1 );    break;
        case 14:     GiveXPpercentage( oPC, oTarget, 25, 1 );    break;
        case 15:     GiveXPpercentage( oPC, oTarget, 50, 1 );    break;
        case 16:     GiveXPnearby( oPC, oTarget, 500 );    break;
        case 17:     GiveXPnearby( oPC, oTarget, 1000 );    break;
        case 18:     GiveXPnearby( oPC, oTarget, 1500 );    break;
        case 19:     GiveXPnearby( oPC, oTarget, 2000 );    break;
        case 20:     GiveXPnearby( oPC, oTarget, 2500 );    break;
        case 21:     GiveXPpercentage( oPC, oTarget, 1, 2 );    break;
        case 22:     GiveXPpercentage( oPC, oTarget, 5, 2 );    break;
        case 23:     GiveXPpercentage( oPC, oTarget, 10, 2 );    break;
        case 24:     GiveXPpercentage( oPC, oTarget, 25, 2 );    break;
        case 25:     GiveXPpercentage( oPC, oTarget, 50, 2 );    break;
        case 26:     GiveRewardToParty( oPC, 500, 0, "DM" );    break;
        case 27:     GiveRewardToParty( oPC, 1000, 0, "DM" );    break;
        case 28:     GiveRewardToParty( oPC, 1500, 0, "DM" );    break;
        case 29:     GiveRewardToParty( oPC, 2000, 0, "DM" );    break;
        case 30:     GiveRewardToParty( oPC, 2500, 0, "DM" );    break;
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


//Gives oTarget nPercentage of the amount of XP need to go from his current to next his level.
//nMode = 0 - Give oTarget XP
//nMode = 1 - Give oTarget and people standing around him XP
//nMode = 2 - Give oTarget and his partymembers in the area XP
void GiveXPpercentage( object oPC, object oTarget, int nPercentage, int nMode=0 ){

    int nXP;

    if ( nMode == 1 ){

        //variables
        object oObject  = GetFirstObjectInShape( SHAPE_SPHERE, 5.0, GetLocation( oTarget ), TRUE, OBJECT_TYPE_CREATURE );
        effect eVis = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR );

        while( GetIsObjectValid( oObject ) ){

            if( GetIsPC( oObject ) || GetIsPossessedFamiliar( oObject ) ){

                if ( GetIsBlocked( oObject, "ds_xp" ) < 1 ){

                    //make receiving PCs visible
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oObject, 10.0 );

                    nXP = CalculatePercentage( oPC, oObject, nPercentage );

                    SetXP( oObject, GetXP( oObject ) + nXP );

                    UpdateModuleVariable( "DMXP", nXP );

                    SetBlockTime( oObject, 5, 0, "ds_xp" );
                }
                else{

                    SendMessageToPC( oPC, GetName( oObject ) + " already received XP during the last 5 minutes." );
                }
            }

            oObject = GetNextObjectInShape( SHAPE_SPHERE, 5.0, GetLocation( oTarget ), TRUE, OBJECT_TYPE_CREATURE );
        }
    }
    else if ( nMode == 2 ){

        object oPartyMember = GetFirstFactionMember( oTarget, TRUE );

        while( GetIsObjectValid( oPartyMember ) ){

            if( GetArea( oPartyMember ) == GetArea( oPC ) &&
                ( GetIsPC( oPartyMember ) || GetIsPossessedFamiliar( oPartyMember ) ) ){

                if ( GetIsBlocked( oPartyMember, "ds_xp" ) < 1 ){

                    nXP = CalculatePercentage( oPC, oPartyMember, nPercentage );

                    SetXP( oPartyMember, GetXP( oPartyMember ) + nXP );

                    UpdateModuleVariable( "DMXP", nXP );

                    SetBlockTime( oPartyMember, 5, 0, "ds_xp" );
                }
                else{

                    SendMessageToPC( oPC, GetName( oPartyMember ) + " already received XP during the last 5 minutes." );
                }
            }

            oPartyMember = GetNextFactionMember( oTarget, TRUE );
        }
    }
    else{

        if( GetIsPC( oTarget ) || GetIsPossessedFamiliar( oTarget ) ){

            if ( GetIsBlocked( oTarget, "ds_xp" ) < 1 ){

                nXP = CalculatePercentage( oPC, oTarget, nPercentage );

                SetXP( oTarget, GetXP( oTarget ) + nXP );

                UpdateModuleVariable( "DMXP", nXP );

                SetBlockTime( oTarget, 5, 0, "ds_xp" );
            }
            else{

                SendMessageToPC( oPC, GetName( oTarget ) + " already received XP during the last 5 minutes." );
            }
        }
    }
}




//Give oTarget and people standing around him nXP
void GiveXPnearby( object oPC, object oTarget, int nXP ){

    //variables
    object oObject  = GetFirstObjectInShape( SHAPE_SPHERE, 5.0, GetLocation( oTarget ), TRUE, OBJECT_TYPE_CREATURE );
    effect eVis = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR );

    while( GetIsObjectValid( oObject ) ){

        if( GetIsPC( oObject ) || GetIsPossessedFamiliar( oObject ) ){

            if ( GetIsBlocked( oObject, "ds_xp" ) < 1 ){

                //make receiving PCs visible
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oObject, 10.0 );

                GiveCorrectedXP( oObject, nXP, "DM" );

                SetBlockTime( oObject, 5, 0, "ds_xp" );
            }
            else{

                SendMessageToPC( oPC, GetName( oObject ) + " already received XP during the last 5 minutes." );
            }
        }

        oObject = GetNextObjectInShape( SHAPE_SPHERE, 5.0, GetLocation( oTarget ), TRUE, OBJECT_TYPE_CREATURE );
    }
}

int CalculatePercentage( object oPC, object oTarget, int nPercentage=10 ){

    struct _ECL_STATISTICS strECL   = GetECL( oTarget );
    int nCurrentLevel               = FloatToInt( strECL.fECL );
    int nNextLevel                  = nCurrentLevel + 1;

    if ( nNextLevel > 30 ){

        SendMessageToPC( oPC, GetName( oTarget )+" reached maximum level! Giving 1 XP." );
        SendMessageToPC( oTarget, "You have reached maximum level! Giving 1 XP." );

        return 1;
    }

    return nCurrentLevel * nPercentage * 10;
}



