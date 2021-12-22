/* Bracers of Create Iron Wall
    -   creates an iron wall around a target creature
*/

// includes
#include "x2_inc_switches"
#include "x0_i0_position"

void main(){

    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:{

            // vars
            object oVictim = GetItemActivatedTarget();
            object oPC     = GetItemActivator();

            // sound anim
            AssignCommand( oPC, PlaySound("as_dr_x2ttu10cl") );

            // resolve target status
            if( oVictim==OBJECT_INVALID || GetObjectType(oVictim)!=OBJECT_TYPE_CREATURE  ){

                FloatingTextStringOnCreature( "This wand may only be targetted at a creature!", oPC, FALSE);
                break;

            }

            if( GetObjectByTag( "ds_cage_1" ) != OBJECT_INVALID  ){

                FloatingTextStringOnCreature( "Cage removed!", oPC, FALSE);
                DestroyObject( GetObjectByTag( "ds_cage_1" ), 0.2 );
                DestroyObject( GetObjectByTag( "ds_cage_2" ), 0.4 );
                DestroyObject( GetObjectByTag( "ds_cage_3" ), 0.6 );
                DestroyObject( GetObjectByTag( "ds_cage_4" ), 0.8 );

                break;
            }


            // resolve cage wall status: facing, position
            object oArea        = GetArea(oVictim);
            vector vOriginPos   = GetPosition(oVictim);
            float fOriginFacing = GetFacing(oVictim);


            float fFrontX         = vOriginPos.x + 1.0;
            float fFrontY         = vOriginPos.y + 0.0;
            vector vFrontPosition = Vector( fFrontX, fFrontY, vOriginPos.z);

            float fLeftX          = vOriginPos.x + 0.0;
            float fLeftY          = vOriginPos.y + 1.0;
            vector vLeftPosition  = Vector( fLeftX, fLeftY, vOriginPos.z);

            float fRightX         = vOriginPos.x -0.0;
            float fRightY         = vOriginPos.y -1.0;
            vector vRightPosition = Vector( fRightX, fRightY, vOriginPos.z);

            float fBackX          = vOriginPos.x -1.0;
            float fBackY          = vOriginPos.y -0.0;
            vector vBackPosition  = Vector( fBackX, fBackY, vOriginPos.z);

            location lFront = Location( oArea, vFrontPosition,  0.0 );
            location lLeft  = Location( oArea, vLeftPosition,  90.0  );
            location lRight = Location( oArea, vRightPosition,  270.0 );
            location lBack  = Location( oArea, vBackPosition,  180.0  );


            // spawn cage walls
            CreateObject( OBJECT_TYPE_PLACEABLE, "x0_cagewall", lFront, FALSE, "ds_cage_1" );
            CreateObject( OBJECT_TYPE_PLACEABLE, "x0_cagewall", lLeft,  FALSE, "ds_cage_2" );
            CreateObject( OBJECT_TYPE_PLACEABLE, "x0_cagewall", lRight, FALSE, "ds_cage_3" );
            CreateObject( OBJECT_TYPE_PLACEABLE, "x0_cagewall", lBack,  FALSE, "ds_cage_4" );



            break;
        }
        default:{
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
