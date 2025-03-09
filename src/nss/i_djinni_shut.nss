/*

    Djinni Temple Dagger/Book Script that disables orbs
    - Mav, 2/28/25

*/

void Reactivate(object oTarget);

void main()
{

  object oItem = GetItemActivated();
  object oTarget = GetItemActivatedTarget();
  string sName = GetName(oTarget);

  if(((GetTag(oTarget)=="temple_1") || (GetTag(oTarget)=="temple_2") || (GetTag(oTarget)=="temple_3") || (GetTag(oTarget)=="temple_4") ||
  (GetTag(oTarget)=="temple_5") || (GetTag(oTarget)=="temple_6") || (GetTag(oTarget)=="temple_7")) && (GetLocalInt(oTarget,"shutdown")==0))
  {
    SetLocalInt(oTarget,"shutdown",1);
    SetName(oTarget,"Disabled Orb");
    AssignCommand(oTarget,SpeakString("*The orbs shutters and appears to be disabled for a time*"));
    DelayCommand(18.0,Reactivate(oTarget));
    DestroyObject(oItem,0.1);
  }
  else
  {
    AssignCommand(GetItemActivator(),SpeakString("*Nothing happens*"));
  }
}

void Reactivate(object oTarget)
{
  string sName = GetLocalString(oTarget,"name");
  SetName(oTarget,sName);
  DeleteLocalInt(oTarget,"shutdown");
  AssignCommand(oTarget,SpeakString("*The orbs hums and becomes activate once more*"));
}
