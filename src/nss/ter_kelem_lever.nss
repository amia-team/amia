//Used to remove the blinkyblink from the plates.
//Bad idea to use on anything else.
void RemoveAllEffects(object oPlaceable);

void main()
{
//Declare variables
object oChair;
object oShakles         = GetObjectByTag("kelem_shakles");
object oCourage         = GetObjectByTag("Courage");
object oTruth           = GetObjectByTag("Truth");
object oJustice         = GetObjectByTag("Justice");
object oPrudence        = GetObjectByTag("Prudence");
object oLoyalty         = GetObjectByTag("Loyalty");
object oFaith           = GetObjectByTag("Faith");
object oHonour          = GetObjectByTag("Honour");
object oMercy           = GetObjectByTag("Mercy");
effect eEpicWard        = EffectVisualEffect(VFX_DUR_PROT_EPIC_ARMOR_2);
effect eEffectBlinky    = EffectVisualEffect(VFX_DUR_AURA_PULSE_MAGENTA_WHITE);
string sTag             = GetTag(OBJECT_SELF);
int iONOFFBool          = GetLocalInt(OBJECT_SELF,"ON_OFF_BOOL");
//---

//Check if it is the lever in the office or not.
if(sTag != "kelem_office_lever")
{
    if(iONOFFBool == 0)
    {
    ActionPlayAnimation (ANIMATION_PLACEABLE_ACTIVATE, 1.0f, 1.0f);
    SetLocalInt(OBJECT_SELF,"ON_OFF_BOOL",1);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEpicWard,oShakles);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffectBlinky,oCourage);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffectBlinky,oFaith);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffectBlinky,oHonour);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffectBlinky,oJustice);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffectBlinky,oLoyalty);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffectBlinky,oPrudence);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffectBlinky,oTruth);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEffectBlinky,oMercy);
    return;//less return it just incase.
    }
    else
    {
    ActionPlayAnimation (ANIMATION_PLACEABLE_DEACTIVATE, 1.0f, 1.0f);
    SetLocalInt(OBJECT_SELF,"ON_OFF_BOOL",0);
    DelayCommand(1.0,RemoveAllEffects(oCourage));
    DelayCommand(1.0,RemoveAllEffects(oFaith));
    DelayCommand(1.0,RemoveAllEffects(oHonour));
    DelayCommand(1.0,RemoveAllEffects(oJustice));
    DelayCommand(1.0,RemoveAllEffects(oLoyalty));
    DelayCommand(1.0,RemoveAllEffects(oPrudence));
    DelayCommand(1.0,RemoveAllEffects(oShakles));
    DelayCommand(1.0,RemoveAllEffects(oTruth));
    DelayCommand(1.0,RemoveAllEffects(oMercy));
    eEffectBlinky = EffectVisualEffect(VFX_FNF_PWKILL);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eEffectBlinky,oShakles);
    return;//less return it just incase,again.
    }
}
//Do the office lever function instead of the judge room one.
else
{
    if(iONOFFBool == 0)
    {
    ActionPlayAnimation (ANIMATION_PLACEABLE_ACTIVATE, 1.0f, 1.0f);
    SetLocalInt(OBJECT_SELF,"ON_OFF_BOOL",1);
    oChair = GetObjectByTag("kelem_officechair_1");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEpicWard,oChair);
    oChair = GetObjectByTag("kelem_officechair_2");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eEpicWard,oChair);
    return;
    }
    else
    {
    eEffectBlinky = EffectVisualEffect(VFX_FNF_PWKILL);
    ActionPlayAnimation (ANIMATION_PLACEABLE_DEACTIVATE, 1.0f, 1.0f);
    SetLocalInt(OBJECT_SELF,"ON_OFF_BOOL",0);
    oChair = GetObjectByTag("kelem_officechair_1");
    DelayCommand(1.0,RemoveAllEffects(oChair));
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eEffectBlinky,oChair);
    oChair = GetObjectByTag("kelem_officechair_2");
    DelayCommand(1.0,RemoveAllEffects(oChair));
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eEffectBlinky,oChair);
    return;
    }
}
}

//Function body
void RemoveAllEffects(object oPlaceable)
{
effect eEffect = GetFirstEffect(oPlaceable);
while(GetIsEffectValid(eEffect))
{
RemoveEffect(oPlaceable,eEffect);
eEffect = GetNextEffect(oPlaceable);
}
}
