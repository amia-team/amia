 //-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai2_spellcast
//group:   ds_ai2


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oCritter = OBJECT_SELF;
    object oTarget  = GetLastSpellCaster();
    int nLastSpell  = GetLastSpell();
    int nCount      = GetLocalInt( OBJECT_SELF, L_INACTIVE );


    if(((nLastSpell==SPELL_MORDENKAINENS_DISJUNCTION) || (nLastSpell==SPELL_GREATER_DISPELLING) || (nLastSpell==SPELL_GREATER_SPELL_BREACH)) && (GetLocalInt(oCritter,"blocker")==0))
    {
      AssignCommand(oCritter,SpeakString("<c £ >**The magical dispell disables most of the guardian's wards and defenses for a short time**</c> Aarghh!"));
      effect eVuln1 = EffectDamageImmunityDecrease(DAMAGE_TYPE_ACID,75);
      effect eVuln2 = EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD,75);
      effect eVuln3 = EffectDamageImmunityDecrease(DAMAGE_TYPE_DIVINE,75);
      effect eVuln4 = EffectDamageImmunityDecrease(DAMAGE_TYPE_ELECTRICAL,75);
      effect eVuln5 = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE,75);
      effect eVuln6 = EffectDamageImmunityDecrease(DAMAGE_TYPE_MAGICAL,75);
      effect eVuln7 = EffectDamageImmunityDecrease(DAMAGE_TYPE_NEGATIVE,75);
      effect eVuln8 = EffectDamageImmunityDecrease(DAMAGE_TYPE_POSITIVE,75);
      effect eVuln9 = EffectDamageImmunityDecrease(DAMAGE_TYPE_SONIC,75);
      effect eVis = EffectVisualEffect(VFX_DUR_GLOW_LIGHT_RED);
      effect eLink = EffectLinkEffects(eVuln1,eVuln2);
      eLink = EffectLinkEffects(eLink,eVuln3);
      eLink = EffectLinkEffects(eLink,eVuln4);
      eLink = EffectLinkEffects(eLink,eVuln5);
      eLink = EffectLinkEffects(eLink,eVuln6);
      eLink = EffectLinkEffects(eLink,eVuln7);
      eLink = EffectLinkEffects(eLink,eVuln8);
      eLink = EffectLinkEffects(eLink,eVuln9);
      eLink = EffectLinkEffects(eLink,eVis);
      eLink = SupernaturalEffect(eLink);

      SetLocalInt(oCritter,"blocker",1);
      DelayCommand(30.0,DeleteLocalInt(oCritter,"blocker"));
      DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oCritter,30.0));
      DelayCommand(30.0,AssignCommand(oCritter,SpeakString("<c £ >**The magical wards and protections renable themselves!**</c>")));

    }

    if ( ( nCount == 0 || nCount > 1 ) && GetIsEnemy( oCritter, oTarget ) ){

        if ( PerformAction( oCritter, "djinni_spellc_ft" ) > 0 ){

            SetLocalInt( OBJECT_SELF, L_INACTIVE, 0 );
        }
    }
}

