////////////////////////////////////////////////////////////
// OnClick/OnAreaTransitionClick
// NW_G0_Transition.nss
// Copyright (c) 2001 Bioware Corp.
////////////////////////////////////////////////////////////
// Created By: Sydney Tang
// Created On: 2001-10-26
// Description: This is the default script that is called
//              if no OnClick script is specified for an
//              Area Transition Trigger or
//              if no OnAreaTransitionClick script is
//              specified for a Door that has a LinkedTo
//              Destination Type other than None.
////////////////////////////////////////////////////////////

//updated for intra-area transitions by Disco on Dec 21 2007
// 2009-11-28  disco added support for tight entries
// 2011-04-28  disco added missing OnEnter script detector

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void MoveAssociates( object oPC, object oTarget );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oClicker = GetClickingObject();
    object oTarget  = GetTransitionTarget( OBJECT_SELF );
    object oArea    = GetArea( OBJECT_SELF );

    //SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);

    //This area hasn't been marked by an OnEnter script!
    if ( GetLocalInt( oArea, "v_visit" ) != 1 ){

        WriteTimestampedLogEntry( "Without = "+GetName( oArea ) );

        int nModule  = GetLocalInt( GetModule(), "Module" );

        //add marker to db
        SQLExecDirect( "INSERT INTO area_no_isarea VALUES ( '"+
            SQLEncodeSpecialChars( GetName(oArea) )+"','"+IntToString( nModule )+"', 2 )" );

        if ( GetIsObjectValid( GetFirstObjectInAreaByTag( oArea, "is_area" ) ) == FALSE ){

            //somebody forgot to add is_area
            SQLExecDirect( "INSERT INTO area_no_isarea VALUES ( '"+
                SQLEncodeSpecialChars( GetName(oArea) )+"','"+IntToString( nModule )+"', 3 )" );
        }
    }

    if ( GetLocalInt( OBJECT_SELF, "tight" ) == 1 ){

        int nSize = GetCreatureSize( oClicker );

        if (  nSize != CREATURE_SIZE_SMALL && nSize != CREATURE_SIZE_TINY ){

            FloatingTextStringOnCreature( "This is a very tight opening. Only small or tiny creatures can pass it.", oClicker );
            return;
        }
    }

    if ( GetArea( oClicker ) == GetArea( oTarget ) && GetIsPC( oClicker ) ){

        MoveAssociates( oClicker, oTarget );
    }

    AssignCommand( oClicker, JumpToObject( oTarget ) );
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void MoveAssociates( object oPC, object oTarget ){

    int i;
    object oAssociate;

    for ( i=1; i<6; ++i ){

        oAssociate = GetAssociate( i, oPC );

        if ( GetIsObjectValid( oAssociate ) ){

            AssignCommand( oAssociate, JumpToObject( oTarget ) );
        }
    }
}



