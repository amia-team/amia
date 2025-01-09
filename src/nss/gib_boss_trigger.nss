/*
  Gibberling Boss Spawner  - Maverick00053, 12/6/24

*/
#include "amia_include"

void main()
{
    object oTrigger    = OBJECT_SELF;
    object oPC         = GetEnteringObject( );
    string sBossRef;
    int nBlocker = GetLocalInt(oTrigger,"blocked");
    string sQuest = GetLocalString (oTrigger, "Quest");
    int nRandom = Random(3);
    string sMessage;
    string sMessage2;
    effect eKD = EffectKnockdown();
    effect eVis = EffectVisualEffect(VFX_DUR_AURA_PULSE_MAGENTA_WHITE);


    if(GetIsPossessedFamiliar(oPC) || !GetIsPC(oPC) || (nBlocker==1))
    {
      return;
    }


    if( nBlocker > 0 ){

        SendMessageToPC( oPC, "*There are signs of recent fighting here...*" );
        return;
    }

    switch(nRandom)
    {
     case 0: sBossRef ="gib_boss_1"; sMessage = "Damn! Watch out its a massive Gibbering Mouther! It looks like its close to splitting."; sMessage2 = "You see the utterly disgusting mass of a huge Mouther ahead!"; break;
     case 1: sBossRef ="gib_boss_2"; sMessage = "Ah! Perfect. Quickly now! The Gibberlings are in dormancy and will take a while to wake up. Kill as many as you can!"; sMessage2 = "You see a whole horde of gibberlings currently dormant. Now is your chance!"; break;
     case 2: sBossRef ="gib_boss_3"; sMessage = "Oh no... That looks like one of our own. Damnit. We must end its misery before it does more harm!"; sMessage2 = "*You seem a bloated, malformed, and distorted form in the distance. This thing was once clearly an adventurer with what remains of its old gear still wrapped around its gross form."; break;
    }

   // Scan spawn trigger for spawn points.
    object oWaypoint = GetNearestObjectByTag( "CS_WP_BOSS", oTrigger );

    if( GetIsObjectValid( oWaypoint ) ){
       // Boss monster blueprint resref available and boss spawn point valid.
        if( sBossRef != "" )
        {
          if(nBlocker==0)
          {
            // Spawn.
            object oBoss = ds_spawn_critter( oPC, sBossRef, GetLocation( oWaypoint ) );
            SetLocalInt(oTrigger,"blocked",1);
            DelayCommand(600.0,DeleteLocalInt(oTrigger,"blocked"));

            if(sBossRef=="gib_boss_1")
            {
              ds_spawn_critter( oPC, "gibberingmouther", GetLocation( GetWaypointByTag("gib_spawner_3")));
              ds_spawn_critter( oPC, "gibberingmouther", GetLocation( GetWaypointByTag("gib_spawner_6")));
            }
            else if(sBossRef=="gib_boss_2")
            {
              int i;
              for(i=1;i<19;i++)
              {
               if(i>15)
               {
                 object oSpawn = ds_spawn_critter( oPC, "gibberling_brood", GetLocation( GetWaypointByTag("gib_spawner_"+IntToString(i))));
                 ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oSpawn,45.0);
                 ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eKD,oSpawn,45.0);
               }
               else
               {
                 object oSpawn = ds_spawn_critter( oPC, "gibberling_norml", GetLocation( GetWaypointByTag("gib_spawner_"+IntToString(i))));
                 ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oSpawn,45.0);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eKD,oSpawn,45.0);
               }
              }
                AssignCommand(oBoss,ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK,1.0,45.0));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oBoss,45.0);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eKD,oBoss,45.0);
            }
            else if(sBossRef=="gib_boss_3")
            {
              ds_spawn_critter( oPC, "gibberingmouther", GetLocation( GetWaypointByTag("gib_spawner_1")));
              ds_spawn_critter( oPC, "gibberling_norml", GetLocation( GetWaypointByTag("gib_spawner_2")));
              ds_spawn_critter( oPC, "gibberling_brood", GetLocation( GetWaypointByTag("gib_spawner_7")));
            }
          }

        }
        else
        {
            SendMessageToPC( oPC, "[Error: no boss resref]" );
        }
    }


    object oHench;
    int nMax = GetMaxHenchmen();
    string sTag;
    int i;
    int nHen;
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
        DelayCommand(0.5,AssignCommand(oHench, SpeakString( sMessage )));
        nHen=1;
        break;
      }
    }

    if(nHen==0)
    {
      DelayCommand(0.5,AssignCommand( oPC, SpeakString( "<c¥  >*" + sMessage2 + "*</c>" )));
    }

}
