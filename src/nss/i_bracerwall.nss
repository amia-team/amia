/* Bracers of Create Iron Wall
    -   creates an iron wall around a target creature
*/

// includes
#include "x2_inc_switches"

void main(){

    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:{

            // vars
            object oVictim=GetItemActivatedTarget();
            object oPC=GetItemActivator();

            // sound anim
            AssignCommand(
                oPC,
                PlaySound("as_dr_x2ttu10cl"));

            // resolve target status
            if( (oVictim==OBJECT_INVALID)                       ||
                (GetObjectType(oVictim)!=OBJECT_TYPE_CREATURE)  ){

                FloatingTextStringOnCreature(
                    "- This wand may only be targetted at a creature! -",
                    oPC,
                    FALSE);

                break;

            }

            // resolve cage wall status: facing, position
            object oArea=GetArea(oVictim);

            vector vOriginPos=GetPosition(oVictim);

            float fOriginFacing=GetFacing(oVictim);

            float fFrontFacing=fOriginFacing+180.0;
            float fFrontX=vOriginPos.x+1.0*cos(fFrontFacing);
            float fFrontY=vOriginPos.y+1.0*sin(fFrontFacing);
            vector vFrontPosition=Vector(
                fFrontX,
                fFrontY);

            float fLeftFacing=fOriginFacing-90.0;
            float fLeftX=vOriginPos.x+1.0*cos(fLeftFacing);
            float fLeftY=vOriginPos.y+1.0*sin(fLeftFacing);
            vector vLeftPosition=Vector(
                fLeftX,
                fLeftY);

            float fRightFacing=fOriginFacing+90.0;
            float fRightX=vOriginPos.x+1.0*cos(fRightFacing);
            float fRightY=vOriginPos.y+1.0*sin(fRightFacing);
            vector vRightPosition=Vector(
                fRightX,
                fRightY);

            float fBackFacing=fOriginFacing;
            float fBackX=vOriginPos.x+1.0*cos(fBackFacing);
            float fBackY=vOriginPos.y+1.0*sin(fBackFacing);
            vector vBackPosition=Vector(
                fBackX,
                fBackY);

            location lFront=Location(
                oArea,
                vFrontPosition,
                fFrontFacing);

            location lLeft=Location(
                oArea,
                vLeftPosition,
                fLeftFacing);

            location lRight=Location(
                oArea,
                vRightPosition,
                fRightFacing);

            location lBack=Location(
                oArea,
                vBackPosition,
                fBackFacing);

            // spawn cage walls
            CreateObject(
                OBJECT_TYPE_PLACEABLE,
                "cs_plc_iwall1",
                lFront,
                FALSE);

            CreateObject(
                OBJECT_TYPE_PLACEABLE,
                "cs_plc_iwall1",
                lLeft,
                FALSE);

            CreateObject(
                OBJECT_TYPE_PLACEABLE,
                "cs_plc_iwall1",
                lRight,
                FALSE);

            CreateObject(
                OBJECT_TYPE_PLACEABLE,
                "cs_plc_iwall1",
                lBack,
                FALSE);

            break;
        }
        default:{
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
