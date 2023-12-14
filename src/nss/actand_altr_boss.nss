/*
  Altar Boss summoning script

- Maverick00053 11/22/2023
*/

// Clears altar variables
void ClearAltar(object oAltar);

// Destroys all things in the altars inventory
void DestroyAllInventory(object oAltar);

// Spawns boss visual
void SpawnBossVisuals();

// Spawns boss
void SpawnBoss();

void main()
{
    object oPC = GetLastClosedBy();
    object oAltar = OBJECT_SELF;


    ClearAltar(oAltar);

    string sTag;
    object oItem = GetFirstItemInInventory( oAltar );
    while ( GetIsObjectValid(oItem) )
    {
      sTag = GetTag( oItem );
      if ( sTag == "actlandblessing1" ) SetLocalInt( oAltar, "actlandbless1", TRUE );
      else if ( sTag == "actlandblessing2" ) SetLocalInt( oAltar, "actlandbless2", TRUE );
      else if ( sTag == "actlandblessing3" ) SetLocalInt( oAltar, "actlandbless3", TRUE );
      else if ( sTag == "actlandblessing4" ) SetLocalInt( oAltar, "actlandbless4", TRUE );
      else if ( sTag == "actlandblessing5" ) SetLocalInt( oAltar, "actlandbless5", TRUE );
      else if ( sTag == "actlandblessing6" ) SetLocalInt( oAltar, "actlandbless6", TRUE );
      else if ( sTag == "actlandblessing7" ) SetLocalInt( oAltar, "actlandbless7", TRUE );
      else if ( sTag == "actlandblessing8" ) SetLocalInt( oAltar, "actlandbless8", TRUE );

      oItem = GetNextItemInInventory( oAltar );
    }

    int nSpawnBoss = TRUE;
    // Now check the list to see if everything is present.
    int i, nHasItem;
    for ( i=1; i<=8; ++i ) {
        nHasItem = GetLocalInt( oAltar, "actlandbless" + IntToString(i) );
        if ( nHasItem == FALSE ) {
            nSpawnBoss = FALSE;
            break;
        }
    }

   if(nSpawnBoss == TRUE)
   {
     object oPC = GetLastClosedBy();
     int nCount = GetLocalInt( oPC, "actlandsecret" );
     SetLocalInt( oPC, "actlandsecret", ( nCount + 1 ) );

     if(nCount == 0)
     {
       SpawnBossVisuals();
       DelayCommand(3.0,SpawnBoss());
       DestroyAllInventory(oAltar);
       AssignCommand(oAltar,ActionSpeakString("The altar trembles and releases a powerful wave of energy that suddenly attracts something very, very hungry..."));
      }
      else
      {
       SendMessageToPC( oPC, "Despite the blessings being consumed, nothing else appears to happen." );
      }
    }

}

void ClearAltar(object oAltar)
{
    object oSelf = OBJECT_SELF;

    int i;
    for ( i=1; i<=8; ++i )
        SetLocalInt( oAltar, "actlandbless" + IntToString(i), FALSE );
}

void DestroyAllInventory(object oAltar)
{
    object oItem = GetFirstItemInInventory( oAltar );
    while ( GetIsObjectValid(oItem) )
    {
        DestroyObject( oItem );
        oItem = GetNextItemInInventory( oAltar );
    }
}

void SpawnBossVisuals()
{
  effect eVis1 = EffectVisualEffect(VFX_IMP_HARM);
  effect eVis2 = EffectVisualEffect(VFX_FNF_IMPLOSION);
  float nTime = 6.0;

  ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eVis1,GetLocation(GetWaypointByTag("actandsecretbosslight1")),nTime);
  ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eVis1,GetLocation(GetWaypointByTag("actandsecretbosslight2")),nTime);
  ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eVis1,GetLocation(GetWaypointByTag("actandsecretbosslight3")),nTime);
  ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eVis1,GetLocation(GetWaypointByTag("actandsecretbosslight4")),nTime);
  ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eVis1,GetLocation(GetWaypointByTag("actandsecretbosslight5")),nTime);
  ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eVis2,GetLocation(GetWaypointByTag("actandsecretboss")),nTime);

}


void SpawnBoss()
{
  CreateObject(OBJECT_TYPE_CREATURE,"actandsecretboss",GetLocation(GetWaypointByTag("actandsecretboss")));
}
