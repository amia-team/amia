/*
   Sub event for mod_mod_load after

- Maverick00053
*/

void main()
{
  if(GetActionMode(OBJECT_SELF,12)==TRUE)
  {
   SetActionMode(OBJECT_SELF,12,FALSE);
  }
}
