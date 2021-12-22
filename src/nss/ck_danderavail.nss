

int StartingConditional()
{
    return ( GetHitDice(GetPCSpeaker()) >= 8
            && GetLocalInt(OBJECT_SELF, "IAmBusy") == FALSE );
}
