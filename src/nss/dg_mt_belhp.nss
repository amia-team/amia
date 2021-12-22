/*  dg_mt_belhp

    --------
    Verbatim
    --------
    Uses ds_actions_# to jump the player to the correct level depending on what
    they choose in the conversation.

    ---------
    Changelog
    ---------

    Date        Name        Reason
    ------------------------------------------------------------------
    032008      dg          Initial Release
    ------------------------------------------------------------------


*/

void main()
{

    //this script is only called with ExecuteScript,
    //so it has the PC as OBJECT_SELF
    object oPC      = OBJECT_SELF;

    //the nodes are set by the action scripts
    //at the start of a convo all nodes should be empty
    //you can do this by calling ds_actions_clean early in the convo
    int nNode       = GetLocalInt( oPC, "ds_node" );

    effect ePort    = EffectVisualEffect( VFX_IMP_SPELL_MANTLE_USE );

    object oWP;


    if( nNode == 1 ){

        oWP = GetWaypointByTag( "mt_floor2" );

        //Added the healing effect to look like the player is transporting
        ApplyEffectToObject( DURATION_TYPE_INSTANT, ePort, oPC );

        DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oWP, 0 ) ) );

    }

    if( nNode == 2 ){

        oWP = GetWaypointByTag( "mt_floor3" );

        //Added the healing effect to look like the player is transporting
        ApplyEffectToObject( DURATION_TYPE_INSTANT, ePort, oPC );

        DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oWP, 0 ) ) );

    }

    if( nNode == 3 ){

        oWP = GetWaypointByTag( "mt_floor4" );

        //Added the healing effect to look like the player is transporting
        ApplyEffectToObject( DURATION_TYPE_INSTANT, ePort, oPC );

        DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oWP, 0 ) ) );

    }

    if( nNode == 4 ){

        oWP = GetWaypointByTag( "mt_floor5" );

        //Added the healing effect to look like the player is transporting
        ApplyEffectToObject( DURATION_TYPE_INSTANT, ePort, oPC );

        DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oWP, 0 ) ) );

    }

    if( nNode == 5 ){

        oWP = GetWaypointByTag( "mt_floor6" );

        //Added the healing effect to look like the player is transporting
        ApplyEffectToObject( DURATION_TYPE_INSTANT, ePort, oPC );

        DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oWP, 0 ) ) );

    }

    if( nNode == 6 ){

        oWP = GetWaypointByTag( "mt_floor7" );

        //Added the healing effect to look like the player is transporting
        ApplyEffectToObject( DURATION_TYPE_INSTANT, ePort, oPC );

        DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oWP, 0 ) ) );

    }

    if( nNode == 7 ){

        oWP = GetWaypointByTag( "mt_floor8" );

        //Added the healing effect to look like the player is transporting
        ApplyEffectToObject( DURATION_TYPE_INSTANT, ePort, oPC );

        DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oWP, 0 ) ) );

    }

    if( nNode == 8 ){

        oWP = GetWaypointByTag( "mt_floor9" );

        //Added the healing effect to look like the player is transporting
        ApplyEffectToObject( DURATION_TYPE_INSTANT, ePort, oPC );

        DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oWP, 0 ) ) );

    }

    if( nNode == 9 ){

        oWP = GetWaypointByTag( "mt_floor10" );

        //Added the healing effect to look like the player is transporting
        ApplyEffectToObject( DURATION_TYPE_INSTANT, ePort, oPC );

        DelayCommand( 1.0, AssignCommand( oPC, JumpToObject( oWP, 0 ) ) );

    }

}
