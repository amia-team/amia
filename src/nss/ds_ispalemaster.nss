// the PC has at least 1 level Pale Master

int StartingConditional()
{
    int iResult;

    iResult = GetLevelByClass( CLASS_TYPE_PALE_MASTER, GetPCSpeaker()) > 0;
    return iResult;
}
