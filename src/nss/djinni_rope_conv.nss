/*
  Djinni rope puzzle convo launch - initial
  - Mav, 2/20/25
*/


void main()
{
    //Get PC
    object oPC = GetPCSpeaker();
    SetLocalObject(oPC,"ropeplc",OBJECT_SELF);
    ExecuteScript("djinni_puz_rope",oPC);
}
