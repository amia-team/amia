//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_qst"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void SwitchOff( object oPLC );

int GetRubbishModel( );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC = GetEnteringObject( );

    if ( !GetIsPC( oPC ) ){

        return;
    }

    object oTrigger = OBJECT_SELF;
    string sTag     = GetTag( oTrigger );

    if ( sTag == "rua_sarco" ){

        string sPCKEY = GetPCPublicCDKey( oPC, TRUE );

        if ( !GetLocalInt( oTrigger, sPCKEY ) && qst_check( oPC, OBJECT_INVALID, 23 ) == 1 ){

            SetLocalInt( oTrigger, sPCKEY, 1 );

            object oSarco = GetNearestObjectByTag( "rua_sarco_"+IntToString( d4() ) );

            CreateItemOnObject( "rua_bones", oSarco );
        }
    }
    else if ( sTag == "car_hound" ){

        if ( GetIsBlocked() < 1 && qst_check( oPC, OBJECT_INVALID, 24 ) == 1 && GetIsNight() ){

            if ( d3() == 1 ){

                object oWaypoint = GetNearestObjectByTag( "ds_spwn", oPC, 2 + d4() );

                ds_spawn_critter( oPC, "car_hound", GetLocation( oWaypoint ), TRUE );

                FloatingTextStringOnCreature( "*You hear a fearsome howl through the forest. The Blackmoor Hound must be nearby!*", oPC );

                SetBlockTime( oTrigger, 15 );
            }
            else{

                SetBlockTime( oTrigger );
            }
        }
    }
    else if ( sTag == "car_ring_trigger" ){

        object oSarco = GetNearestObjectByTag( "car_ring_sarc" );

        if ( GetPCKEYValue( oPC, "rua_ring" ) == 0 ){

            CreateItemOnObject( "car_ring", oSarco );
        }
    }
    else if ( sTag == "rua_bookshelf" ){

        string sPCKEY = GetPCPublicCDKey( oPC, TRUE );

        if ( !GetLocalInt( oTrigger, sPCKEY ) && qst_check( oPC, OBJECT_INVALID, 23 ) == 4 ){

            SetLocalInt( oTrigger, sPCKEY, 1 );

            object oBookshelf = GetNearestObjectByTag( "rua_bookshelf_"+IntToString( d4() ) );
            object oBook      = CreateItemOnObject( "car_journal", oBookshelf );

            SetName( oBook, "Blackmoor's Journal, Vol. "+IntToString( d100() ) );
        }
    }
    else if( sTag == "rua_candelabra" ){

        if ( GetIsBlocked() > 0 ){

            return;
        }

        SetBlockTime( oTrigger, 1 );

        object oInTrigger = GetFirstInPersistentObject( oTrigger, OBJECT_TYPE_PLACEABLE );

        while ( GetIsObjectValid( oInTrigger ) ){

            if ( GetTag( oInTrigger ) == "Candelabra" ){

                AssignCommand( oInTrigger, ActionPlayAnimation( ANIMATION_PLACEABLE_ACTIVATE ) );

                DelayCommand( 90.0, SwitchOff( oInTrigger ) );
            }

            oInTrigger = GetNextInPersistentObject( oTrigger, OBJECT_TYPE_PLACEABLE );
        }
    }
    else if( sTag == "rua_storage" ){

        if ( GetIsBlocked() > 0 ){

            return;
        }

        SetBlockTime( oTrigger, 10 );

        int nDie;
        int i;
        int j;
        int nStack;
        object oContainer;
        object oCopy;
        object oItem;
        object oRubbish;
        string sResRef;

        for ( i=1; i<=6; ++i ){

            nDie = d6();

            for ( j=1; j<=6; ++j ){

                oContainer = GetNearestObjectByTag( "rua_crate_"+IntToString( i ), oTrigger, j );

                if ( j == 1 && i == 1 ){

                    oRubbish = CreateItemOnObject( "rua_rubbish", oContainer );
                }

                oItem = GetFirstItemInInventory( oContainer );

                //SendMessageToPC( oPC, IntToString( j )+"."+IntToString( j )+": "+GetName( oContainer ) );
                //SendMessageToPC( oPC, "oItem="+GetName( oItem ) );

                if ( j == nDie ){

                    //SendMessageToPC( oPC, "nDie="+IntToString( nDie ) );

                    if ( GetTag( oItem ) == "rua_bubbish" && oRubbish != oItem ){

                        DestroyObject( oItem );
                    }

                    switch ( i ){

                        case 1: sResRef = "rua_castle_key"; nStack = 1; break;
                        case 2: sResRef = "nw_it_medkit003"; nStack = d6(); break;
                        case 3: sResRef = "nw_it_mpotion007"; nStack = d6(); break;
                        case 4: sResRef = "nw_it_mpotion003"; nStack = d6(); break;
                        case 5: sResRef = "nw_it_mpotion011"; nStack = d6(); break;
                        case 6: sResRef = "nw_it_mpotion004"; nStack = d3(); break;

                    }

                    CreateItemOnObject( sResRef, oContainer, nStack );
                }
                else{

                    if ( GetTag( oItem ) != "rua_bubbish" ){

                        DestroyObject( oItem );

                        oCopy = CopyItemAndModify( oRubbish, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, GetRubbishModel( ) );

                        CopyItem( oCopy, oContainer );

                        DestroyObject( oCopy );
                    }
                }
            }
        }

        DestroyObject( oRubbish, 1.0 );
    }
    else if( sTag == "rua_misery" )
    {
        if ( GetIsBlocked() > 0 )
        {
            return;
        }

        SetBlockTime( oTrigger, 1 );

        FloatingTextStringOnCreature( "*"+GetName( oPC )+"'s shoulder slump as if some great weight is pressing down on them*", oPC );

        if ( FortitudeSave( oPC, 45 ) == 0 )
        {
            effect eMisery = EffectLinkEffects( EffectMovementSpeedDecrease (25), EffectAbilityDecrease(ABILITY_STRENGTH, 2+d2()) );
            SendMessageToPC( oPC, "You are overcome with waves of dispair and unbearable sadness. It is difficult to press on." );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eMisery, oPC, TurnsToSeconds(10));
        }
        else
        {
            SendMessageToPC( oPC, "You fight off an almost overwhelming sadness that threatens to consume you." );
        }
        int nMisery = 0;
        SetLocalInt (oPC, "nMisery", 1);
    }
    else if( sTag == "rua_wrath" )
    {
        if ( GetIsBlocked() > 0 )
        {
            return;
        }

        SetBlockTime( oTrigger, 1 );

        if ( WillSave( oPC, 45 ) == 0 )
        {
            effect eWrath = EffectLinkEffects( EffectAbilityDecrease( ABILITY_INTELLIGENCE, 2+d2() ), EffectAttackDecrease(2+d2()) );
            SendMessageToPC( oPC, "You are consumed with a sense of anger and rage that makes it difficult to think and see clearly." );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eWrath, oPC, TurnsToSeconds(10) );
        }
        else
        {
            SendMessageToPC( oPC, "You feel suddenly angry at something... everything, but you manage to control the building rage in your heart." );
        }
        int nWrath = 0;
        SetLocalInt(oPC, "nWrath", 1);
    }
    else if( sTag == "rua_hate" )
    {
        if ( GetIsBlocked() > 0 )
        {
            return;
        }

        SetBlockTime( oTrigger, 1 );

        if ( WillSave( oPC, 45 ) == 0 )
        {
            effect eHate = EffectLinkEffects( EffectAbilityDecrease( ABILITY_INTELLIGENCE, 2+d2() ),EffectAbilityDecrease( ABILITY_WISDOM, 2+d2() ));
            SendMessageToPC( oPC, "You feel an uncontroalable need to destroy the corpse that burns on the cross, you hate it!" );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eHate, oPC, TurnsToSeconds(10) );
        }
        else
        {
            SendMessageToPC( oPC, "You feel a strong urge to destroy the burning corpse, but fight back against the need for to obliterate it completely." );
        }
        int nHate = 0;
        SetLocalInt(oPC, "nHate", 1);
    }
    else if( sTag == "rua_greed" )
    {
        if ( GetIsBlocked() > 0 )
        {
            return;
        }

        SetBlockTime( oTrigger, 1 );

        if ( WillSave( oPC, 45 ) == 0 )
        {
            effect eGreed = EffectLinkEffects( EffectAbilityDecrease( ABILITY_WISDOM, 2+d2() ), EffectSavingThrowDecrease( SAVING_THROW_WILL, 2+d2() ) );
            SendMessageToPC( oPC, "You are consumed with the desire for riches and power!" );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eGreed, oPC, TurnsToSeconds(10) );
        }
        else
        {
            SendMessageToPC( oPC, "You fight off a powerful urge to possess all the riches displayed before you, but you can still feel the lingering burn of that lust." );
        }
        int nGreed = 0;
        SetLocalInt(oPC, "nGreed", 1);
    }
    else if ( sTag == "rua_armour_1" ){

        if ( GetIsBlocked() > 0 ){

            return;
        }

        SetBlockTime( oTrigger, 10 );

        object oArmour = GetNearestObjectByTag( "rua_armour_npc", oTrigger );

        if ( !GetIsObjectValid( oArmour ) ){

            location lWP = GetLocation( GetWaypointByTag( "rua_armour_"+IntToString( d3() ) ) );

            oArmour = ds_spawn_critter( oPC, "rua_armour", lWP, FALSE, "rua_armour_npc" );

            SetPlotFlag( oArmour, TRUE );
        }
    }
    else if ( sTag == "rua_armour_2" ){

        if ( GetIsBlocked() > 0 ){

            return;
        }

        SetBlockTime( oTrigger, 10 );

        object oArmour = GetNearestObjectByTag( "rua_armour_npc" );

        if ( GetIsObjectValid( oArmour ) ){

            effect eVis = EffectVisualEffect( VFX_IMP_CHARM  );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oArmour );

            SetPlotFlag( oArmour, FALSE );

            ChangeToStandardFaction( oArmour, STANDARD_FACTION_HOSTILE );
        }
    }
    else if ( sTag == "rua_mimic_1" ){

        if ( GetIsBlocked() > 0 ){

            return;
        }

        SetBlockTime( oTrigger, 10 );

        object oMimic = GetNearestObjectByTag( "rua_mimic_npc", oTrigger );

        if ( !GetIsObjectValid( oMimic ) ){

            string sMimic = GetLocalString( oTrigger, "ResRef" );

            if ( sMimic == "" ){

                sMimic = "ds_mimic";
            }

            location lWP = GetLocation( GetNearestObjectByTag( "rua_mimic_wp" ) );

            oMimic = ds_spawn_critter( oPC, sMimic, lWP, FALSE, "rua_mimic_npc" );

            SetPlotFlag( oMimic, TRUE );
        }
    }
    else if ( sTag == "rua_mimic_2" ){

        if ( GetIsBlocked() > 0 ){

            return;
        }

        SetBlockTime( oTrigger, 10 );

        object oMimic = GetNearestObjectByTag( "rua_mimic_npc" );

        if ( GetIsObjectValid( oMimic ) ){

            effect eVis = EffectVisualEffect( VFX_IMP_CHARM  );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oMimic );

            SetPlotFlag( oMimic, FALSE );

            ChangeToStandardFaction( oMimic, STANDARD_FACTION_HOSTILE );
        }
    }
    else if ( sTag == "car_library" ){

        string sPCKEY = GetPCPublicCDKey( oPC, TRUE );

        if ( !GetLocalInt( oTrigger, sPCKEY ) && qst_check( oPC, OBJECT_INVALID, 23 ) == 4 ){

            SetLocalInt( oTrigger, sPCKEY, 1 );

            object oBookshelf = GetNearestObjectByTag( "X2_PLC_DBOOKC", oPC, ( 1 + Random( 24 ) ) );
            object oBook      = CreateItemOnObject( "car_book", oBookshelf );

            SetName( oBook, "Blackmoor's Journal, Vol. "+IntToString( d100() ) );
        }
    }
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void SwitchOff( object oPLC ){

    AssignCommand( oPLC, ActionPlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
}

int GetRubbishModel( ){

    int nDie = Random( 14 ) + 1;

    switch ( nDie ) {

        case 01:     return 1;    break;
        case 02:     return 3;    break;
        case 03:     return 25;    break;
        case 04:     return 37;    break;
        case 05:     return 45;    break;
        case 06:     return 62;    break;
        case 07:     return 65;    break;
        case 08:     return 73;    break;
        case 09:     return 85;    break;
        case 10:     return 111;    break;
        case 11:     return 112;    break;
        case 12:     return 117;    break;
        case 13:     return 119;    break;
        case 14:     return 120;    break;
    }

    return 7;
}
