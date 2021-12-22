//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_emotes
//group:   rest menu
//used as: action script
//date:    apr 02 2007
//author:  disco

//2008-05-19    Disco       Added The Hurting :D
//2008-09-24    Terra       Added Safedebuffer
//2008-10-17    Terra       Added DM messenger
//2009-06-20    Disco       Cleaned up scripting, added XP blocker
//2017-05-22    RaveN       Epic Summon Stuff

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "amia_include"
#include "inc_ds_records"



//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void HitMe( object oPC, int nDamage );
int GetIsNonMalignSpellEffect( effect eEffect );
void SafeDebuff( object oPC );
void MessageAllDms( object oPC, int nNode );
void XPblock( object oPC );
void SummonChange( object oPC, int nSummonType );
void EMDSummonChange( object oPC, int nSummonType );

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

void main(){

    object oPC      = GetPCSpeaker();
    int nNode       = GetLocalInt( oPC, "ds_node" );
    int nAnimation  = -1;

    switch ( nNode ) {

        case 01: MessageAllDms( oPC, nNode ); break;
        case 02: MessageAllDms( oPC, nNode ); break;
        case 03: MessageAllDms( oPC, nNode ); break;
        case 04: MessageAllDms( oPC, nNode ); break;
        case 05: MessageAllDms( oPC, nNode ); break;
        case 06: MessageAllDms( oPC, nNode ); break;

        case 07: nAnimation = ANIMATION_LOOPING_TALK_PLEADING;          break;
        case 08: nAnimation = ANIMATION_LOOPING_CONJURE1;               break;
        case 09: nAnimation = ANIMATION_LOOPING_CONJURE2;               break;
        case 10: nAnimation = ANIMATION_LOOPING_DEAD_BACK;              break;
        case 11: nAnimation = ANIMATION_LOOPING_DEAD_FRONT;             break;
        case 12: nAnimation = ANIMATION_LOOPING_TALK_LAUGHING;          break;
        case 13: nAnimation = ANIMATION_LOOPING_MEDITATE;               break;
        case 14: nAnimation = ANIMATION_LOOPING_SIT_CROSS;              break;
        case 15: nAnimation = ANIMATION_LOOPING_WORSHIP;                break;
        case 16: nAnimation = ANIMATION_LOOPING_PAUSE;                  break;

        //xp block
        case 20: XPblock( oPC );                                        break;

        //hurt yourself options
        case 21: HitMe( oPC, 1 );                                       break;
        case 22: HitMe( oPC, ( GetCurrentHitPoints( oPC ) -1 ) );       break;
        case 23: HitMe( oPC, d6() );                                    break;
        case 24: HitMe( oPC, d10() );                                   break;
        case 25: HitMe( oPC, d20() );                                   break;
        case 26: HitMe( oPC, d100() );                                  break;
        case 27: HitMe( oPC, FloatToInt( GetCurrentHitPoints( oPC ) * 0.25 ) );   break;
        case 28: HitMe( oPC, FloatToInt( GetCurrentHitPoints( oPC ) * 0.50 ) );   break;
        case 29: HitMe( oPC, FloatToInt( GetCurrentHitPoints( oPC ) * 0.75 ) );   break;

        //safe debuff
        case 30: SafeDebuff( oPC );                                     break;

        //Summon Changing
        case 31: SummonChange( oPC, 0 );                                break;
        case 32: SummonChange( oPC, 1 );                                break;
        case 33: SummonChange( oPC, 2 );                                break;
        case 34: SummonChange( oPC, 3 );                                break;
        case 35: SummonChange( oPC, 4 );                                break;
        case 36: SummonChange( oPC, 5 );                                break;

        //Epic Mummy Dust Changing (not zero indexed)
        case 37: EMDSummonChange( oPC, 1);                              break;
        case 38: EMDSummonChange( oPC, 2);                              break;
        case 39: EMDSummonChange( oPC, 3);                              break;
        case 40: EMDSummonChange( oPC, 4);                              break;
        case 41: EMDSummonChange( oPC, 5);                              break;
    }

    if ( nAnimation > -1 ){

        AssignCommand( oPC, ActionPlayAnimation( nAnimation, 1.0, 1200.0 ) );
    }

}
void HitMe( object oPC, int nDamage ){

    if ( GetCurrentHitPoints( oPC ) <= nDamage ){

        nDamage = GetCurrentHitPoints( oPC ) - 1;
    }

    effect eDamage = EffectDamage( nDamage );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC );
}


