void main()
{
    int param = StringToInt(GetScriptParam("hat"));
    object pc = GetPCSpeaker();

    SetLocalInt(pc, "hat", param);
    ExecuteScript("hat_select", pc);
}
