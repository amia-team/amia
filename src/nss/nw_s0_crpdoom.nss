//::///////////////////////////////////////////////
//:: Creeping Doom
//:: NW_S0_CrpDoom
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The druid calls forth a mass of churning insects
    and scorpians that bite and sting all those within
    a 20ft square.  The total spell effects does
    1000 damage to all withiin the area of effect
    until all damage is dealt.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  , 2001
//:://////////////////////////////////////////////
//Needed would require an entry into the VFX_Persistant.2DA and a new AOE constant

#include "x2_inc_spellhook"
#include "inc_td_shifter"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_CREEPING_DOOM);
    effect eVFX;
    location lTarget = GetSpellTargetLocation();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    object oPLC;
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration *2;    //Duration is +100%
    }

    int nShape = GetAppearanceType( OBJECT_SELF );
    if( GetIsPolymorphed( OBJECT_SELF ) && nShape == 39 )// custom Risen Thane changes
    {
       ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetMaxHitPoints( OBJECT_SELF ) / 5 ), OBJECT_SELF );
       nDuration = GetNewCasterLevel( OBJECT_SELF );
       eAOE = EffectAreaOfEffect( 37, "****", "cs_bonestorm_a", "****" );
       eVFX = EffectVisualEffect( 1047 );
       oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, "cus_foxfire", lTarget );
       DelayCommand( 0.5, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration)));
       DelayCommand( 0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPLC, RoundsToSeconds(nDuration)));
       DestroyObject( oPLC, RoundsToSeconds(nDuration) + 0.5);
       return;
    }


    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

