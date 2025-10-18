void main()
{
    int paramQuiver = StringToInt(GetScriptParam("quiver"));
    int paramArrow = StringToInt(GetScriptParam("arrow"));
    object pc = GetPCSpeaker();

    SetLocalInt(pc, "race", paramQuiver);
    SetLocalInt(pc, "arrow", paramArrow);
    ExecuteScript("quiver_select", pc);
}
