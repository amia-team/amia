/*
   Laser Puzzle Main Script
   - Mav, Feb 2025

*/

void LaserEngage(object oPLC);

void LaunchVFX(string sTag, string sTarget, object oTarget, int nBeamColor);

void CheckTargetDirection(float SourceFacing, object oTarget, object oSource);

void main()
{
  object oPLC = OBJECT_SELF;

  LaserEngage(oPLC);
}

void LaserEngage(object oPLC)
{

  string sTag = GetTag(oPLC);
  string sNorth = GetLocalString(oPLC,"north"); // 90
  string sNorthEast = GetLocalString(oPLC,"northeast"); // 45
  string sEast = GetLocalString(oPLC,"east");  // 0
  string sSouthEast = GetLocalString(oPLC,"southeast"); // 315
  string sSouth = GetLocalString(oPLC,"south"); // 270
  string sSouthWest = GetLocalString(oPLC,"southwest"); // 225
  string sWest = GetLocalString(oPLC,"west"); // 180
  string sNorthWest = GetLocalString(oPLC,"northwest"); // 135
  string sBeamTarget = GetLocalString(oPLC,"target");
  string sBounce = GetLocalString(oPLC,"bounce");
  int nHasBeam = GetLocalInt(oPLC,"active");
  int nHasMirrow = GetLocalInt(oPLC,"hasmirror");
  int nBeamColor = GetLocalInt(oPLC,"beamcolor");


  if((nHasBeam != 1) || (nHasMirrow != 1))
  {
    return;
  }

  float fFacing = GetFacing(oPLC);
  float fAdjustmenet = GetLocalFloat(oPLC,"adjustment"); // 180 in this instance
  float fTrueFacing = fFacing + fAdjustmenet;

  if(fTrueFacing >= 360.0)
  {
    fTrueFacing = fTrueFacing - 360.0;
  }

  object oPLCTarget;

  if(sBounce != "") // Catch for bounce only objects
  {
    oPLCTarget = GetObjectByTag(sBounce);
  }
  else if(fTrueFacing == 0.0)
  {
    oPLCTarget = GetObjectByTag(sEast);
  }
  else if(fTrueFacing == 45.0)
  {
    oPLCTarget = GetObjectByTag(sNorthEast);
  }
  else if(fTrueFacing == 90.0)
  {
    oPLCTarget = GetObjectByTag(sNorth);
  }
  else if(fTrueFacing == 135.0)
  {
    oPLCTarget = GetObjectByTag(sNorthWest);
  }
  else if(fTrueFacing == 180.0)
  {
    oPLCTarget = GetObjectByTag(sWest);
  }
  else if(fTrueFacing == 225.0)
  {
    oPLCTarget = GetObjectByTag(sSouthWest);
  }
  else if(fTrueFacing == 270.0)
  {
    oPLCTarget = GetObjectByTag(sSouth);
  }
  else if(fTrueFacing == 315.0)
  {
    oPLCTarget = GetObjectByTag(sSouthEast);
  }

  if(GetIsObjectValid(oPLCTarget))
  {


    if((GetLocalString(oPLCTarget,"source")==""))
    {
     AssignCommand(oPLC,LaunchVFX(sTag,GetTag(oPLCTarget),oPLCTarget,nBeamColor));
     CheckTargetDirection(fTrueFacing,oPLCTarget,oPLC);
     if(GetLocalInt(oPLC,"shutdown")==1)
     {
      DeleteLocalInt(oPLC,"shutdown");
      AssignCommand(oPLC,SpeakString("<c ¿ >**The device crackles back to life and the beam reactives**</c>"));
     }
    }
    else if(GetLocalInt(oPLC,"shutdown")!=1)
    {
     SetLocalInt(oPLC,"shutdown",1);
     AssignCommand(oPLC,SpeakString("<c ¿ >**The device crackles and the beam is shut down momentarily. It appears some safety measure was enacted**</c>"));
    }
  }
}


