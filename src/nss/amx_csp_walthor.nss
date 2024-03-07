//::///////////////////////////////////////////////
//:: Wall of Thorns
//:: amx_csp_walthor.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/* Wall of Thorns (Conjuration)
Level: Druid 2
Components: V,S
Range: Medium
Duration: 1 Round/2 Caster Levels
Valid Metamagic: Still, Silent, Extend, Empower, Maximize
Save: None (Special)
Spell Resistance: No

A wall of thorns spell creates a barrier of very tough, pliable, tangled brush
bearing needle-sharp thorns as long as a human's finger.
Any creature forced into or attempting to move through a wall of thorns is
attacked with an AB of caster level + wisdom modifier + Spell Focus Bonus
against the target's AC. Should the roll hit, the victim will take 2d6 points of
piercing damage. Additionally, the victim will have their movement speed
reduced for 1 round per caster level.
*/
void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/
    //if (!X2PreSpellCastCode()) {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    //    return;
    //}

// End of Spell Cast Hook


    //Declare Area of Effect object using the appropriate constant
    effect eAOE = EffectAreaOfEffect(AOE_PER_WALLBLADE, "amx_csp_walthora", "amx_csp_walthorb");
    //Get the location where the wall is to be placed.
    location lTarget = GetSpellTargetLocation();
    int nDuration = GetCasterLevel(OBJECT_SELF) / 2;
    if(nDuration == 0)
    {
        nDuration = 1;
    }
    int nMetaMagic = GetMetaMagicFeat();

        //Check fort metamagic
        if (nMetaMagic == METAMAGIC_EXTEND)
        {
            nDuration = nDuration *2;   //Duration is +100%
        }
    //Create the Area of Effect Object declared above.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}