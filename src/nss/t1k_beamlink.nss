//::///////////////////////////////////////////////
//:: Beam VFX Link
//:: t1k_beamlink
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: 01/21/2022
//:://////////////////////////////////////////////

// Explanation:
// This script is used to create a linked chain of permanent beams between
// several objects. In order to use, several nodes are required.
// The nodes should each have the tag "beamchain_" with a number after it,
// starting with 0. This will describe the sequence in the chain.
// The first link (beamchain_0) can also have some settings:
// A local int "beamtype" to set the type of beam. If this is not implemented
// It will use the lightning beam.
// A local int "circlebeam" which if set to 1, will have the last node and the
// first form a beam.
// Finally, there's also one for if the beam is active. This will effectively
// mean that if it's already active, the script will not do anything.
// Recommended to start the beams via a trigger with an OnEnter, but other
// methods are possible.

string BEAM_LINK = "beamchain_";
string BEAM_TYPE = "beamtype";
string BEAM_ACTIVE = "beam_active";
string BEAM_CIRCLE = "circlebeam";

void makeBeam(object otarget1, object otarget2, int iBeam=VFX_BEAM_LIGHTNING) {
    effect eBeam = EffectBeam(iBeam,otarget1,BODY_NODE_CHEST);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
    eBeam,
    otarget2);
}

object GetObjectByTagAndArea(object oArea, string sTag) {
    int iteration = 0;
    object oRet = GetObjectByTag(sTag,iteration);
    while ((oArea != GetArea(oRet)) && oRet != OBJECT_INVALID) {
        iteration = iteration + 1;
        oRet = GetObjectByTag(sTag,iteration);
    }
    return oRet;
}

void makeLinks() {

    int incr = 0;
    object oMyArea = GetArea(OBJECT_SELF);

    object oFirst = GetObjectByTagAndArea(oMyArea,BEAM_LINK + IntToString(incr));

    int iActiveCheck = GetLocalInt(oFirst,BEAM_ACTIVE);
    if (iActiveCheck != FALSE) {
        return;
    }
    int iBeam = GetLocalInt(oFirst,BEAM_TYPE);
    if (iBeam == 0) {
        iBeam = VFX_BEAM_LIGHTNING;
    }

    int iCircle = GetLocalInt(oFirst,BEAM_CIRCLE);

    object oTarget = GetObjectByTagAndArea(oMyArea,BEAM_LINK + IntToString(incr+1));
    while (oTarget != OBJECT_INVALID) {
        DelayCommand(IntToFloat(incr+1),makeBeam(oFirst, oTarget, iBeam));
        incr = incr + 1;
        oFirst = GetObjectByTagAndArea(oMyArea,BEAM_LINK + IntToString(incr));
        oTarget = GetObjectByTagAndArea(oMyArea,BEAM_LINK + IntToString(incr+1));
    }
    if (iCircle != 0) {
        oTarget = oFirst;
        oFirst = GetObjectByTagAndArea(oMyArea,BEAM_LINK + IntToString(0));
        makeBeam(oFirst, oTarget, iBeam);
    }

    SetLocalInt(oFirst,BEAM_ACTIVE,TRUE);
}

void main()
{
    makeLinks();
}