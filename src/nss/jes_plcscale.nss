//jes_plcscale.nss
//Place this in OnHeartbeat of a PLC to scale an item and then clear the heartbeat event.

void main()
{
    object plc = OBJECT_SELF;
    float scale = GetLocalFloat(plc, "scale");

    SetObjectVisualTransform(plc, 10, scale);
    SetEventScript(plc, 3000, "");
}
