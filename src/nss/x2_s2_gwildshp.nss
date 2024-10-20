//::///////////////////////////////////////////////
//:: Greater Wild Shape, Humanoid Shape
//:: x2_s2_gwildshp
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the character to shift into one of these
    forms, gaining special abilities

    Credits must be given to mr_bumpkin from the NWN
    community who had the idea of merging item properties
    from weapon and armor to the creatures new forms.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-02
//:://////////////////////////////////////////////
//Updated: Maverick00053, 01/17/2021 - Shifter Revamp

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "x2_inc_itemprop"
#include "x2_inc_shifter"
#include "amia_include"
#include "inc_td_shifter"
#include "x0_i0_spells"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------


void main(){

    //--------------------------------------------------------------------------
    // Declare major variables
    //--------------------------------------------------------------------------
    int     nSpell = GetSpellId();
    object  oTarget = GetSpellTargetObject();
    int     iVis = VFX_IMP_POLYMORPH;
    int     nShifter = GetLevelByClass(CLASS_TYPE_SHIFTER);
    effect  ePoly;
    int     nPoly;

    // Terra: Added override to dargaonshape
    int nDragonRed      = GetLocalInt( OBJECT_SELF , "td_dragon_override_red");
    int nDragonBlue     = GetLocalInt( OBJECT_SELF , "td_dragon_override_blue");
    int nDragonGreen    = GetLocalInt( OBJECT_SELF , "td_dragon_override_green");

    int nAssumeOverride = GetLocalInt( OBJECT_SELF , "td_poly_type");

    int nPolyLevel = 0;

    if(GetLocalInt(OBJECT_SELF,"POLY_COOLDOWN") == 1)
    {
      SendMessageToPC(OBJECT_SELF,"You must wait for the cool down to expire to shift again!");
      return;
    }


    // Feb 13, 2004, Jon: Added scripting to take care of case where it's an NPC
    // using one of the feats. It will randomly pick one of the shapes associated
    // with the feat.
    switch(nSpell)
    {
        // Greater Wildshape I
        case 646: nSpell = Random(5)+658; break;
        // Greater Wildshape II
        case 675: switch(Random(3))
                  {
                    case 0: nSpell = 672; break;
                    case 1: nSpell = 678; break;
                    case 2: nSpell = 680;
                  }
                  break;
        // Greater Wildshape III
        case 676: switch(Random(3))
                  {
                    case 0: nSpell = 670; break;
                    case 1: nSpell = 673; break;
                    case 2: nSpell = 674;
                  }
                  break;
        // Greater Wildshape IV
        case 677: switch(Random(3))
                  {
                    case 0: nSpell = 679; break;
                    case 1: nSpell = 691; break;
                    case 2: nSpell = 694;
                  }
                  break;
        // Humanoid Shape
        case 681:  nSpell = Random(3)+682; break;
        // Undead Shape
        case 685:  nSpell = Random(3)+704; break;
        // Dragon Shape
        case 725:  nSpell = Random(3)+707; break;
        // Outsider Shape
        case 732:  nSpell = Random(3)+733; break;
        // Construct Shape
        case 737:  nSpell = Random(3)+738; break;
    }

    //--------------------------------------------------------------------------
    // Determine which form to use based on spell id, gender and level
    //--------------------------------------------------------------------------
    switch (nSpell)
    {

        //-----------------------------------------------------------------------
        // Greater Wildshape I - Wyrmling Shape
        //-----------------------------------------------------------------------
        case 658:  nPoly = 123; nPolyLevel = 1; break;

        case 659:  nPoly = 125; nPolyLevel = 1; break;

        case 660:  nPoly = 127; nPolyLevel = 1; break;

        case 661:  nPoly = 131; nPolyLevel = 1; break;

        case 662:  nPoly = 129; nPolyLevel = 1; break;

        //-----------------------------------------------------------------------
        // Greater Wildshape II  - Minotaur, Gargoyle, Harpy
        //-----------------------------------------------------------------------
        case 672:  nPoly = 133; nPolyLevel = 2; break;

        case 678:  nPoly = 135; nPolyLevel = 2; break;

        case 680:  nPoly = 137; nPolyLevel = 2; break;

        //-----------------------------------------------------------------------
        // Greater Wildshape III  - Drider, Basilisk, Manticore
        //-----------------------------------------------------------------------
        case 670:  nPoly = 139; nPolyLevel = 3; break;

        case 673:  nPoly = 141; nPolyLevel = 3; break;

        case 674:  nPoly = 143; nPolyLevel = 3; break;

       //-----------------------------------------------------------------------
       // Greater Wildshape IV - Dire Tiger, Medusa, MindFlayer
       //-----------------------------------------------------------------------
        case 679: nPoly = 155; nPolyLevel = 5; break;
        case 691: nPoly = 157; nPolyLevel = 5; break; // Mindflayer
        case 694: nPoly = 153; nPolyLevel = 5; break; // DireTiger


       //-----------------------------------------------------------------------
       // Humanoid Shape - Kobold Commando, Drow, Lizard Crossbow Specialist
       //-----------------------------------------------------------------------
       case 682:
                if( GetGender( OBJECT_SELF ) == GENDER_MALE ) //drow
                    nPoly = 147;
                else
                    nPoly = 145;
                nPolyLevel = 4;
                break;

       case 683: nPoly = 149; nPolyLevel = 4; break;

       case 684: nPoly = 151; nPolyLevel = 4; break;

       //-----------------------------------------------------------------------
       // Undead Shape - Spectre, Risen Lord, Vampire
       //-----------------------------------------------------------------------
       case 704: nPoly = 159; break; // Risen lord

       case 705: if (GetGender(OBJECT_SELF) == GENDER_MALE) // vampire
                     nPoly = 161;
                  else
                     nPoly = 160;

                 break;

       case 706: nPoly = 162; break; /// spectre

       //-----------------------------------------------------------------------
       // Dragon Shape - Red Blue and Green Dragons
       //-----------------------------------------------------------------------

       // Ancient Red   Dragon
       case 707:

            if(nAssumeOverride <= 0){

                if(nDragonRed <= 0)nPoly = 72;
                else nPoly = nDragonRed;

            }
            else{
                nPoly = nAssumeOverride;
                // We've gotten the override int, kill it now.
                DeleteLocalInt( OBJECT_SELF , "td_poly_type");
            }

       iVis = VFX_FNF_SUMMONDRAGON;

       break;

       // Ancient Blue  Dragon
       case 708:

            if(nAssumeOverride <= 0){

            if(nDragonBlue <= 0) nPoly = 71;
            else nPoly = nDragonBlue;

            }

            else{
            nPoly = nAssumeOverride;
            // We've gotten the override int, kill it now.
            DeleteLocalInt( OBJECT_SELF , "td_poly_type");
            }

       iVis = VFX_FNF_SUMMONDRAGON;

       break;

       // Ancient Green Dragon
       case 709:

            if(nAssumeOverride <= 0){

            if(nDragonGreen <= 0)nPoly = 73;
            else nPoly = nDragonGreen;

            }

            else{
            nPoly = nAssumeOverride;
            // We've gotten the override int, kill it now.
            DeleteLocalInt( OBJECT_SELF , "td_poly_type");
            }

       iVis = VFX_FNF_SUMMONDRAGON;

       break;


       //-----------------------------------------------------------------------
       // Outsider Shape - Rakshasa, Azer Chieftain, Black Slaad
       //-----------------------------------------------------------------------
       case 733:   if (GetGender(OBJECT_SELF) == GENDER_MALE) //azer
                      nPoly = 164;
                    else // anything else is female
                      nPoly = 163;
                    break;

       case 734:   if (GetGender(OBJECT_SELF) == GENDER_MALE) //rakshasa
                      nPoly = 166;
                    else // anything else is female
                      nPoly = 165;
                    break;

       case 735: nPoly =167; break; // slaad

       //-----------------------------------------------------------------------
       // Construct Shape - Stone Golem, Iron Golem, Demonflesh Golem
       //-----------------------------------------------------------------------
       case 738: nPoly =168; break; // stone golem
       case 739: nPoly =170; break; // demonflesh golem
       case 740: nPoly =169; break; // iron golem


       //-----------------------------------------------------------------------
       // Humanoid Shape II - Dwarven Defender, Ogre Stomper, Tuan Ti
       //-----------------------------------------------------------------------
       case 964:
                if( GetGender( OBJECT_SELF ) == GENDER_MALE )
                    nPoly = 255;
                else
                    nPoly = 253;
                nPolyLevel = 6;
                break;

       case 965: nPoly = 257; nPolyLevel = 6; break;

       case 966: nPoly = 259; nPolyLevel = 6; break;

        //-----------------------------------------------------------------------
       // Giant Shape - Cyclops, Fire Giant HC, Mountain Giant Bruiser
       //-----------------------------------------------------------------------
       case 968: nPoly =261; break;

       case 969:   if (GetGender(OBJECT_SELF) == GENDER_MALE)
                      nPoly = 263;
                    else // anything else is female
                      nPoly = 262;
                    break;

       case 970: nPoly =264; break;

       //-----------------------------------------------------------------------
       // Gargantuan Shape - Grick, Demon Overlord, Pyroclastic Dragon
       //-----------------------------------------------------------------------
       case 972: nPoly =265; break; // stone golem
       case 973: nPoly =266; break; // demonflesh golem
       case 974: nPoly =267; break; // iron golem


    }

    //--------------------------------------------------------------------------
    // Store the old objects so we can access them after the character has
    // changed into his new form
    //--------------------------------------------------------------------------
    object oWeaponOld   = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF );
    object oArmor       = GetItemInSlot( INVENTORY_SLOT_CHEST,OBJECT_SELF );
    object oRing1       = GetItemInSlot( INVENTORY_SLOT_LEFTRING,OBJECT_SELF );
    object oRing2       = GetItemInSlot( INVENTORY_SLOT_RIGHTRING,OBJECT_SELF );
    object oBoots       = GetItemInSlot( INVENTORY_SLOT_BOOTS,OBJECT_SELF );
    object oSheild      = GetItemInSlot( INVENTORY_SLOT_LEFTHAND,OBJECT_SELF );
    object oAmulet      = GetItemInSlot( INVENTORY_SLOT_NECK,OBJECT_SELF );
    object oCloak       = GetItemInSlot( INVENTORY_SLOT_CLOAK,OBJECT_SELF );
    object oHands       = GetItemInSlot( INVENTORY_SLOT_ARMS,OBJECT_SELF );
    object oBelt        = GetItemInSlot( INVENTORY_SLOT_BELT,OBJECT_SELF );
    object oHelm        = GetItemInSlot( INVENTORY_SLOT_HEAD,OBJECT_SELF );

    //Drowning!
    int nCannotDrown = ds_check_uw_items( OBJECT_SELF );

    // Terra: Some dragons can breath underwater; bronze, black, gold and green
    switch( nPoly ){

        case 73:  nCannotDrown = 1; break;
        case 116: nCannotDrown = 1; break;
        case 122: nCannotDrown = 1; break;
        case 119: nCannotDrown = 1; break;
    }

    //--------------------------------------------------------------------------
    // Epic Forms for non Epics
    //--------------------------------------------------------------------------

    if( nPolyLevel == 1 && nShifter >= 20 )
        nPoly++;
    else if( nPolyLevel == 2 && nShifter >= 21 )
        nPoly++;
    else if( nPolyLevel == 3 && nShifter >= 22 )
        nPoly++;
    else if( nPolyLevel == 4 && nShifter >= 23 )
        nPoly++;
    else if( nPolyLevel == 5 && nShifter >= 24 )
        nPoly++;
    else if( nPolyLevel == 6 && nShifter >= 25 )
        nPoly++;
    //--------------------------------------------------------------------------
    // Monk nerf
    //--------------------------------------------------------------------------

    ePoly           = EffectPolymorph( nPoly );

    if( GetSubString( Get2DAString( "polymorph", "Name", nPoly ), 0, 12 ) == "CUSTOM_TYPE_" ) {

        ePoly = EffectShifterProgressionACEffect( OBJECT_SELF, ePoly );

        // Addition for Shifter AB buff.
        if ( StringToInt( Get2DAString( "polymorph", "NATURALACBONUS", nPoly ) ) > 0 )
        {
            ePoly = EffectLinkEffects( EffectAttackIncrease( StringToInt( Get2DAString( "polymorph", "NATURALACBONUS", nPoly ) ) ), ePoly );
        }
    }
    else if( GetHasFeat( 260 ) ){

        ePoly = EffectLinkEffects( EffectACDecrease( GetAbilityModifier( ABILITY_WISDOM ) ), ePoly );
    }

    if( nPoly == 124 )
    {
        ePoly = EffectLinkEffects( EffectDamageShield( GetLevelByClass( CLASS_TYPE_SHIFTER, oTarget ), DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE ), ePoly );
        if ( GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD) ) {
            RemoveSpellEffects(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF, OBJECT_SELF );
        }
        if ( GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH) ) {
            RemoveSpellEffects(SPELL_MESTILS_ACID_SHEATH, OBJECT_SELF, OBJECT_SELF );
        }
        if ( GetHasSpellEffect(SPELL_WOUNDING_WHISPERS) ) {
            RemoveSpellEffects(SPELL_WOUNDING_WHISPERS, OBJECT_SELF, OBJECT_SELF );
        }
    }
    else if( nPoly == 126 )
    {
        ePoly = EffectLinkEffects( EffectDamageShield( GetLevelByClass( CLASS_TYPE_SHIFTER, oTarget ), DAMAGE_BONUS_1d6, DAMAGE_TYPE_ELECTRICAL ), ePoly );
        if ( GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD) ) {
            RemoveSpellEffects(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF, OBJECT_SELF );
        }
        if ( GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH) ) {
            RemoveSpellEffects(SPELL_MESTILS_ACID_SHEATH, OBJECT_SELF, OBJECT_SELF );
        }
        if ( GetHasSpellEffect(SPELL_WOUNDING_WHISPERS) ) {
            RemoveSpellEffects(SPELL_WOUNDING_WHISPERS, OBJECT_SELF, OBJECT_SELF );
        }
    }
    else if( nPoly == 128 )
    {
        ePoly = EffectLinkEffects( EffectDamageShield( GetLevelByClass( CLASS_TYPE_SHIFTER, oTarget ), DAMAGE_BONUS_1d6, DAMAGE_TYPE_ACID ), ePoly );
        if ( GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD) ) {
            RemoveSpellEffects(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF, OBJECT_SELF );
        }
        if ( GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH) ) {
            RemoveSpellEffects(SPELL_MESTILS_ACID_SHEATH, OBJECT_SELF, OBJECT_SELF );
        }
        if ( GetHasSpellEffect(SPELL_WOUNDING_WHISPERS) ) {
            RemoveSpellEffects(SPELL_WOUNDING_WHISPERS, OBJECT_SELF, OBJECT_SELF );
        }
    }
    else if( nPoly == 130 )
    {
        ePoly = EffectLinkEffects( EffectDamageShield( GetLevelByClass( CLASS_TYPE_SHIFTER, oTarget ), DAMAGE_BONUS_1d6, DAMAGE_TYPE_ACID ), ePoly );
        if ( GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD) ) {
            RemoveSpellEffects(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF, OBJECT_SELF );
        }
        if ( GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH) ) {
            RemoveSpellEffects(SPELL_MESTILS_ACID_SHEATH, OBJECT_SELF, OBJECT_SELF );
        }
        if ( GetHasSpellEffect(SPELL_WOUNDING_WHISPERS) ) {
            RemoveSpellEffects(SPELL_WOUNDING_WHISPERS, OBJECT_SELF, OBJECT_SELF );
        }
    }
    else if( nPoly == 132 )
    {
        ePoly = EffectLinkEffects( EffectDamageShield( GetLevelByClass( CLASS_TYPE_SHIFTER, oTarget ), DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD ), ePoly );
        if ( GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD) ) {
            RemoveSpellEffects(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF, OBJECT_SELF );
        }
        if ( GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH) ) {
            RemoveSpellEffects(SPELL_MESTILS_ACID_SHEATH, OBJECT_SELF, OBJECT_SELF );
        }
        if ( GetHasSpellEffect(SPELL_WOUNDING_WHISPERS) ) {
            RemoveSpellEffects(SPELL_WOUNDING_WHISPERS, OBJECT_SELF, OBJECT_SELF );
        }
    }

    int nStrBefore,nConBefore,nDexBefore,nStrAfter,nConAfter,nDexAfter;
    nStrBefore = GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH, TRUE);
    nConBefore = GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, TRUE);
    nDexBefore = GetAbilityScore(OBJECT_SELF, ABILITY_DEXTERITY, TRUE);
    nStrAfter = StringToInt( Get2DAString( "polymorph", "STR", nPoly ) );
    nConAfter = StringToInt( Get2DAString( "polymorph", "CON", nPoly ) );
    nDexAfter = StringToInt( Get2DAString( "polymorph", "DEX", nPoly ) );
    SendMessageToPC( OBJECT_SELF, "<c � >STR: " + IntToString(nStrBefore) + " -> " + IntToString(nStrAfter));
    SendMessageToPC( OBJECT_SELF, "<c � >DEX: " + IntToString(nDexBefore) + " -> " + IntToString(nDexAfter));
    SendMessageToPC( OBJECT_SELF, "<c � >CON: " + IntToString(nConBefore) + " -> " + IntToString(nConAfter));
    if ( nStrBefore > nStrAfter ) {
        ePoly = EffectLinkEffects( EffectAbilityIncrease( ABILITY_STRENGTH, ( nStrBefore - nStrAfter ) ), ePoly);
    }
    if ( nConBefore > nConAfter ) {
        ePoly = EffectLinkEffects( EffectAbilityIncrease( ABILITY_CONSTITUTION, ( nConBefore - nConAfter ) ), ePoly);
    }
    if ( nDexBefore > nDexAfter ) {
        ePoly = EffectLinkEffects( EffectAbilityIncrease( ABILITY_DEXTERITY, ( nDexBefore - nDexAfter ) ), ePoly);
    }

    ePoly = ExtraordinaryEffect( ePoly );
    ClearAllActions(); // prevents an exploit
    SetLocalInt( OBJECT_SELF, "LAST_POLY_ID", nPoly );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( iVis ), OBJECT_SELF);
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePoly, OBJECT_SELF );
    SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId( ), FALSE ) );
    //--------------------------------------------------------------------------
    // This code handles the merging of item properties
    //--------------------------------------------------------------------------

    SetLocalInt( OBJECT_SELF, "CannotDrown", nCannotDrown );

    //This is it
    ShifterMerge( OBJECT_SELF, oWeaponOld, oArmor, oRing1, oRing2, oBoots, oSheild, oAmulet, oCloak, oHands, oBelt, oHelm, nPoly );

    SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + IntToString( GetSpellId( ) ), 2147483646 );

    SetLocalInt( OBJECT_SELF, "LAST_POLY_EFFECT", GetSpellId( ) );
}




