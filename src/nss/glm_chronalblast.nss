//--------------------------------------------------------------
// Executed script for Chronal Blast ability
//--------------------------------------------------------------

object oCritter = OBJECT_SELF;

object GetRandomEnemy(object oCritter);
void TargetLocation(object oCritter, object oTarget);
void BlastDamage(object oCritter, object oTarget);

void main()
{
    object oTarget = GetRandomEnemy(oCritter);

    if ( oTarget == OBJECT_INVALID )
    {
        return;
    }

    location lTarget = GetLocation(oTarget);
    CreateObject(OBJECT_TYPE_PLACEABLE, "chronaltarget", lTarget, FALSE, "");
    effect eTrap = EffectCutsceneImmobilize();
    eTrap = SupernaturalEffect(eTrap);

    SetLocalInt(oTarget, "HasPhaneAbility", 2);
    DelayCommand(6.5, SetLocalInt(oTarget, "HasPhaneAbility", 1));

    if (GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS) == FALSE)
    {
        AssignCommand(oTarget, ClearAllActions());
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrap, oTarget, 6.0);
    }
    object oChronalTarget = GetNearestObjectByTag("chronaltarget", oTarget);
    DelayCommand(0.1, TargetLocation(oCritter, oTarget));
    DelayCommand(0.2, SetLocalObject(oTarget, "chronaltarget", oChronalTarget));
    DelayCommand(6.0, BlastDamage(oCritter, oTarget));
}

object GetRandomEnemy( object oCritter )
{
    object oLastValid;
    object oEnemy;
    int nCritters = GetLocalInt(oCritter, "enemies");
    int nRandom = Random(nCritters) + 1;
    int i;
    object oArea = GetArea(oCritter);

    for (i=1; i<=nCritters; ++i)
    {
        object oEnemy = GetLocalObject(oCritter, "pc_"+IntToString(i));
        int nAffected = GetLocalInt(oEnemy, "HasPhaneAbility");

        if (i == nRandom && GetIsObjectValid(oEnemy) && !GetIsDead(oEnemy) && nAffected <= 1 && GetArea(oEnemy) == oArea)
        {
            return oEnemy;
        }
        else if (GetIsObjectValid(oEnemy) && !GetIsDead(oEnemy) && GetArea(oEnemy) == oArea)
        {
             oLastValid = oEnemy;
        }
    }
    return oLastValid;
}

void TargetLocation(object oCritter, object oTarget)
{
    object oBlast = GetLocalObject(oTarget, "chronaltarget");
    effect ePreBlast = EffectVisualEffect(VFX_DUR_AURA_POISON, FALSE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePreBlast, oBlast, 6.0);
}

void BlastDamage(object oCritter, object oTarget)
{
    effect eVFX = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY, FALSE);
    effect eBlast = EffectVisualEffect(VFX_FNF_SOUND_BURST, FALSE);
    effect eKD = EffectKnockdown();
    object oBlast = GetLocalObject(oTarget, "chronaltarget");
    location lBlast = GetLocation(oBlast);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lBlast, FALSE, OBJECT_TYPE_CREATURE);

    while(GetIsObjectValid(oTarget))
    {
        if(!GetIsFriend(oTarget, oCritter))
        {
            int nDamage = d6(20);
            effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
            DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
            DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget));
            DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKD, oTarget, 3.0));
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lBlast, FALSE, OBJECT_TYPE_CREATURE);
    }
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eBlast, lBlast, 6.0);
    DestroyObject(oBlast);
}
