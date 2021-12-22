int StartingConditional()
{
    int iVictim = GetLocalInt(OBJECT_SELF, "GRIMM_SHACKLED");

    if(iVictim)
    return FALSE;
    else
    return TRUE;
}
