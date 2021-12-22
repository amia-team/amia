void main(){


    //variables
    object oPC          = GetEnteringObject();
    object oArea        = GetArea(oPC);
    object oTarget;
    string sEnterTag    = GetTag(OBJECT_SELF);
    location lTarget;

    //Quit if the entering object isn't a PC
    if ( GetIsPC( oPC ) == FALSE ){ return; }

    if ( sEnterTag == "lightning" && d3() == 1 ){

        lTarget = GetLocation( GetNearestObjectByTag( "lightning_chain" ) );

        AssignCommand( oPC, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_LIGHTNING_M ), lTarget ));


    }

}
