// Flame Weapon (Darkfire adaption).
//
// Gives a melee weapon 1d4 fire damage +1 per caster level to a maximum of
// +10.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/29/2002 Andrew Nobbs     Initial release.
// 07/07/2003 Georg Zoeller    Stacking spell pass.
// 07/15/2003 Andrew Nobbs     Complete Rewrite to make use of Item Property
//                             System
// 02/15/2004 jpavelch         Changed duration from turns to rounds.
// 04/01/2004 jpavelch         Spell no longer works with Thayvian crafted
//                             items.
// 12/20/2004 jpavelch         Changed duration to turns/level.
// 03/31/2007 kfw              Uses damage power instead.
// 2007-04-20 Disco            Changed visual fx ADDPROP_POLICY
// 2007-04-29 Disco            Changed damage
// 2007-10-13 Disco            Transmutation

// Includes.
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "inc_td_itemprop"
#include "amia_include"

void main( ){

    // Execute spellhook.
    if( !X2PreSpellCastCode( ) )
        return;

    // Variables.
    object oCaster                  = OBJECT_SELF;
    int nCasterLevel                = GetCasterLevel( oCaster );
    float fDuration                 = NewHoursToSeconds( nCasterLevel * ( GetMetaMagicFeat( ) == METAMAGIC_EXTEND ? 2 : 1 ) );
    object oWeapon                  = GetTargetedOrEquippedWeaponForSpell(SPELL_DARKFIRE, 1);

    if ( fDuration == 0.0 ){

        return;
    }

    // Filter: Invalid weaponry.
    if( !GetIsObjectValid( oWeapon ) ){
        FloatingTextStrRefOnCreature( 83615, oCaster );
        return;
    }

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_DARKFIRE ) );

    if ( GetIsObjectValid( GetSpellCastItem() ) ) {

        nTransmutation = 1;
    }

    effect eCastVisual;

    int nElement                    = IP_CONST_DAMAGETYPE_FIRE;
    int nCastVisual                 = VFX_IMP_PULSE_FIRE;
    int nWepVisual                  = ITEM_VISUAL_FIRE;

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    if ( nTransmutation == 2 ){

        nElement                    = IP_CONST_DAMAGETYPE_COLD;
        nCastVisual                 = VFX_IMP_PULSE_COLD;
        nWepVisual                  = ITEM_VISUAL_COLD;
    }
    else if ( nTransmutation == 3 ){

        nElement                    = IP_CONST_DAMAGETYPE_ELECTRICAL;
        nCastVisual                 = VFX_IMP_PULSE_WATER;
        nWepVisual                  = ITEM_VISUAL_ELECTRICAL;
    }

    int nDamage                     = IP_CONST_DAMAGEBONUS_1d4;

    // Configure the damage.
    if(         nCasterLevel >= 25 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d12;
    else if(    nCasterLevel >= 20 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d10;
    else if(    nCasterLevel >= 15 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d8;
    else if(    nCasterLevel >= 10 )
        nDamage                     = IP_CONST_DAMAGEBONUS_1d6;

    // Apply casting visual to the weapon wielder.
    eCastVisual = EffectVisualEffect( nCastVisual );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eCastVisual, GetItemPossessor( oWeapon ) );

    // Anti-stacking.
    IPRemoveMatchingItemProperties( oWeapon, ITEM_PROPERTY_DAMAGE_BONUS );

    // Apply damage power and visual to the weapon itself.
    IPSafeAddItemProperty(
        oWeapon,
        ItemPropertyDamageBonus( nElement, nDamage ),
        fDuration,
        X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
    IPSafeAddItemProperty(
        oWeapon,
        ItemPropertyVisualEffect( nWepVisual ),
        fDuration );

    return;

}

/*
void AddFlamingEffectToWeapon(object oTarget, float fDuration, int nCasterLevel)
{
   // If the spell is cast again, any previous itemproperties matching are removed.
   IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(124,nCasterLevel), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_FIRE), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
   return;
}

void main()
{
      //Spellcast Hook Code
      //Added 2003-07-07 by Georg Zoeller
      //If you want to make changes to all spells,
      //check x2_inc_spellhook.nss to find out more

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    // End of Spell Cast Hook


    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);

    //Limit nCasterLvl to 10, so it max out at +10 to the damage.
    if(nCasterLvl > 10)
    {
        nCasterLvl = 10;
    }

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

   object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();

   if(GetIsObjectValid(oMyWeapon) )
   {
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if ( TCS_GetIsThayvian(oMyWeapon) ) {
            SendMessageToPC( OBJECT_SELF, "This spell does not work on Thayvian crafted items" );
            return;
        }

        if ( GetLocalInt(oMyWeapon, "EnchantWeapon") ) {
            SendMessageToPC( OBJECT_SELF, "This spell does not stack with your weapon enchantment!" );
            return;
        }

        if (nDuration>0)
        {
            // haaaack: store caster level on item for the on hit spell to work properly
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
            AddFlamingEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration),nCasterLvl);

         }
            return;
    }
     else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
           return;
    }
}*/
