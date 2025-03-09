/*
  Puzzle Laser Counter Clock wise rotate
  - Mav, 2/21/25
*/

void main()
{
    //Get PC
    object oPC = GetPCSpeaker();
    object oPLC = OBJECT_SELF;
    string sSource = GetLocalString(oPLC,"source");
    object oSource = GetObjectByTag(sSource);

    SetLocalObject(oPC,"laser",oPLC);
    float fFacing = GetFacing(oPLC);

    if(fFacing <= 270.0)
    {
     SetFacing(fFacing+45.0,oPLC);
    }
    else if(fFacing <= 315.0)
    {
     SetFacing(0.0,oPLC);
    }

    ExecuteScript("laser_puz_remove",oSource);

    if(sSource == "")
    {
     ExecuteScript("laser_main",oPLC);
    }
    else
    {
     DelayCommand(0.1,ExecuteScript("laser_main",oSource));
    }
}

