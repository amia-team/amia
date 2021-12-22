/*  Script: i_pos_q42_dust
    Created by: Anatida
    Date: 8/03/2015
    Item Activation Script for Shadesteel Dust
    Quest 42 PC reward, grants stealth benefits for 15 minutes.
 */

void main()
{
object oPC;

if (!GetIsPC(GetItemActivatedTarget())
){

SendMessageToPC(GetItemActivator(), "This item can not be used that way!");
return;}

oPC = GetItemActivator();

object oTarget;
oTarget = oPC;

effect eEffect;
eEffect = EffectSkillIncrease(SKILL_HIDE, 5);

eEffect = ExtraordinaryEffect(eEffect);

ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 600.0f);

eEffect = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 5);

eEffect = ExtraordinaryEffect(eEffect);

ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 600.0f);

}

