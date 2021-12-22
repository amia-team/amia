////////////////////////////////////////////////////////////////
// Circle of Balance     Druid Grove System (MagnumMan         )
// Copyright (C) 2004 by James E. King, III (jking@prospeed.net)
//                       Valdor Dormanigon  (Archdruid         )
////////////////////////////////////////////////////////////////
//
// When players exit the grove:
//
// 1. Remove the hallowing effect if it is present.
// 2. Destroy any visitor bark in their inventory.
//
////////////////////////////////////////////////////////////////

#include "area_constants"
//#include "mir_grove_util"

void main()
{
    object oExiting = GetExitingObject();

    if( GetIsPossessedFamiliar( oExiting ) ){

        UnpossessFamiliar( oExiting );
        return;
    }

    AreaHandleOnExitEventDefault(OBJECT_SELF);


}
