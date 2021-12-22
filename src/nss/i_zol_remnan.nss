#include "x2_inc_switches"
#include "nwnx_creature"

void IllusionistsGambit(location l, object caster);
void SpawnRemnantsRelativeToCaster(object caster);
void TeleportCasterAway(object caster);
void TeleportCasterToLocation(location l, object caster);
void DestroyAllShadowRemnants(object caster);

void main()
{
    int modEvent = GetUserDefinedItemEventNumber();
    int scriptResult = X2_EXECUTE_SCRIPT_END;
    string CASTER = "zol_caster";


    switch(modEvent)
    {
        case X2_ITEM_EVENT_ACTIVATE:
            object item = GetItemActivated();
            object caster = GetLocalObject(item, CASTER);
            location casterOriginalLocation = GetLocation(caster);

            int casterNotSelectedAndTargetIsCreature = (caster == OBJECT_INVALID) && (GetItemActivatedTarget() != OBJECT_INVALID) && (GetObjectType(GetItemActivatedTarget()) == OBJECT_TYPE_CREATURE);

            if(casterNotSelectedAndTargetIsCreature)
            {
                SetLocalObject(item, CASTER, GetItemActivatedTarget());
                caster = GetLocalObject(item, CASTER);
                FloatingTextStringOnCreature("Remnant is set to " + GetName(caster) + ".", GetItemActivator(), FALSE);
                return;
            }

            ChangeToStandardFaction(caster, STANDARD_FACTION_DEFENDER);
            AssignCommand(caster, ClearAllActions(TRUE));
            AssignCommand(caster, ActionSpeakString("*" + GetName(caster) + "'s voice echoes with a hollow timbre. Moments later, shadows manifest and " + GetName(caster) + " disappears.*"));
            AssignCommand(caster, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1));
            DelayCommand(2.0f, IllusionistsGambit(casterOriginalLocation, caster));
            ChangeToStandardFaction(caster, STANDARD_FACTION_HOSTILE);
        break;
    }

    SetExecutedScriptReturnValue(scriptResult);
}

void IllusionistsGambit(location casterOriginalLocation, object caster)
{
    SpawnRemnantsRelativeToCaster(caster);
    TeleportCasterAway(caster);
    DelayCommand(13.0, TeleportCasterToLocation(casterOriginalLocation, caster));
}

void SpawnRemnantsRelativeToCaster(object caster)
{
    object currentArea = GetArea(caster);
    vector casterVector = GetPosition(caster);

    vector vectNorthOfCaster = casterVector + Vector(0.0f, 7.0f, 0.0f);
    vector vectNorthEastOfCaster = casterVector + Vector(5.0f, 6.0f, 0.0f);
    vector vectEastOfCaster = casterVector + Vector(7.0f, 0.0f, 0.0f);
    vector vectSouthEastOfCaster = casterVector + Vector(5.0f, -6.0f, 0.0f);
    vector vectSouthOfCaster = casterVector + Vector(0.0f, -7.0f, 0.0f);
    vector vectSouthWestOfCaster = casterVector + Vector(-5.0f, -6.0f, 0.0f);
    vector vectWestOfCaster = casterVector + Vector(-7.0f, 0.0f, 0.0f);
    vector vectNorthWestOfCaster = casterVector + Vector(-5.0f, 6.0f, 0.0f);

    location north = Location(currentArea, vectNorthOfCaster, 0.0f);
    location northEast = Location(currentArea, vectNorthEastOfCaster, 0.0f);
    location east = Location(currentArea, vectEastOfCaster, 0.0f);
    location southEast = Location(currentArea, vectSouthEastOfCaster, 0.0f);
    location south = Location(currentArea, vectSouthOfCaster, 0.0f);
    location southWest = Location(currentArea, vectSouthWestOfCaster, 0.0f);
    location west = Location(currentArea, vectWestOfCaster, 0.0f);
    location northWest = Location(currentArea, vectNorthWestOfCaster, 0.0f);

    object northCopy = CopyObject(caster, north, caster, "zol_ill_remnant");
    object northEastCopy = CopyObject(caster, northEast, caster, "zol_ill_remnant");
    object eastCopy = CopyObject(caster, east, caster, "zol_ill_remnant");
    object southEastCopy = CopyObject(caster, southEast, caster, "zol_ill_remnant");
    object southCopy = CopyObject(caster, south, caster, "zol_ill_remnant");
    object southWestCopy = CopyObject(caster, southWest, caster, "zol_ill_remnant");
    object westCopy = CopyObject(caster, west, caster, "zol_ill_remnant");
    object northWestCopy = CopyObject(caster, northWest, caster, "zol_ill_remnant");


    SetCurrentHitPoints(northCopy, 50);
    SetCurrentHitPoints(northEastCopy, 50);
    SetCurrentHitPoints(eastCopy, 50);
    SetCurrentHitPoints(southEastCopy, 50);
    SetCurrentHitPoints(southCopy, 50);
    SetCurrentHitPoints(southWestCopy, 50);
    SetCurrentHitPoints(westCopy, 50);
    SetCurrentHitPoints(northWestCopy, 50);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR), northCopy, 200.0f);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR), northEastCopy, 200.0f);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR), eastCopy, 200.0f);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR), southEastCopy, 200.0f);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR), southCopy, 200.0f);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR), southWestCopy, 200.0f);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR), westCopy, 200.0f);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR), northWestCopy, 200.0f);
}

void TeleportCasterAway(object caster)
{
    object waypoint = GetObjectByTag("wp_ill_safe");
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(38), GetLocation(caster));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(31), GetLocation(caster));
    AssignCommand(caster, JumpToObject(waypoint));
}

void TeleportCasterToLocation(location l, object caster)
{
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(140), l);
    AssignCommand(caster, ActionJumpToLocation(l));
    DelayCommand(1.0, DestroyAllShadowRemnants(caster));
}


void DestroyAllShadowRemnants(object caster)
{
    object casterArea = GetArea(caster);
    object remnant = GetFirstObjectInArea(casterArea);

    while(GetIsObjectValid(remnant))
    {
        if(GetTag(remnant) == "zol_ill_remnant")
        {
            DestroyObject(remnant);
        }

        remnant = GetNextObjectInArea(casterArea);
    }
}
