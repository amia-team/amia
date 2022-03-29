// Same script as ds_ai2_spawn but with added special loot stuff for hunter big game mobs

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void spawnJobSystemItems(object oCritter);

void main(){

    object oCritter = OBJECT_SELF;

    spawnJobSystemItems(oCritter);

    DelayCommand( SPAWNBUFFDELAY, OnSpawnRoutines( oCritter ) );

    CreateMySpellLists( oCritter );

    SetLocalString( oCritter, "ai", "ds_ai2" );

    //silent communication
    SetListening( OBJECT_SELF, TRUE );
    SetListenPattern( OBJECT_SELF, M_ATTACKED, 1001 );

    //set TS on self if it's on the hide.
    //you can't detect hide properties like effects
    object oHide = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oCritter );

    itemproperty IP = GetFirstItemProperty( oHide );

    while( GetIsItemPropertyValid( IP ) ){

        if( GetItemPropertyType( IP ) == ITEM_PROPERTY_TRUE_SEEING ) {

            effect eTS = SupernaturalEffect( EffectTrueSeeing() );

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eTS, oCritter );

            return;
        }

        IP = GetNextItemProperty( oHide );
    }
}

void spawnJobSystemItems(object oCritter)
{
   string sBone = GetLocalString(oCritter,"bone");
   string sHide = GetLocalString(oCritter,"hide");
   string sFur = GetLocalString(oCritter,"fur");
   string sMeat = GetLocalString(oCritter,"meat");
   string sVenom = GetLocalString(oCritter,"venom");
   string sSpecial1 = GetLocalString(oCritter,"special1");
   string sSpecial2 = GetLocalString(oCritter,"special2");
   string sSpecial3 = GetLocalString(oCritter,"special3");

   int nMaxSpawn;
   int nRandom1 = Random(10);
   int nRandom2 = Random(10);
   int nRandom3 = Random(10);

   if(sBone != "")
   {
      if(Random(10) <= 7)
      {
         object bTemp = CreateItemOnObject(sBone,oCritter);
         SetDroppableFlag(bTemp,TRUE);
      }
   }

   if(sHide != "")
   {
      if(Random(10) <= 7)
      {
         object hTemp = CreateItemOnObject(sHide,oCritter);
         SetDroppableFlag(hTemp,TRUE);
      }
   }

   if(sFur != "")
   {
      if(Random(10) <= 7)
      {
         object fTemp = CreateItemOnObject(sFur,oCritter);
         SetDroppableFlag(fTemp,TRUE);
      }
   }

   if(sMeat != "")
   {
      if(Random(10) <= 7)
      {
         object mTemp = CreateItemOnObject(sMeat,oCritter);
         SetDroppableFlag(mTemp,TRUE);
      }
   }

   if(sVenom != "")
   {
      if(Random(10) <= 7)
      {
         object vTemp = CreateItemOnObject(sVenom,oCritter);
         SetDroppableFlag(vTemp,TRUE);
      }
   }

   if(sSpecial1 != "")
   {
      if(Random(10) <= 7)
      {
         object s1Temp = CreateItemOnObject(sSpecial1,oCritter);
         SetDroppableFlag(s1Temp,TRUE);
      }
   }

   if(sSpecial2 != "")
   {
      if(Random(10) <= 7)
      {
         object s2Temp = CreateItemOnObject(sSpecial2,oCritter);
         SetDroppableFlag(s2Temp,TRUE);
      }
   }

   if(sSpecial3 != "")
   {
      if(Random(10) <= 7)
      {
         object s3Temp = CreateItemOnObject(sSpecial3,oCritter);
         SetDroppableFlag(s3Temp,TRUE);
      }
   }


}

