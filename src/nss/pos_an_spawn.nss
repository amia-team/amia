//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai_spawn
//group:   ds_ai
//used as: OnSpawn
//date:    dec 23 2007
//author:  disco(Updated by Anatida)

//  20071119  disco       Moved cleanup scripts to amia_include
//  20150427  Anatida  Added ability to summon Posse

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oCritter = OBJECT_SELF;

    int nEffect1     = GetLocalInt( oCritter, "effect1" );
    int nEffect2     = GetLocalInt( oCritter, "effect2" );

    if ( nEffect1 ){

        effect eEffect1  = EffectVisualEffect( nEffect1 );
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eEffect1, oCritter ) );
    }

    if ( nEffect2 ){

        effect eEffect2  = EffectVisualEffect( nEffect2 );
        DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eEffect2, oCritter ) );
    }


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

    while( GetIsItemPropertyValid( IP ) )
    {

        if( GetItemPropertyType( IP ) == ITEM_PROPERTY_TRUE_SEEING )
        {

            effect eTS = SupernaturalEffect( EffectTrueSeeing() );

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eTS, oCritter );

            return;
        }

        IP = GetNextItemProperty( oHide );
    }

//
    object oPC = GetLastPerceived();
    string sSummon1 = GetLocalString(OBJECT_SELF, "SummonResRef1"); //Get the variable to ID summon
    string sSummon2 = GetLocalString(OBJECT_SELF, "SummonResRef2");
    int nDice = GetLocalInt( OBJECT_SELF, "SummonDice" );  //Get the # of d6 dice to calculate spawns
    location lMyLocation = GetLocation(OBJECT_SELF);
    vector vMyVector = GetPosition(OBJECT_SELF);
    object oSummon;
    int iNumberOfCreatures = (d6(nDice)); //caluclate number of creatures to spawn
    int nSphereSize = Random(20); // create a random sphere size to spawn in

        //Count the number of creatures
        int iCount = 0;
        //While we still have items to create
        while(iCount < iNumberOfCreatures)
        {
            //Spread the suckers around - Create a new vector object
                vector vNewVector = vMyVector;
                 //Create some offsets based on the sphere size
                int xOffSet = Random(nSphereSize);
                int yOffSet = Random(nSphereSize);
                //Make the offset negative, randomly
                    if(Random(2) == 1)
                    {
                        xOffSet = xOffSet * -1;
                    }
                    //Make the offset negative, randomly
                    if(Random(2) == 1)
                    {
                    yOffSet = yOffSet * -1;
                    }
                //Add the offsets to the vector
                vNewVector.x = vNewVector.x + xOffSet;
                vNewVector.y = vNewVector.y + yOffSet;
                //Create a new location, based on the off set vector
                location lNewLocation = Location(GetAreaFromLocation(lMyLocation), vNewVector, 0.0);
                //Create a creature using one of the summon ResRef variables
                int nType = Random(2)+1;
                if(nType == 1)
                {
                CreateObject(OBJECT_TYPE_CREATURE, sSummon1, lNewLocation, FALSE);
                }
                else if(nType == 2)
                {
                CreateObject(OBJECT_TYPE_CREATURE, sSummon2, lNewLocation, FALSE);
                }
            //Increase the count
            iCount = iCount + 1;
        }
}