void SafeDebuff( object oPC ){

    effect eEffect = GetFirstEffect( oPC );

    while( GetIsEffectValid( eEffect ) )  {

        if( GetIsNonMalignSpellEffect( eEffect ) ){

            RemoveEffect( oPC, eEffect );
        }

        eEffect = GetNextEffect( oPC );
    }

    itemproperty IP;
    object       oObject;
    int iLoop = 0;

    while ( iLoop < NUM_INVENTORY_SLOTS ) {

        oObject = GetItemInSlot( iLoop, oPC );

        if ( GetIsObjectValid( oObject ) ){

            IP = GetFirstItemProperty( oObject );

            while( GetIsItemPropertyValid( IP ) ) {

                if( GetItemPropertyDurationType( IP ) == DURATION_TYPE_TEMPORARY ){

                    RemoveItemProperty( oObject, IP );
                }

                IP = GetNextItemProperty( oObject );
            }
        }

        iLoop++;
    }
}

int GetIsNonMalignSpellEffect( effect eEffect ){

    switch( GetEffectSpellId( eEffect ) ) {

        case SPELL_AID: return TRUE; break;
        case SPELL_AMPLIFY: return TRUE; break;
        case SPELL_AURA_OF_VITALITY: return TRUE; break;
        case SPELL_AURAOFGLORY: return TRUE; break;
        case SPELL_AWAKEN: return TRUE; break;
        case SPELL_BARKSKIN: return TRUE; break;
        case SPELL_BATTLETIDE: return TRUE; break;
        case SPELL_BLACKSTAFF: return TRUE; break;
        case SPELL_BLADE_THIRST: return TRUE; break;
        case SPELL_BLESS: return TRUE; break;
        case SPELL_BLESS_WEAPON: return TRUE; break;
        case SPELL_BLOOD_FRENZY: return TRUE; break;
        case SPELL_BULLS_STRENGTH: return TRUE; break;
        case SPELL_CAMOFLAGE: return TRUE; break;
        case SPELL_CATS_GRACE: return TRUE; break;
        case SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE: return TRUE; break;
        case SPELL_CLARITY: return TRUE; break;
        case SPELL_DEATH_ARMOR: return TRUE; break;
        case SPELL_DEAFENING_CLANG: return TRUE; break;
        case SPELL_DARKVISION: return TRUE; break;
        case SPELL_DEATH_WARD: return TRUE; break;
        case SPELL_DISPLACEMENT: return TRUE; break;
        case SPELL_DIVINE_FAVOR: return TRUE; break;
        case SPELL_DIVINE_MIGHT: return TRUE; break;
        case SPELL_DIVINE_POWER: return TRUE; break;
        case SPELL_DIVINE_SHIELD: return TRUE; break;
        case SPELL_EAGLE_SPLEDOR: return TRUE; break;
        case SPELL_ELEMENTAL_SHIELD: return TRUE; break;
        case SPELL_ENDURANCE: return TRUE; break;
        case SPELL_ENDURE_ELEMENTS: return TRUE; break;
        case SPELL_ENERGY_BUFFER: return TRUE; break;
        case SPELL_ENTROPIC_SHIELD: return TRUE; break;
        case SPELL_EPIC_MAGE_ARMOR: return TRUE; break;
        case SPELL_ETHEREAL_VISAGE: return TRUE; break;
        case SPELL_ETHEREALNESS: return TRUE; break;
        case SPELL_EXPEDITIOUS_RETREAT: return TRUE; break;
        case SPELL_FOXS_CUNNING: return TRUE; break;
        case SPELL_FREEDOM_OF_MOVEMENT: return TRUE; break;
        case SPELL_GHOSTLY_VISAGE: return TRUE; break;
        case SPELL_GLOBE_OF_INVULNERABILITY: return TRUE; break;
        case SPELL_GREATER_BULLS_STRENGTH: return TRUE; break;
        case SPELL_GREATER_CATS_GRACE: return TRUE; break;
        case SPELL_GREATER_EAGLE_SPLENDOR: return TRUE; break;
        case SPELL_GREATER_ENDURANCE: return TRUE; break;
        case SPELL_GREATER_FOXS_CUNNING: return TRUE; break;
        case SPELL_GREATER_MAGIC_WEAPON: return TRUE; break;
        case SPELL_GREATER_OWLS_WISDOM: return TRUE; break;
        case SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE: return TRUE; break;
        case SPELL_GREATER_SHADOW_CONJURATION_MIRROR_IMAGE: return TRUE; break;
        case SPELL_GREATER_SPELL_MANTLE: return TRUE; break;
        case SPELL_GREATER_STONESKIN: return TRUE; break;
        case SPELL_HASTE: return TRUE; break;
        case SPELL_HOLY_AURA: return TRUE; break;
        case SPELL_HOLY_SWORD: return TRUE; break;
        case SPELL_IDENTIFY: return TRUE; break;
        case SPELL_IMPROVED_INVISIBILITY: return TRUE; break;
        case SPELL_INVISIBILITY: return TRUE; break;
        case SPELL_INVISIBILITY_PURGE: return TRUE; break;
        case SPELL_INVISIBILITY_SPHERE: return TRUE; break;
        case SPELL_IOUN_STONE_BLUE: return TRUE; break;
        case SPELL_IOUN_STONE_DEEP_RED: return TRUE; break;
        case SPELL_IOUN_STONE_DUSTY_ROSE: return TRUE; break;
        case SPELL_IOUN_STONE_PALE_BLUE: return TRUE; break;
        case SPELL_IOUN_STONE_PINK: return TRUE; break;
        case SPELL_IOUN_STONE_PINK_GREEN: return TRUE; break;
        case SPELL_IOUN_STONE_SCARLET_BLUE: return TRUE; break;
        case SPELL_IRONGUTS: return TRUE; break;
        case SPELL_KEEN_EDGE: return TRUE; break;
        case SPELL_LEGEND_LORE: return TRUE; break;
        case SPELL_LESSER_MIND_BLANK: return TRUE; break;
        case SPELL_LESSER_SPELL_MANTLE: return TRUE; break;
        case SPELL_MAGE_ARMOR: return TRUE; break;
        case SPELL_MAGIC_CIRCLE_AGAINST_CHAOS: return TRUE; break;
        case SPELL_MAGIC_CIRCLE_AGAINST_EVIL: return TRUE; break;
        case SPELL_MAGIC_CIRCLE_AGAINST_GOOD: return TRUE; break;
        case SPELL_MAGIC_CIRCLE_AGAINST_LAW: return TRUE; break;
        case SPELL_MAGIC_WEAPON: return TRUE; break;
        case SPELL_MAGIC_VESTMENT: return TRUE; break;
        case SPELL_MASS_CAMOFLAGE: return TRUE; break;
        case SPELL_MASS_HASTE: return TRUE; break;
        case SPELL_MESTILS_ACID_SHEATH: return TRUE; break;
        case SPELL_MIND_BLANK: return TRUE; break;
        case SPELL_MINOR_GLOBE_OF_INVULNERABILITY: return TRUE; break;
        case SPELL_MONSTROUS_REGENERATION: return TRUE; break;
        case SPELL_NEGATIVE_ENERGY_PROTECTION: return TRUE; break;
        case SPELL_ONE_WITH_THE_LAND: return TRUE; break;
        case SPELL_OWLS_INSIGHT: return TRUE; break;
        case SPELL_OWLS_WISDOM: return TRUE; break;
        case SPELL_PRAYER: return TRUE; break;
        case SPELL_PREMONITION: return TRUE; break;
        case SPELL_PROTECTION__FROM_CHAOS: return TRUE; break;
        case SPELL_PROTECTION_FROM_ELEMENTS: return TRUE; break;
        case SPELL_PROTECTION_FROM_EVIL: return TRUE; break;
        case SPELL_PROTECTION_FROM_GOOD: return TRUE; break;
        case SPELL_PROTECTION_FROM_LAW: return TRUE; break;
        case SPELL_PROTECTION_FROM_SPELLS: return TRUE; break;
        case SPELL_REGENERATE: return TRUE; break;
        case SPELL_REMOVE_FEAR: return TRUE; break;
        case SPELL_RESIST_ELEMENTS: return TRUE; break;
        case SPELL_RESISTANCE: return TRUE; break;
        case SPELL_SANCTUARY: return TRUE; break;
        case SPELL_SEE_INVISIBILITY: return TRUE; break;
        case SPELL_SHADES_STONESKIN: return TRUE; break;
        case SPELL_SHADOW_CONJURATION_INIVSIBILITY: return TRUE; break;
        case SPELL_SHADOW_CONJURATION_MAGE_ARMOR: return TRUE; break;
        case SPELL_SHADOW_EVADE: return TRUE; break;
        case SPELL_SHADOW_SHIELD: return TRUE; break;
        case SPELL_SHIELD: return TRUE; break;
        case SPELL_SHIELD_OF_FAITH: return TRUE; break;
        case SPELL_SHIELD_OF_LAW: return TRUE; break;
        case SPELL_SPELL_MANTLE: return TRUE; break;
        case SPELL_SPELL_RESISTANCE: return TRUE; break;
        case SPELL_STONE_BONES: return TRUE; break;
        case SPELL_STONESKIN: return TRUE; break;
        case SPELL_TENSERS_TRANSFORMATION: return TRUE; break;
        case SPELL_TRUE_SEEING: return TRUE; break;
        case SPELL_TRUE_STRIKE: return TRUE; break;
        case SPELL_TYMORAS_SMILE: return TRUE; break;
        case SPELL_UNDEATHS_ETERNAL_FOE: return TRUE; break;
        case SPELL_VINE_MINE_CAMOUFLAGE: return TRUE; break;
        case SPELL_VIRTUE: return TRUE; break;
        case 886: return TRUE; break;
        case 918: return TRUE; break;
        case 919: return TRUE; break;

        default: return FALSE;
    }

    return FALSE;
}

