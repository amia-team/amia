void main()
{
    int paramQuiver = StringToInt(GetScriptParam("quiver"));
    int paramArrow = StringToInt(GetScriptParam("arrow"));

    int selectedQuiver = StringToInt(GetScriptParam("is_quiver"));
    int selectedArrow = StringToInt(GetScriptParam("is_arrow"));

    object pc = GetPCSpeaker();

    SetLocalInt(pc, "quiver", paramQuiver);
    SetLocalInt(pc, "arrow", paramArrow);
    SetLocalInt(pc, "is_quiver", selectedQuiver);
    SetLocalInt(pc, "is_arrow", selectedArrow);

    ExecuteScript("quiver_select", pc);
}
