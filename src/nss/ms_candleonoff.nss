void main()
{

    string sCandle = GetLocalString(OBJECT_SELF, "CandleTag");
    object oCandle = GetObjectByTag (sCandle);

    if (GetLocalInt(OBJECT_SELF,"NW_L_AMION") == 0)
    {
        AssignCommand( oCandle, ActionPlayAnimation( ANIMATION_PLACEABLE_ACTIVATE ) );
        SetLocalInt(OBJECT_SELF,"NW_L_AMION",1);
        effect eLight = EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_20);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, OBJECT_SELF);
    }
    else
    {
        AssignCommand( oCandle, ActionPlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
        SetLocalInt(OBJECT_SELF,"NW_L_AMION",0);
        effect eEffect = GetFirstEffect(OBJECT_SELF);
        while (GetIsEffectValid(eEffect) == TRUE)
        {
            if (GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT)
                RemoveEffect(OBJECT_SELF, eEffect);
            eEffect = GetNextEffect(OBJECT_SELF);
        }

    }
}
