//jes_plcscale.nss
//Place this in OnHeartbeat of a PLC to scale an item and then clear the heartbeat event.

void main()
{
    object plc    = OBJECT_SELF;
    float scale   = GetLocalFloat(plc, "scale");
    //scaleType is from OBJECT_VISUAL_TRANSFORM_*
    int scaleType = GetLocalInt(plc, "scale_type");

    if(scaleType != 0){
        if(scaleType = 40){
            scaleType = OBJECT_VISUAL_TRANSFORM_ANIMATION_SPEED;
            SetObjectVisualTransform(plc, scaleType, scale);
            SetEventScript(plc, 9004, " ");
        }
    }
    else{
        //Default scale type is OBJECT_VISUAL_TRANSFORM_SCALE
        SetObjectVisualTransform(plc, 10, scale);
        SetEventScript(plc, 9004, "");
    }
}
