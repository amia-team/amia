#include "inc_nwnx_events"
#include "amia_include"
#include "nwnx_weapon"


const int WEAPON_DEV_RANK_1 = 1;
const int WEAPON_DEV_RANK_2 = 2;
const int WEAPON_DEV_RANK_3 = 3;
const int WEAPON_DEV_RANK_4 = 4;

//The function handling the devastating critical routine
void DoCheckDevastatingCritical( object oWeapon, object oAttacker, object oVictim );

//Subfunction to DoCheckDevastatingCritical
int GetItemDevastatingCriticalFeat( object oItem );

//Subfunction to DoCheckDevastatingCritical
int GetWeaponDevastatingRoundMod( object oItem, int nSize );

void main(){
    NWNX_Weapon_BypassDevastatingCritical();
    struct NWNX_Weapon_DevastatingCriticalEvent_Data devCritData = NWNX_Weapon_GetDevastatingCriticalEventData();

    DoCheckDevastatingCritical( devCritData.oWeapon, OBJECT_SELF, devCritData.oTarget );
}

int GetWeaponDevastatingRoundMod( object oItem, int nSize ){


    if( nSize <= CREATURE_SIZE_SMALL ){

        switch( GetBaseItemType( oItem ) ){


            case BASE_ITEM_BRACER: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_GLOVES: return WEAPON_DEV_RANK_3;

            case BASE_ITEM_CBLUDGWEAPON: return WEAPON_DEV_RANK_1;
            case BASE_ITEM_CPIERCWEAPON: return WEAPON_DEV_RANK_1;
            case BASE_ITEM_CREATUREITEM: return WEAPON_DEV_RANK_1;
            case BASE_ITEM_CSLASHWEAPON: return WEAPON_DEV_RANK_1;
            case BASE_ITEM_CSLSHPRCWEAP: return WEAPON_DEV_RANK_1;

            case BASE_ITEM_CLUB: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_DAGGER: return WEAPON_DEV_RANK_2;
            case BASE_ITEM_DART: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_DIREMACE: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_DOUBLEAXE: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_DWARVENWARAXE: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_BASTARDSWORD: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_BATTLEAXE: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_GREATAXE: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_GREATSWORD: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_HALBERD: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_HANDAXE: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_HEAVYCROSSBOW: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_HEAVYFLAIL: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_KAMA: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_KATANA: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_KUKRI: return WEAPON_DEV_RANK_1;
            case BASE_ITEM_LIGHTCROSSBOW: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_LIGHTFLAIL: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_LIGHTHAMMER: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_LIGHTMACE: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_LONGBOW: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_LONGSWORD: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_MORNINGSTAR: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_QUARTERSTAFF: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_RAPIER: return WEAPON_DEV_RANK_2;
            case BASE_ITEM_SCIMITAR: return WEAPON_DEV_RANK_2;
            case BASE_ITEM_SCYTHE: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_SHORTBOW: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_SHORTSPEAR: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_SHORTSWORD: return WEAPON_DEV_RANK_2;
            case BASE_ITEM_SHURIKEN: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_SICKLE: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_SLING: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_THROWINGAXE: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_TRIDENT: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_TWOBLADEDSWORD: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_WARHAMMER: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_WHIP: return WEAPON_DEV_RANK_3;

            default: return WEAPON_DEV_RANK_3;
        }
    }
    else{

        switch( GetBaseItemType( oItem ) ){


            case BASE_ITEM_BRACER: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_GLOVES: return WEAPON_DEV_RANK_3;

            case BASE_ITEM_CBLUDGWEAPON: return WEAPON_DEV_RANK_1;
            case BASE_ITEM_CPIERCWEAPON: return WEAPON_DEV_RANK_1;
            case BASE_ITEM_CREATUREITEM: return WEAPON_DEV_RANK_1;
            case BASE_ITEM_CSLASHWEAPON: return WEAPON_DEV_RANK_1;
            case BASE_ITEM_CSLSHPRCWEAP: return WEAPON_DEV_RANK_1;

            case BASE_ITEM_CLUB: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_DAGGER: return WEAPON_DEV_RANK_2;
            case BASE_ITEM_DART: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_DIREMACE: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_DOUBLEAXE: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_DWARVENWARAXE: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_BASTARDSWORD: return WEAPON_DEV_RANK_2;
            case BASE_ITEM_BATTLEAXE: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_GREATAXE: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_GREATSWORD: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_HALBERD: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_HANDAXE: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_HEAVYCROSSBOW: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_HEAVYFLAIL: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_KAMA: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_KATANA: return WEAPON_DEV_RANK_2;
            case BASE_ITEM_KUKRI: return WEAPON_DEV_RANK_1;
            case BASE_ITEM_LIGHTCROSSBOW: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_LIGHTFLAIL: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_LIGHTHAMMER: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_LIGHTMACE: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_LONGBOW: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_LONGSWORD: return WEAPON_DEV_RANK_2;
            case BASE_ITEM_MORNINGSTAR: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_QUARTERSTAFF: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_RAPIER: return WEAPON_DEV_RANK_1;
            case BASE_ITEM_SCIMITAR: return WEAPON_DEV_RANK_1;
            case BASE_ITEM_SCYTHE: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_SHORTBOW: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_SHORTSPEAR: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_SHORTSWORD: return WEAPON_DEV_RANK_2;
            case BASE_ITEM_SHURIKEN: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_SICKLE: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_SLING: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_THROWINGAXE: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_TRIDENT: return WEAPON_DEV_RANK_4;
            case BASE_ITEM_TWOBLADEDSWORD: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_WARHAMMER: return WEAPON_DEV_RANK_3;
            case BASE_ITEM_WHIP: return WEAPON_DEV_RANK_3;

            default: return WEAPON_DEV_RANK_3;
        }
    }
    return WEAPON_DEV_RANK_1;
}

