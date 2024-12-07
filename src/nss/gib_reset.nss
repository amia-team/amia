/*
  Resets the Gib encounter
  - Maverick00053
*/

void main()
{
  object oPLC = GetObjectByTag("gib_climb_dest");

  if(GetIsObjectValid(oPLC) && (GetResRef(oPLC)=="gib_boss_plc"))
  {
    DelayCommand(5.0,DestroyObject(oPLC));
  }
}
