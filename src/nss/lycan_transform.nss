 /*
   Lycan Transformation Feat for the new class

   12/7/21 - Maverick00053

 */
#include "x2_inc_itemprop"
#include "x2_inc_shifter"
#include "amia_include"
#include "inc_td_shifter"
#include "x0_i0_spells"

//Merges oPC's old weapon according to the shifter rules
void GearMerge( object oPC, object oOldWeapon, object oArmor, object oRing1, object oRing2, object oBoots, object oSheild, object oAmulet, object oCloak, object oHands, object oBelt, object oHelm, int nPolymorph );

void main()
{
    object oPC = OBJECT_SELF;
    object  oTarget = GetSpellTargetObject();
    int     iVis = VFX_IMP_POLYMORPH;
    int     nLevelLycan = GetLevelByClass(53,oPC);
    int     nLevel = GetLevelByPosition(1,oPC) + GetLevelByPosition(2,oPC) + GetLevelByPosition(3,oPC);
    effect  ePoly;
    int     nPoly;
    int     nSpell = GetSpellId();
    int nAnimal;
    int nAnimalSkin;
    int nAnimalPo;


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

    if(GetHasFeat(1249,oPC)) // Wolf
    {
        if((nLevel >= 25) && (nLevelLycan==5))
        {
           nPoly = 273;
        }
        else if((nLevel >= 20) && (nLevelLycan==4))
        {
           nPoly = 272;
        }
        else if((nLevel >= 15) && (nLevelLycan==3))
        {
           nPoly = 271;
        }
        else if((nLevel >= 10) && (nLevelLycan==2))
        {
           nPoly = 270;
        }
        else if(nLevel >= 5)
        {
           nPoly = 269;
        }
        else if(nLevel >= 1)
        {
           nPoly = 268;
        }


      nAnimalSkin = 1616;
      nAnimalPo = 319;
    }
    else if(GetHasFeat(1250,oPC))  // Bear
    {
        if((nLevel >= 25) && (nLevelLycan==5))
        {
           nPoly = 279;
        }
        else if((nLevel >= 20) && (nLevelLycan==4))
        {
           nPoly = 278;
        }
        else if((nLevel >= 15) && (nLevelLycan==3))
        {
           nPoly = 277;
        }
        else if((nLevel >= 10) && (nLevelLycan==2))
        {
           nPoly = 276;
        }
        else if(nLevel >= 5)
        {
           nPoly = 275;
        }
        else if(nLevel >= 1)
        {
           nPoly = 274;
        }

      nAnimalSkin = 1502;
      nAnimalPo = 148;
    }
    else if(GetHasFeat(1251,oPC)) // Cat
    {
        if((nLevel >= 25) && (nLevelLycan==5))
        {
           nPoly = 285;
        }
        else if((nLevel >= 20) && (nLevelLycan==4))
        {
           nPoly = 284;
        }
        else if((nLevel >= 15) && (nLevelLycan==3))
        {
           nPoly = 283;
        }
        else if((nLevel >= 10) && (nLevelLycan==2))
        {
           nPoly = 282;
        }
        else if(nLevel >= 5)
        {
           nPoly = 281;
        }
        else if(nLevel >= 1)
        {
           nPoly = 280;
        }

      nAnimalSkin = 1504;
      nAnimalPo = 165;
    }
    else if(GetHasFeat(1252,oPC)) // Boar
    {
        if((nLevel >= 25) && (nLevelLycan==5))
        {
           nPoly = 291;
        }
        else if((nLevel >= 20) && (nLevelLycan==4))
        {
           nPoly = 290;
        }
        else if((nLevel >= 15) && (nLevelLycan==2))
        {
           nPoly = 289;
        }
        else if((nLevel >= 10) && (nLevelLycan==2))
        {
           nPoly = 288;
        }
        else if(nLevel >= 5)
        {
           nPoly = 287;
        }
        else if(nLevel >= 1)
        {
           nPoly = 286;
        }

      nAnimalSkin = 1814;
      nAnimalPo = 152;
    }
    else if(GetHasFeat(1253,oPC)) // Bat
    {
        if((nLevel >= 25) && (nLevelLycan==5))
        {
           nPoly = 297;
        }
        else if((nLevel >= 20) && (nLevelLycan==4))
        {
           nPoly = 296;
        }
        else if((nLevel >= 15) && (nLevelLycan==3))
        {
           nPoly = 295;
        }
        else if((nLevel >= 10) && (nLevelLycan==2))
        {
           nPoly = 294;
        }
        else if(nLevel >= 5)
        {
           nPoly = 293;
        }
        else if(nLevel >= 1)
        {
           nPoly = 292;
        }

      nAnimalSkin = 1087;
      nAnimalPo = 145;
    }
    else if(GetHasFeat(1254,oPC))   // Rat
    {
        if((nLevel >= 25) && (nLevelLycan==5))
        {
           nPoly = 303;
        }
        else if((nLevel >= 20) && (nLevelLycan==4))
        {
           nPoly = 302;
        }
        else if((nLevel >= 15) && (nLevelLycan==3))
        {
           nPoly = 301;
        }
        else if((nLevel >= 10) && (nLevelLycan==2))
        {
           nPoly = 300;
        }
        else if(nLevel >= 5)
        {
           nPoly = 299;
        }
        else if(nLevel >= 1)
        {
           nPoly = 298;
        }

      nAnimalSkin = 1257;
      nAnimalPo = 602;
    }
    else if(GetHasFeat(1276,oPC))   // Chicken
    {
        if((nLevel >= 25) && (nLevelLycan==5))
        {
           nPoly = 309;
        }
        else if((nLevel >= 20) && (nLevelLycan==4))
        {
           nPoly = 308;
        }
        else if((nLevel >= 15) && (nLevelLycan==3))
        {
           nPoly = 307;
        }
        else if((nLevel >= 10) && (nLevelLycan==2))
        {
           nPoly = 306;
        }
        else if(nLevel >= 5)
        {
           nPoly = 305;
        }
        else if(nLevel >= 1)
        {
           nPoly = 304;
        }

      nAnimalSkin = 1580;
      nAnimalPo = 168;
    }


    int nStrBefore,nConBefore,nDexBefore,nStrAfter,nConAfter,nDexAfter;
    nStrBefore = GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH, TRUE);
    nConBefore = GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, TRUE);
    nDexBefore = GetAbilityScore(OBJECT_SELF, ABILITY_DEXTERITY, TRUE);
    nStrAfter = StringToInt( Get2DAString( "polymorph", "STR", nPoly ) );
    nConAfter = StringToInt( Get2DAString( "polymorph", "CON", nPoly ) );
    nDexAfter = StringToInt( Get2DAString( "polymorph", "DEX", nPoly ) );
    SendMessageToPC( OBJECT_SELF, "<c þ >STR: " + IntToString(nStrBefore) + " -> " + IntToString(nStrAfter));
    SendMessageToPC( OBJECT_SELF, "<c þ >DEX: " + IntToString(nDexBefore) + " -> " + IntToString(nDexAfter));
    SendMessageToPC( OBJECT_SELF, "<c þ >CON: " + IntToString(nConBefore) + " -> " + IntToString(nConAfter));
    if ( nStrBefore > nStrAfter ) {
        ePoly = EffectLinkEffects( EffectAbilityIncrease( ABILITY_STRENGTH, ( nStrBefore - nStrAfter ) ), ePoly);
    }
    if ( nConBefore > nConAfter ) {
        ePoly = EffectLinkEffects( EffectAbilityIncrease( ABILITY_CONSTITUTION, ( nConBefore - nConAfter ) ), ePoly);
    }
    if ( nDexBefore > nDexAfter ) {
        ePoly = EffectLinkEffects( EffectAbilityIncrease( ABILITY_DEXTERITY, ( nDexBefore - nDexAfter ) ), ePoly);
    }


    // Bonus AC
    effect eACEffect = EffectACIncrease( nLevel/5, AC_SHIELD_ENCHANTMENT_BONUS );
    eACEffect = EffectLinkEffects( EffectACIncrease( nLevel/6, AC_NATURAL_BONUS ), eACEffect );
    eACEffect = EffectLinkEffects( EffectACIncrease( nLevel/6, AC_DEFLECTION_BONUS ), eACEffect );
    eACEffect = EffectLinkEffects( EffectACIncrease( nLevel/6, AC_DODGE_BONUS ), eACEffect );
    eACEffect = EffectLinkEffects( EffectACIncrease( nLevel/6, AC_ARMOUR_ENCHANTMENT_BONUS ), eACEffect );
    //

    ePoly = EffectPolymorph( nPoly );
    ePoly= EffectLinkEffects(eACEffect,ePoly);
    ePoly = ExtraordinaryEffect( ePoly );
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( iVis ), OBJECT_SELF);
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePoly, OBJECT_SELF );
    SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId( ), FALSE ) );

    // Remove Bard Song if its on
    effect eLoop = GetFirstEffect(OBJECT_SELF);

    while(GetIsEffectValid(eLoop))
    {
     if(GetEffectSpellId(eLoop) == 411)
     {
       RemoveEffect(OBJECT_SELF,eLoop);
     }

     eLoop = GetNextEffect(OBJECT_SELF);
    }

    //



    //


    if(nSpell == 980) // Animal
    {
        SetCreatureAppearanceType(OBJECT_SELF, nAnimalSkin);
        SetPortraitId(OBJECT_SELF, nAnimalPo);
    }

    //Drowning!
    int nCannotDrown = ds_check_uw_items( OBJECT_SELF );

    //--------------------------------------------------------------------------
    // This code handles the merging of item properties
    //--------------------------------------------------------------------------

    SetLocalInt( OBJECT_SELF, "CannotDrown", nCannotDrown );

    //This is it
    GearMerge( OBJECT_SELF, oWeaponOld, oArmor, oRing1, oRing2, oBoots, oSheild, oAmulet, oCloak, oHands, oBelt, oHelm, nPoly );

    SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + IntToString( GetSpellId( ) ), 2147483646 );

    SetLocalInt( OBJECT_SELF, "LAST_POLY_EFFECT", GetSpellId( ) );
}

