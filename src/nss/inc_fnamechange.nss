//Stores a line spoken by the player as a local string.

void GetSpokenText()
{
object PC = GetPCSpeaker();
object M = GetModule();
int iList = GetListenPatternNumber();
string sSaid = GetMatchedSubstring(0)+ GetMatchedSubstring(1);
SetLocalString(M, "FirstName", sSaid);
if (GetStringLength(sSaid) > 0)
   {
   SpeakString("You have said you want your first name to be: "+sSaid);
   SetListening(OBJECT_SELF, 0);
   }
   if (GetStringLength(sSaid) < 1)
      {
      SpeakString("You have not specified a valid name, please speak again");
      }
}

