//void main (){}
effect EffectFromConstant(int effectType);

effect EffectFromConstant(int effectType){
    effect returnEffect;

    switch(effectType){
    case EFFECT_TYPE_FRIGHTENED:
        returnEffect = EffectFrightened();
        break;
    default:
        returnEffect = EffectHeal(1);
    }
    return returnEffect;
}