int GetItemDevastatingCriticalFeat( object oItem ){

    //Hook fails and returns the item you're hitting
    //instead if you got no gloves, offand or mainhand equipped
    if( !GetIsObjectValid( oItem ) || GetObjectType( oItem ) == OBJECT_TYPE_CREATURE )
        return FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED;

    switch( GetBaseItemType( oItem ) ){

        case BASE_ITEM_BASTARDSWORD: return FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD;
        case BASE_ITEM_BATTLEAXE: return FEAT_EPIC_DEVASTATING_CRITICAL_BATTLEAXE;
        case BASE_ITEM_BRACER: return FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED;
        case BASE_ITEM_CBLUDGWEAPON: return FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE;
        case BASE_ITEM_CLUB: return FEAT_EPIC_DEVASTATING_CRITICAL_CLUB;
        case BASE_ITEM_CPIERCWEAPON: return FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE;
        case BASE_ITEM_CREATUREITEM: return FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE;
        case BASE_ITEM_CSLASHWEAPON: return FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE;
        case BASE_ITEM_CSLSHPRCWEAP: return FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE;
        case BASE_ITEM_DAGGER: return FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER;
        case BASE_ITEM_DART: return FEAT_EPIC_DEVASTATING_CRITICAL_DART;
        case BASE_ITEM_DIREMACE: return FEAT_EPIC_DEVASTATING_CRITICAL_DIREMACE;
        case BASE_ITEM_DOUBLEAXE: return FEAT_EPIC_DEVASTATING_CRITICAL_DOUBLEAXE;
        case BASE_ITEM_DWARVENWARAXE: return FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE;
        case BASE_ITEM_GLOVES: return FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED;
        case BASE_ITEM_GREATAXE: return FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE;
        case BASE_ITEM_GREATSWORD: return FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD;
        case BASE_ITEM_HALBERD: return FEAT_EPIC_DEVASTATING_CRITICAL_HALBERD;
        case BASE_ITEM_HANDAXE: return FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE;
        case BASE_ITEM_HEAVYCROSSBOW: return FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYCROSSBOW;
        case BASE_ITEM_HEAVYFLAIL: return FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYFLAIL;
        case BASE_ITEM_KAMA: return FEAT_EPIC_DEVASTATING_CRITICAL_KAMA;
        case BASE_ITEM_KATANA: return FEAT_EPIC_DEVASTATING_CRITICAL_KATANA;
        case BASE_ITEM_KUKRI: return FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI;
        case BASE_ITEM_LIGHTCROSSBOW: return FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTCROSSBOW;
        case BASE_ITEM_LIGHTFLAIL: return FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL;
        case BASE_ITEM_LIGHTHAMMER: return FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTHAMMER;
        case BASE_ITEM_LIGHTMACE: return FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE;
        case BASE_ITEM_LONGBOW: return FEAT_EPIC_DEVASTATING_CRITICAL_LONGBOW;
        case BASE_ITEM_LONGSWORD: return FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD;
        case BASE_ITEM_MORNINGSTAR: return FEAT_EPIC_DEVASTATING_CRITICAL_MORNINGSTAR;
        case BASE_ITEM_QUARTERSTAFF: return FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF;
        case BASE_ITEM_RAPIER: return FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER;
        case BASE_ITEM_SCIMITAR: return FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR;
        case BASE_ITEM_SCYTHE: return FEAT_EPIC_DEVASTATING_CRITICAL_SCYTHE;
        case BASE_ITEM_SHORTBOW: return FEAT_EPIC_DEVASTATING_CRITICAL_SHORTBOW;
        case BASE_ITEM_SHORTSPEAR: return FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR;
        case BASE_ITEM_SHORTSWORD: return FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD;
        case BASE_ITEM_SHURIKEN: return FEAT_EPIC_DEVASTATING_CRITICAL_SHURIKEN;
        case BASE_ITEM_SICKLE: return FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE;
        case BASE_ITEM_SLING: return FEAT_EPIC_DEVASTATING_CRITICAL_SLING;
        case BASE_ITEM_THROWINGAXE: return FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE;
        case BASE_ITEM_TRIDENT: return FEAT_EPIC_DEVASTATING_CRITICAL_TRIDENT;
        case BASE_ITEM_TWOBLADEDSWORD: return FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD;
        case BASE_ITEM_WARHAMMER: return FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER;
        case BASE_ITEM_WHIP: return FEAT_EPIC_DEVASTATING_CRITICAL_WHIP;
        default:break;
    }
    return -1;
}

