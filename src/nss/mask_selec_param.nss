void main()
{
    int param = StringToInt(GetScriptParam("mask"));
    object pc = GetPCSpeaker();

    SetLocalInt(pc, "mask", param);
    ExecuteScript("mask_select", pc);
}
