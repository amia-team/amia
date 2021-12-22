#include "nwnx"
#include "nwnx_funcs"
#include "nwnx_admin"
#include "inc_runtime_api"
#include "inc_module_vars"

//take away polymorphs
void RemovePolymorph(object oPC);
int TimeToReset();

void main()
{
   if(!TimeToReset())
   {
       DelayCommand(300.0f, ExecuteScript("amia_reset"));
       return;
   }
   object oPCs = GetFirstPC();
   object oModule = GetModule();
   string sMessage = "- Amia is closing down. Don't try to login until it is up again because you will be booted. -";

   //block new players
   SetLocalInt( oModule, "ds_closing", 1 );

   while(GetIsObjectValid(oPCs))
   {
     UnpossessFamiliar(oPCs);
     SendMessageToPC(oPCs,sMessage);
     RemovePolymorph(oPCs);
     DelayCommand(15.0,BootPC(oPCs,"Server Reset"));

     oPCs = GetNextPC();
   }
   DelayCommand(35.0,NWNX_Administration_ShutdownServer());
}

int TimeToReset()
{
    WriteTimestampedLogEntry("Time to reset " + IntToString(GetRunTime() - GetStartTime()));

    return GetRunTime() - GetStartTime() >= GetAutoReload();
}


void RemovePolymorph(object oPC)
{
   effect eLoop = GetFirstEffect( oPC );

   while ( GetIsEffectValid( eLoop ) )
   {
      if ( GetEffectType( eLoop ) == EFFECT_TYPE_POLYMORPH )
      {
        RemoveEffect( oPC, eLoop );
      }

      eLoop = GetNextEffect(oPC);
    }
}