void LaunchVFX(string sTag, string sTarget, object oTarget, int nBeamColor)
{
  if(nBeamColor==0)
  {
    nBeamColor = VFX_BEAM_FIRE;
  }

  effect eVis = EffectVisualEffect(nBeamColor);
  eVis = UnyieldingEffect(eVis);
  eVis = TagEffect(eVis,"lp"+sTag+sTarget);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
}

void CheckTargetDirection(float SourceFacing, object oTarget, object oSource)
{
  float fFacing = GetFacing(oTarget);
  float fAdjustmenet = GetLocalFloat(oTarget,"adjustment");
  string sBounce = GetLocalString(oTarget,"bounce");

  float fTrueFacingTarget = fFacing + fAdjustmenet;

  if(fTrueFacingTarget >= 360.0)
  {
    fTrueFacingTarget = fTrueFacingTarget - 360.0;
  }

  SetLocalString(oSource,"target",GetTag(oTarget));
  if(GetLocalString(oTarget,"source") == "")
  {
   SetLocalString(oTarget,"source",GetTag(oSource));
  }

  if(sBounce != "") // Catch for bounce only objects
  {
   SetLocalInt(oTarget,"active",1);
   LaserEngage(oTarget);
  }
  else if((SourceFacing == 0.0) && ((fTrueFacingTarget==135.0) || (fTrueFacingTarget==225.0) || (fTrueFacingTarget==90.0) || (fTrueFacingTarget==270.0)))
  {
   SetLocalInt(oTarget,"active",1);
   LaserEngage(oTarget);
  }
  else if((SourceFacing == 45.0) && ((fTrueFacingTarget==135.0) || (fTrueFacingTarget==180.0) || (fTrueFacingTarget==270.0) || (fTrueFacingTarget==315.0)))
  {
   SetLocalInt(oTarget,"active",1);
   LaserEngage(oTarget);
  }
  else if((SourceFacing == 90.0) && ((fTrueFacingTarget==0.0) || (fTrueFacingTarget==315.0)|| (fTrueFacingTarget==225.0) || (fTrueFacingTarget==180.0)))
  {
   SetLocalInt(oTarget,"active",1);
   LaserEngage(oTarget);
  }
  else if((SourceFacing == 135.0) && ((fTrueFacingTarget==45.0) || (fTrueFacingTarget==0.0)|| (fTrueFacingTarget==270.0) || (fTrueFacingTarget==225.0)))
  {
   SetLocalInt(oTarget,"active",1);
   LaserEngage(oTarget);
  }
  else if((SourceFacing == 180.0) && ((fTrueFacingTarget==270.0) || (fTrueFacingTarget==315.0) || (fTrueFacingTarget==45.0) || (fTrueFacingTarget==90.0)))
  {
   SetLocalInt(oTarget,"active",1);
   LaserEngage(oTarget);
  }
  else if((SourceFacing == 225.0) && ((fTrueFacingTarget==135.0) || (fTrueFacingTarget==90.0) || (fTrueFacingTarget==0.0) || (fTrueFacingTarget==315.0)))
  {
   SetLocalInt(oTarget,"active",1);
   LaserEngage(oTarget);
  }
  else if((SourceFacing == 270.0) && ((fTrueFacingTarget==0.0) || (fTrueFacingTarget==45.0) || (fTrueFacingTarget==135.0) || (fTrueFacingTarget==180.0)))
  {
   SetLocalInt(oTarget,"active",1);
   LaserEngage(oTarget);
  }
  else if((SourceFacing == 315.0) && ((fTrueFacingTarget==45.0) || (fTrueFacingTarget==90.0) || (fTrueFacingTarget==180.0) || (fTrueFacingTarget==225.0)))
  {
   SetLocalInt(oTarget,"active",1);
   LaserEngage(oTarget);
  }


  if((GetLocalInt(oTarget,"end")==1) && (GetLocalInt(oTarget,"active")==1)) // Hit the end
  {
    AssignCommand(oTarget,SpeakString("<c ¿ >**As the beam connects there is an audible click that echoes out loud and the puzzle locks**</c>"));
    string sID = GetLocalString(oTarget,"puzzleid");
    SetLocalInt(GetArea(oTarget),sID+"locked",1);
    SetLocalInt(GetArea(oTarget),sID,1);
  }


}
