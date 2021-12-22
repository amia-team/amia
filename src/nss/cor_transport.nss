/*
cor_transport

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
Assign this script to the OnUse tab in a PLC or OnEnter in a trigger

naming your mirrors, triggers and waypoints
 * Each PLC should have a tag like "cor_endmirror"
 * Each trigger should have the name "Trigger" and a tag like "cor_pass_good"
 * Each destination waypoint should have a tag like "wp_cor_endmirror" or "wp_cor_pass_good"
 * Death waypoint should be called "wp_cor_death"

trigger options: cor_pass_good, cor_pass_neutral, cor_pass_evil

I kept lines open in the alignment pass script for future additions

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
04-29-2006      disco      Start of header
04-29-2006      disco      Made universal so Nekh can use it as well
------------------------------------------------
*/


//functions prototypes
void kill_PC(object oPC);

//main
void main(){

    //variables
    object oPC;
    object oDestination;

    string sTriggerName=GetName(OBJECT_SELF);
    string sTriggerTag=GetTag(OBJECT_SELF);
    string sDestinationTag="wp_"+sTriggerTag;

    if(sTriggerName == "Trigger"){

        //pass or transportation to waypoint "wp_cor_death"
        oPC=GetEnteringObject();
        int nGoodEvil=GetAlignmentGoodEvil(oPC);

        if (nGoodEvil==ALIGNMENT_GOOD && sTriggerTag == "cor_pass_good"){
            //let the PC pass and maybe do something later
        }
        else if (nGoodEvil==ALIGNMENT_NEUTRAL && sTriggerTag == "cor_pass_neutral"){
            //let the PC pass and maybe do something later
        }
        else if (nGoodEvil==ALIGNMENT_EVIL && sTriggerTag == "cor_pass_evil"){
            //let the PC pass and maybe do something later
        }
        else{
            oDestination=GetObjectByTag("wp_cor_death");
            AssignCommand(oPC,ActionJumpToObject(oDestination,FALSE));
            DelayCommand(2.0,kill_PC(oPC));
        }
    }
    else{
        //OnUse transportation to waypoint "wp_"+GetTag(OBJECT_SELF)
        oPC=GetLastUsedBy();
        oDestination=GetObjectByTag(sDestinationTag);
        AssignCommand(oPC,ActionJumpToObject(oDestination,FALSE));
    }
}


//functions
void kill_PC(object oPC){

    // Create the effect to apply
    effect eDeath = EffectDeath();

    // Create the visual portion of the effect. This is instantly
    // applied and not persistant with wether or not we have the
    // above effect.
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);

    // Apply the visual effect to the target
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    // Apply the effect to the object
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC);

}
