/*
 Special Trigger to display message or interact with Merc

*/


void main()
{
  object oTrigger = OBJECT_SELF;
  object oPC = GetEnteringObject( );

  if(!GetIsPC(oPC))
  {
   return;
  }

  object oHench = GetHenchman(oPC);
  int nMax = GetMaxHenchmen();

  if(!GetIsObjectValid(oHench))
  {
    AssignCommand( oPC, SpeakString( "<c¥  >*As you approach your destination the smell of gibberling and mouthers is strong here. Just over the boulders ahead and your fight will begin. You instinctively know to prepare now before climbing over*</c>" ) );
  }
  else
  {
    string sTag;
    int i;
    for(i=1;i<nMax+1;i++)
    {
      oHench = GetHenchman(oPC,i);
      if(!GetIsObjectValid(oHench))
      {
        break;
      }
      sTag = GetTag(oHench);

      if(sTag=="henchmenmerc")
      {
        if(GetLocalInt(oHench,"talked")==0)
        {
         AssignCommand(oHench, SpeakString( "Careful! Up ahead is where we are headed. Once we are over the boulders we might be trapped so prepare beforehand!" ));
         SetLocalInt(oHench,"talked",1);
        }
        break;
      }
    }
  }
}
