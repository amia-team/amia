void main()
{
    int param = StringToInt(GetScriptParam("race"));
    object pc = GetPCSpeaker();

    SetLocalInt(pc, "race", param);
    ExecuteScript("mask_race_select", pc);
}
