int StartingConditional()
{
    object oPC    = GetPCSpeaker();
    object oMaster = GetMaster(OBJECT_SELF);

    if(oPC == oMaster)
    return TRUE;

 return FALSE;
}
