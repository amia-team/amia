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

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "nw_i0_plot"


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
    int nDamageType = GetLocalInt( OBJECT_SELF, "DamageType" );

    if ( !nDamageType ){

        nDamageType = DAMAGE_TYPE_BLUDGEONING;
    }

    string sMessageYes = GetLocalString( OBJECT_SELF, "MessageYes" );

    if ( sMessageYes == "" ){

        sMessageYes = "*climbs obstacle*";
    }

    string sMessageNo = GetLocalString( OBJECT_SELF, "MessageNo" );

    if ( sMessageNo == "" ){

        sMessageNo = "*climbs obstacle and twists ankle*";
    }

    if ( !ReflexSave( oClicker, GetLocalInt( OBJECT_SELF, "DC" ) ) ){

        effect eDamage = EffectDamage( d10(2), nDamageType );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oClicker );

        AssignCommand( oClicker, SpeakString( sMessageNo ) );
    }
    else{

        AssignCommand( oClicker, SpeakString( sMessageYes ) );
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
    object oArea = GetArea( oPC );

    for ( i=1; i<6; ++i ){

        oAssociate = GetAssociate( i, oPC );

        if ( GetIsObjectValid( oAssociate ) && oArea == GetArea( oAssociate ) ){

            AssignCommand( oAssociate, JumpToObject( oTarget ) );
        }
    }
}

