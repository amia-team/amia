void main(){
    if(GetLocalInt(OBJECT_SELF,"block")==0){
        effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
        DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF,10.0));
        SetLocalInt(OBJECT_SELF,"block",1);
    }
}