void GearMerge( object oPC, object oOldWeapon, object oArmor, object oRing1, object oRing2, object oBoots, object oSheild, object oAmulet, object oCloak, object oHands, object oBelt, object oHelm, int nPolymorph ){

    object oWeaponNew   = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );
    object oRClaw       = GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oPC );
    object oLClaw       = GetItemInSlot( INVENTORY_SLOT_CWEAPON_L, oPC );
    object oBite        = GetItemInSlot( INVENTORY_SLOT_CWEAPON_B, oPC );
    object oArmorNew    = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oPC );

    if( oOldWeapon == oWeaponNew )
        return;

    RemoveItemPropertyByType( oWeaponNew, ITEM_PROPERTY_VISUALEFFECT );

    if( GetIsObjectValid( oWeaponNew ) && GetIsObjectValid( oOldWeapon ) ){

        SendMessageToPC( oPC, "<c þ >Merging "+GetName( oOldWeapon )+" with "+GetName( oWeaponNew )+"!" );
        SetIdentified( oWeaponNew, TRUE );
        MergeItemProperties( oPC, oOldWeapon, oWeaponNew );
    }
    else if( ( GetIsObjectValid( oRClaw ) || GetIsObjectValid( oBite ) || GetIsObjectValid( oLClaw ) ) && GetIsObjectValid( oOldWeapon ) ){

        if( GetIsObjectValid( oRClaw ) ){
            SendMessageToPC( oPC, "<c þ >Merging "+GetName( oOldWeapon )+" with right claw!" );
            MergeItemProperties( oPC, oOldWeapon, oRClaw );
        }
        if( GetIsObjectValid( oBite ) ){
            SendMessageToPC( oPC, "<c þ >Merging "+GetName( oOldWeapon )+" with bite!" );
            MergeItemProperties( oPC, oOldWeapon, oBite );
        }
        if( GetIsObjectValid( oLClaw ) ){
            SendMessageToPC( oPC, "<c þ >Merging "+GetName( oOldWeapon )+" with left claw!" );
            MergeItemProperties( oPC, oOldWeapon, oLClaw );
        }

    }

    if( StringToInt( Get2DAString( "polymorph", "MergeA", nPolymorph ) ) ){


        if( GetIsObjectValid( oArmorNew ) ){

            SetIdentified( oArmorNew, TRUE );

            if( GetIsObjectValid( oArmor ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oArmor )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oArmor, oArmorNew );
            }

            if( GetIsObjectValid( oSheild ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oSheild )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oSheild, oArmorNew );
            }

            if( GetIsObjectValid( oHelm ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oHelm )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oHelm, oArmorNew );
            }
        }
    }

    if( StringToInt( Get2DAString( "polymorph", "MergeI", nPolymorph ) ) ){
        if( GetIsObjectValid( oArmorNew ) ){

            SetIdentified( oArmorNew, TRUE );

            if( GetIsObjectValid( oRing1 ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oRing1 )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oRing1, oArmorNew );
            }

            if( GetIsObjectValid( oRing2 ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oRing2 )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oRing2, oArmorNew );
            }

            if( GetIsObjectValid( oAmulet ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oAmulet )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oAmulet, oArmorNew );
            }

            if( GetIsObjectValid( oCloak ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oCloak )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oCloak, oArmorNew );
            }

            if( GetIsObjectValid( oBoots ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oBoots )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oBoots, oArmorNew );
            }

            if( GetIsObjectValid( oBelt ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oBelt )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oBelt, oArmorNew );
            }

            if( GetIsObjectValid( oHands ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oHands )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oHands, oArmorNew );
            }
        }
    }
}
