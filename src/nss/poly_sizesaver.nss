void main()
{
    object oPC           = OBJECT_SELF;
    float fPolySizePre   = GetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE);
    object oPCKey        = GetItemPossessedBy(oPC, "ds_pckey");

    SetLocalFloat(oPCKey, "presize", fPolySizePre);
}
