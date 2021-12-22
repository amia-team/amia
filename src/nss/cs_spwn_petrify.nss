// onSpawn: Petrify Self (undispellable), set the creature to the Commoner faction, immortalize it
void main(){

    // vars
    object oCreature=OBJECT_SELF;

    // apply undispellable petrification to the creature when it spawns in
    ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        SupernaturalEffect( EffectVisualEffect( VFX_DUR_PROT_STONESKIN ) ),
        oCreature,
        0.0);

    /*
    ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        SupernaturalEffect( EffectVisualEffect( VFX_DUR_GLOW_LIGHT_YELLOW ) ),
        oCreature,
        0.0);
    */

    // set it to the Commoner faction (so that it doesn't appear hostile)
    DelayCommand(
        0.4,
        ChangeToStandardFaction(
            oCreature,
            STANDARD_FACTION_COMMONER));

    // invulnerable
    DelayCommand(
        0.5,
        SetPlotFlag(
            oCreature,
            TRUE));

    return;

}
