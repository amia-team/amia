//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  innocent_death
//group:   ds_ai
//used as: OnDeath
//date:    dec 23 2007
//author:  Jes


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_ondeath"
#include "ds_ai2_include"

void ActionCreateCreature(string resref, location l);

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------



void main(){

    object oCritter         = OBJECT_SELF;
    object oKiller          = GetLastKiller();
    location deadSpot       = GetLocation(OBJECT_SELF);
    string innocent         = GetResRef(oCritter);

    SetIsDestroyable(FALSE, FALSE);

    //OnDeath custom ability usage
    string sDE = GetLocalString( oCritter, "DeathEffect" );
    if( sDE != "" )
    {
        SetLocalObject( oCritter, sDE, oKiller );
        ExecuteScript( sDE, oCritter );
    }

    if( oKiller != OBJECT_SELF && GetLocalInt( oCritter, L_ISDEAD ) != 1 ){

        // Set have died once, stops giving out multiple amounts of XP.
        SetLocalInt( oCritter, L_ISDEAD, 1 );

        // Reward XP.
        int nXPResult = RewardXPForKill( );

        // Generate treasure.
        GenerateLoot( oCritter, nXPResult );
        if(GetLocalInt(oCritter,"Heart") == 1) {
            CreateItemOnObject("bleedheart",oKiller,1,"");
        }



     DelayCommand(599.0f, ActionCreateCreature(innocent, deadSpot));
     DelayCommand(600.0f, SetIsDestroyable(TRUE, FALSE));
     DelayCommand(600.99f, DestroyObject(OBJECT_SELF));
    }
}

void ActionCreateCreature(string resref, location l)
{
   CreateObject(OBJECT_TYPE_CREATURE, resref, l);
}
