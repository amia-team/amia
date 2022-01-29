// Elemental Shape

// Redesigned from scratch to allow three levels of progression.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/10/2012 PaladinOfSune    Initial Release
//


#include "x2_inc_itemprop"
#include "amia_include"

void main()
{
    int     nSpell      = GetSpellId();
    object  oTarget     = GetSpellTargetObject();

    effect  eVFX1       = EffectVisualEffect( VFX_IMP_POLYMORPH );
    int     nVFX2;

    effect  ePoly;
    int     nPoly;

    int     nDruid       = GetLevelByClass( CLASS_TYPE_DRUID );
    int     nShifter     = GetLevelByClass( CLASS_TYPE_SHIFTER );

    int     nClass;

    int     nLevel       = nDruid + nShifter;


    if(GetLocalInt(OBJECT_SELF,"POLY_COOLDOWN") == 1)
    {
      SendMessageToPC(OBJECT_SELF,"Slow down! You are polymorphing too fast!");
      return;
    }

    if( nDruid > nShifter )
    {
        nClass = nDruid;
    }
    else
    {
        nClass = nShifter;
    }

    int nDrown = ds_check_uw_items ( OBJECT_SELF ) ;

    if( nSpell == 397 ) // Fire elemental
    {
        if( nLevel >= 16 && nLevel < 20 )
        {
            nPoly = 199;
        }
        else if( nLevel >= 20 && nLevel < 25 ) // Huge
        {
            nPoly = 200;
        }
        else if( nLevel >= 25 ) // Elder
        {
            nPoly = 201;
        }
        else
        {
            return; // Error
        }
        nVFX2 = VFX_IMP_PULSE_FIRE; // Visual
    }
    else if( nSpell == 398 ) // Water elemental
    {
        if( nLevel >= 16 && nLevel < 20 )
        {
            nPoly = 202;
        }
        else if( nLevel >= 20 && nLevel < 25 ) // Huge
        {
            nPoly = 203;
        }
        else if( nLevel >= 25 ) // Elder
        {
            nPoly = 204;
        }
        else
        {
            return; // Error
        }
        nVFX2 = VFX_IMP_PULSE_WATER; // Visual
    }
    else if( nSpell == 399 ) // Earth elemental
    {
        if( nLevel >= 16 && nLevel < 20 )
        {
            nPoly = 205;
        }
        else if( nLevel >= 20 && nLevel < 25 ) // Huge
        {
            nPoly = 206;
        }
        else if( nLevel >= 25 ) // Elder
        {
            nPoly = 207;
        }
        else
        {
            return; // Error
        }
        nVFX2 = VFX_IMP_PULSE_NATURE; // Visual
    }
    else if( nSpell == 400 ) // Air elemental
    {
        if( nLevel >= 16 && nLevel < 20 )
        {
            nPoly = 208;
        }
        else if( nLevel >= 20 && nLevel < 25 ) // Huge
        {
            nPoly = 209;
        }
        else if( nLevel >= 25 ) // Elder
        {
            nPoly = 210;
        }
        else
        {
            return; // Error
        }
        nVFX2 = VFX_IMP_PULSE_WIND; // Visual
    }

    ePoly = EffectPolymorph( nPoly );
    ePoly = ExtraordinaryEffect( ePoly );

    //Fire cast spell at event for the specified target
    SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, SPELLABILITY_ELEMENTAL_SHAPE, FALSE ) );

    // Default Bioware merge code here.
    int bWeapon = StringToInt( Get2DAString("polymorph","MergeW",nPoly ) ) == 1;
    int bArmor  = StringToInt( Get2DAString("polymorph","MergeA",nPoly ) ) == 1;
    int bItems  = StringToInt( Get2DAString("polymorph","MergeI",nPoly ) ) == 1;

    object oWeaponOld   = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND,  OBJECT_SELF );
    object oArmorOld    = GetItemInSlot( INVENTORY_SLOT_CHEST,      OBJECT_SELF );
    object oRing1Old    = GetItemInSlot( INVENTORY_SLOT_LEFTRING,   OBJECT_SELF );
    object oRing2Old    = GetItemInSlot( INVENTORY_SLOT_RIGHTRING,  OBJECT_SELF );
    object oAmuletOld   = GetItemInSlot( INVENTORY_SLOT_NECK,       OBJECT_SELF );
    object oCloakOld    = GetItemInSlot( INVENTORY_SLOT_CLOAK,      OBJECT_SELF );
    object oBootsOld    = GetItemInSlot( INVENTORY_SLOT_BOOTS,      OBJECT_SELF );
    object oBeltOld     = GetItemInSlot( INVENTORY_SLOT_BELT,       OBJECT_SELF );
    object oHelmetOld   = GetItemInSlot( INVENTORY_SLOT_HEAD,       OBJECT_SELF );
    object oShield      = GetItemInSlot( INVENTORY_SLOT_LEFTHAND,   OBJECT_SELF );

    if ( GetIsObjectValid( oShield ) )
    {
        if ( GetBaseItemType( oShield ) != BASE_ITEM_LARGESHIELD &&
             GetBaseItemType( oShield ) != BASE_ITEM_SMALLSHIELD &&
             GetBaseItemType( oShield ) != BASE_ITEM_TOWERSHIELD )
        {
            oShield = OBJECT_INVALID;
        }
    }

    if( nPoly == 201 )
    {
        ePoly = EffectLinkEffects( EffectDamageShield( nClass, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE ), ePoly );
    }

    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, OBJECT_SELF );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( nVFX2 ), OBJECT_SELF );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, NewHoursToSeconds( nLevel ) );

    object oWeaponNew   = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND,  OBJECT_SELF );
    object oArmorNew    = GetItemInSlot( INVENTORY_SLOT_CARMOUR ,   OBJECT_SELF );

    // Rest of the default Bioware merge code here.
    if (bWeapon)
    {
        IPWildShapeCopyItemProperties( oWeaponOld,oWeaponNew, TRUE );
    }
    if (bArmor)
    {
        IPWildShapeCopyItemProperties( oHelmetOld,oArmorNew );
        IPWildShapeCopyItemProperties( oArmorOld,oArmorNew );
        IPWildShapeCopyItemProperties( oShield,oArmorNew );
    }
    if (bItems)
    {
        IPWildShapeCopyItemProperties( oRing1Old,oArmorNew );
        IPWildShapeCopyItemProperties( oRing2Old,oArmorNew );
        IPWildShapeCopyItemProperties( oAmuletOld,oArmorNew );
        IPWildShapeCopyItemProperties( oCloakOld,oArmorNew );
        IPWildShapeCopyItemProperties( oBootsOld,oArmorNew );
        IPWildShapeCopyItemProperties( oBeltOld,oArmorNew );
    }

    SetLocalInt( OBJECT_SELF, "CannotDrown", nDrown );
    //Poly cool down
    SetLocalInt( OBJECT_SELF, "POLY_COOLDOWN", 1 );
    DelayCommand(12.0,DeleteLocalInt(OBJECT_SELF,"POLY_COOLDOWN"));
}