void DoCheckDevastatingCritical( object oWeapon, object oAttacker, object oVictim ){

    int nFeatNeeded = GetItemDevastatingCriticalFeat( oWeapon );

    if( nFeatNeeded == -1 || !GetHasFeat( nFeatNeeded, oAttacker ) ){

        //Creature doesnt have feat or an invalid weapon. Return.
        return;
    }
    else if( GetLocalInt( oVictim, "dev_immune" ) == 1 )
    {
        //Victim is immune to Dev Crits. Return.
        return;
    }
    else if( !FortitudeSave( oVictim, 10 + GetAbilityModifier( ABILITY_STRENGTH, oAttacker ) + ( GetHitDice( oAttacker ) / 2 ), SAVING_THROW_TYPE_NONE, oAttacker ) ){

        int nDur = GetWeaponDevastatingRoundMod( oWeapon, GetCreatureSize( oAttacker ) );

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DUST_EXPLOSION ), GetLocation( oVictim ) );

        if( GetIsBlocked( oVictim, "dev_block" ) <= 0 ){

            FloatingTextStringOnCreature( "Devastating Critical Hit!", oAttacker );

            SetBlockTime( oVictim, 0, FloatToInt( RoundsToSeconds( nDur ) ), "dev_block" );
            effect eKD  = SupernaturalEffect( EffectKnockdown( ) );
            effect eBad = EffectLinkEffects( EffectBlindness( ), EffectSilence( ) );
                   eBad = EffectLinkEffects( EffectDeaf( ), eBad );
                   eBad = EffectLinkEffects( EffectVisualEffect( VFX_DUR_MIND_AFFECTING_NEGATIVE ), eBad );
                   eBad = SupernaturalEffect( eBad );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eKD, oVictim, RoundsToSeconds( nDur ) );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBad, oVictim, TurnsToSeconds( nDur ) );
        }
        else{

            // We're not doing anything here now.
            //ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( 100*nDur ), oVictim );
            //ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DESTRUCTION ), oVictim );
        }
    }

}
