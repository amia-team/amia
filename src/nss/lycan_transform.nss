 /*
   Lycan Transformation Feat for the new class

   12/7/21 - Maverick00053

 */
#include "x2_inc_itemprop"
#include "x2_inc_shifter"
#include "amia_include"
#include "inc_td_shifter"
#include "x0_i0_spells"

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
    int nTail = 0;

    if(GetLocalInt(OBJECT_SELF,"POLY_COOLDOWN") == 1)
    {
      SendMessageToPC(OBJECT_SELF,"You must wait for the cool down to expire to shift again!");
      return;
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
    else if(GetHasFeat(1329,oPC))   // Owl -
    {
        if((nLevel >= 25) && (nLevelLycan==5))
        {
           nPoly = 316;
        }
        else if((nLevel >= 20) && (nLevelLycan==4))
        {
           nPoly = 315;
        }
        else if((nLevel >= 15) && (nLevelLycan==3))
        {
           nPoly = 314;
        }
        else if((nLevel >= 10) && (nLevelLycan==2))
        {
           nPoly = 313;
        }
        else if(nLevel >= 5)
        {
           nPoly = 312;
        }
        else if(nLevel >= 1)
        {
           nPoly = 311;
        }

      nAnimalSkin = 0;
      nAnimalPo = 0;
    }
    else if(GetHasFeat(1330,oPC))   // Croc
    {
        if((nLevel >= 25) && (nLevelLycan==5))
        {
           nPoly = 322;
        }
        else if((nLevel >= 20) && (nLevelLycan==4))
        {
           nPoly = 321;
        }
        else if((nLevel >= 15) && (nLevelLycan==3))
        {
           nPoly = 320;
        }
        else if((nLevel >= 10) && (nLevelLycan==2))
        {
           nPoly = 319;
        }
        else if(nLevel >= 5)
        {
           nPoly = 318;
        }
        else if(nLevel >= 1)
        {
           nPoly = 317;
        }

      nAnimalSkin = 1280;
      nAnimalPo = 1394;
      nTail = 842;
    }
    else if(GetHasFeat(1331,oPC))   // Shark
    {
        if((nLevel >= 25) && (nLevelLycan==5))
        {
           nPoly = 328;
        }
        else if((nLevel >= 20) && (nLevelLycan==4))
        {
           nPoly = 327;
        }
        else if((nLevel >= 15) && (nLevelLycan==3))
        {
           nPoly = 326;
        }
        else if((nLevel >= 10) && (nLevelLycan==2))
        {
           nPoly = 325;
        }
        else if(nLevel >= 5)
        {
           nPoly = 324;
        }
        else if(nLevel >= 1)
        {
           nPoly = 323;
        }

      nAnimalSkin = 1871;
      nAnimalPo = 731;
      nTail = 843;
    }
    else if(GetHasFeat(1332,oPC))   // Fox
    {
        if((nLevel >= 25) && (nLevelLycan==5))
        {
           nPoly = 334;
        }
        else if((nLevel >= 20) && (nLevelLycan==4))
        {
           nPoly = 333;
        }
        else if((nLevel >= 15) && (nLevelLycan==3))
        {
           nPoly = 332;
        }
        else if((nLevel >= 10) && (nLevelLycan==2))
        {
           nPoly = 331;
        }
        else if(nLevel >= 5)
        {
           nPoly = 330;
        }
        else if(nLevel >= 1)
        {
           nPoly = 329;
        }

      nAnimalSkin = 1844;
      nAnimalPo = 1473;
    }
    else if(GetHasFeat(1333,oPC))   // Raccoon
    {
        if((nLevel >= 25) && (nLevelLycan==5))
        {
           nPoly = 340;
        }
        else if((nLevel >= 20) && (nLevelLycan==4))
        {
           nPoly = 339;
        }
        else if((nLevel >= 15) && (nLevelLycan==3))
        {
           nPoly = 338;
        }
        else if((nLevel >= 10) && (nLevelLycan==2))
        {
           nPoly = 337;
        }
        else if(nLevel >= 5)
        {
           nPoly = 336;
        }
        else if(nLevel >= 1)
        {
           nPoly = 335;
        }

      nAnimalSkin = 1064;
      nAnimalPo = 1402; // Using the Jackal port as a sub for now
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
    effect eACEffect = EffectACIncrease( nLevelLycan+1, AC_SHIELD_ENCHANTMENT_BONUS );
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

    //Add tail if present
    if(nTail != 0)
    {
      DelayCommand(0.1,SetCreatureTailType(nTail,OBJECT_SELF));
    }

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
        if((nAnimalSkin==0))
        {
         SendMessageToPC(OBJECT_SELF,"You do not have a hybrid form.");
        }
        else
        {
         SetCreatureAppearanceType(OBJECT_SELF, nAnimalSkin);
         SetPortraitId(OBJECT_SELF, nAnimalPo);
        }
    }

    //--------------------------------------------------------------------------
    // This code handles the merging of item properties
    //--------------------------------------------------------------------------

    SetLocalInt( OBJECT_SELF, "CannotDrown", nCannotDrown );

    //This is it
    ShifterMerge( OBJECT_SELF, oWeaponOld, oArmor, oRing1, oRing2, oBoots, oSheild, oAmulet, oCloak, oHands, oBelt, oHelm, nPoly );

    SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + IntToString( GetSpellId( ) ), 2147483646 );

    SetLocalInt( OBJECT_SELF, "LAST_POLY_EFFECT", GetSpellId( ) );

}

