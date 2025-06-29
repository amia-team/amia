#include "nwnx_magic"

void main( ){

    object oPC = OBJECT_SELF;
    int ShifterID = GetLocalInt( OBJECT_SELF, "LAST_POLY_ID");
    float fPolySizePre   = GetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE);
    object oPCKey        = GetItemPossessedBy(oPC, "ds_pckey");

    // Code to check and remove Cav bonuses if they polymorph
    object oWidget = GetItemPossessedBy(oPC, "r_mountwidget");
    int mounted = GetLocalInt(oWidget,"mounted");
    if(mounted==1)
    {
     effect eLoop = GetFirstEffect(oPC);
     while(GetIsEffectValid(eLoop))
     {
       int nLoopSpellID = GetEffectSpellId(eLoop);

            if ((nLoopSpellID == 945))
            {
              RemoveEffect(oPC, eLoop);
              SendMessageToPC(oPC,"As you polymorph your mount takes off!");
            }

        eLoop=GetNextEffect(oPC);
      }
     }
    
    SetLocalFloat(oPCKey, "presize", fPolySizePre);
}

