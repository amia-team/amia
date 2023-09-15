// Script to create looping animation based on variable set on npc
//
// 06-sep-2023  Frozen  created

void main(){

    int iAnimation = GetLocalInt (OBJECT_SELF, "animation");

    PlayAnimation(iAnimation, 1.0, 30000.0);

}
