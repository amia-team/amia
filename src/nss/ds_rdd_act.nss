//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: s_rdd-Act
//group: rdd customisers
//used as: convo action script
//date:     2009-02-28
//author:   disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"
#include "cs_inc_leto"
#include "nwnx_creature"



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC       = OBJECT_SELF;
    object oTarget   = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    object oWidget   = GetItemPossessedBy(oTarget, "ds_pckey");
    object oHide;
    int nWing        = CREATURE_WING_TYPE_DRAGON;

    if ( nNode < 1 ){

        return;
    }
    else {

        if ( nNode == 40 ){

            //reset: clean up variables
            DeleteLocalInt( oWidget, "ds_RDD" );

            DeleteLocalInt( oTarget, "ds_RDD" );

            FloatingTextStringOnCreature( "Custom RDD settings removed!", oTarget );
        }
        else{

            SetLocalInt( oWidget, "ds_RDD", nNode );

            SetLocalInt( oTarget, "ds_RDD", nNode );

            switch ( nNode ) {

                case 1:  nWing = 65;
                         NWNX_Creature_AddFeat(oTarget, 1214);
                         break; //black

                case 2:  nWing = 67;
                         NWNX_Creature_AddFeat(oTarget, 1215);
                         break; //blue

                case 3:  nWing = 59;
                         NWNX_Creature_AddFeat(oTarget, 1210);
                         break; //brass

                case 4:  nWing = 60;
                         NWNX_Creature_AddFeat(oTarget, 1215);
                         break; //bronze

                case 5:  nWing = 61;
                         NWNX_Creature_AddFeat(oTarget, 1214);
                         break; //copper

                case 6:  nWing = 63;
                         NWNX_Creature_AddFeat(oTarget, 1210);
                         break; //gold

                case 7:  nWing = 66;
                         NWNX_Creature_AddFeat(oTarget, 1213);
                         break; //green

                case 8:  nWing = 68;
                         NWNX_Creature_AddFeat(oTarget, 1210);
                         break; //red

                case 9:  nWing = 62;
                         NWNX_Creature_AddFeat(oTarget, 1211);
                         break; //silver

                case 10: nWing = 64;
                         NWNX_Creature_AddFeat(oTarget, 1211);
                         break; //white

                case 11: nWing = 75;
                         NWNX_Creature_AddFeat(oTarget, 1212);
                         break; //shadow
            }
        }

        //set wing type
        if ( GetCreatureWingType( oTarget ) > 0 ){

            SetCreatureWingType( nWing, oTarget );
        }

        // Remove their previous breath weapon feat
        if( GetHasFeat( 965, oTarget ) == 1 ) {
            NWNX_Creature_RemoveFeat(oTarget,965);
        }
        else if( GetHasFeat( 1210, oTarget ) == 1 ) {
            NWNX_Creature_RemoveFeat(oTarget,1210);
        }
        else if( GetHasFeat( 1211, oTarget ) == 1 ) {
            NWNX_Creature_RemoveFeat(oTarget,1211);
        }
        else if( GetHasFeat( 1212, oTarget ) == 1 ) {
            NWNX_Creature_RemoveFeat(oTarget,1212);
        }
        else if( GetHasFeat( 1213, oTarget ) == 1 ) {
            NWNX_Creature_RemoveFeat(oTarget,1213);
        }
        else if( GetHasFeat( 1214, oTarget ) == 1 ) {
            NWNX_Creature_RemoveFeat(oTarget,1214);
        }
        else if( GetHasFeat( 1215, oTarget ) == 1 ) {
            NWNX_Creature_RemoveFeat(oTarget,1215);
        }
        else {
            return; // they don't have RDD breath yet, no need to use this widget
        }

        // Save and modify PC.
        ExportSingleCharacter( oTarget );
        BootPC(oTarget,"You are being booted to have your breath feat added!");
        FloatingTextStringOnCreature( "You are being booted to have your breath feat added!", oTarget );
    }
}
