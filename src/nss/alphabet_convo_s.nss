/*
  Alphabet puzzle convo launch - initial
  - Mav, 2/20/25
*/


void main()
{
    //Get PC
    object oPC       = GetPCSpeaker();
    SetLocalObject(oPC,"alphabet",OBJECT_SELF);
    ExecuteScript("alphabet_puzzle",oPC);
}
