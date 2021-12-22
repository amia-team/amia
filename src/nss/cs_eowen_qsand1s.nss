// Eowen's Quicksand: slip down into the secret minotaur caves~!
void main(){

    // vars
    object oPC  = GetLastUsedBy();

    if ( GetIsPC( oPC ) == FALSE ){

        return;
    }

    if ( GetIsInCombat( oPC ) ){

        SendMessageToPC( oPC, "You can't use this object when you are in combat." );
        return;
    }

    location lDest=GetLocation(GetWaypointByTag("wp_eowen_mcaves1"));

    // sinking vfx
    ApplyEffectToObject(  DURATION_TYPE_TEMPORARY, EffectLinkEffects( EffectCutsceneParalyze(), EffectVisualEffect(VFX_DUR_PARALYZE_HOLD)), oPC, 5.0);

    // sound anim
    DelayCommand( 1.0, AssignCommand( oPC, PlaySound( "al_na_sludggrat1" ) ) );

    // warn the player
    DelayCommand( 1.0, FloatingTextStringOnCreature( "You enter the mud pool, and quickly sink down...", oPC, FALSE));

    // teleport them to the secret minotaur caves!
    DelayCommand( 6.0, AssignCommand( oPC, JumpToLocation(lDest)));

    return;

}
