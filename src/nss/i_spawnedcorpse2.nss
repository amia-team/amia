void main()
{
    SetIsDestroyable(FALSE, FALSE, FALSE);
    DelayCommand(1.0, SetLootable(OBJECT_SELF, TRUE));

    //ActionUnequipItem
    //SetLootable(OBJECT_SELF, TRUE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDeath(FALSE, FALSE), OBJECT_SELF, 0.0f);
}
