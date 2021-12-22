int StartingConditional()
{
    int iVictim = GetLocalInt(OBJECT_SELF, "GRIMM_SHACKLED");

    if(iVictim)
    return TRUE;
    else
    return FALSE;
}