void MessageAllDms( object oPC, int nNode ){

    string sPC = SQLEncodeSpecialChars( GetName( oPC ) );
    string sAccount = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sArea = SQLEncodeSpecialChars( GetName( GetArea( oPC ) ) );
    string sModule = IntToString( GetLocalInt( GetModule(), "Module" ) );

    if ( sModule == "1" ){

        sModule = "2";
    }
    else{

        sModule = "1";
    }

    if ( GetIsDM( oPC ) || GetIsDMPossessed( oPC ) ){

        sPC = "DM Avatar";
    }

    string sQuery = "INSERT INTO messenger VALUES( NULL, '"+sPC+"', '"+sModule+"', '"+sArea+ "', 0, '"+sAccount+"', '"+IntToString( nNode )+"', NOW() )";

    //execute
    SQLExecDirect( sQuery );
}

void XPblock( object oPC ){

    int nBlock = GetLocalInt( oPC, "ds_xpbl" );

    if ( nBlock == 1 ){

        SendMessageToPC( oPC, "XP block removed." );
        DeleteLocalInt( oPC, "ds_xpbl" );
    }
    else{

        SendMessageToPC( oPC, "XP block activated." );
        SetLocalInt( oPC, "ds_xpbl", 1 );
    }
}

void SummonChange( object oPC, int nSummonType )
{
    if( GetPCKEY( oPC ) == OBJECT_INVALID )
    {
        SendMessageToPC( oPC, "You must have a PC Key to change your summons - enter the game world first!" );
        return;
    }

    string  sSummonType = "";
    int     nAlign      = GetAlignmentGoodEvil( oPC );
    int     nChosen     = GetPCKEYValue( oPC, "AlignChoice" );

    if( nSummonType == 0 ) sSummonType = "Animal";
    else if( nSummonType == 1 ) sSummonType = "Elemental";
    else if( nSummonType == 2 ) sSummonType = "Vermin";
    else if( nSummonType == 3 ) sSummonType = "Celestial";
    else if( nSummonType == 4 ) sSummonType = "Fiendish";
    else if( nSummonType == 5 ) sSummonType = "Wild";

    SetPCKEYValue( oPC, "SummonType", nSummonType );
    SendMessageToPC( oPC, "You have changed your summoning to be " + sSummonType );

    if( nAlign == ALIGNMENT_NEUTRAL )
    {
        if( !nChosen )
        {
            if( nSummonType == 3 || nSummonType == 4 ) SetPCKEYValue( oPC, "AlignChoice", nSummonType );
        }
    }
}

void EMDSummonChange( object oPC, int nSummonType ) {

    if( GetPCKEY( oPC ) == OBJECT_INVALID )
    {
        SendMessageToPC( oPC, "You must have a PC Key to change your summons - enter the game world first!" );
        return;
    }

    string  sSummonType = "";

    switch (nSummonType)
    {
      case 1:
        sSummonType = "Undead";
        break;
      case 2:
        sSummonType = "Outsider";
        break;
      case 3:
        sSummonType = "Construct";
        break;
      case 4:
        sSummonType = "Magical Beast";
        break;
      case 5:
        sSummonType = "Elemental";
    }

    SetPCKEYValue( oPC, "jj_MummyDust_Choice", nSummonType );
    SendMessageToPC( oPC, "You have changed your summoning to be " + sSummonType );
}

