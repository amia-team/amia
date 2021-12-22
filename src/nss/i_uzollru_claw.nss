// Completed by Glim on the 29th January 2013.

// Version 1.0.

// This script handles the OnHit of the Uzollru Obyrith.

#include "x2_inc_switches"

void main()
{
    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ONHITCAST:
        {
            object oCritter = OBJECT_SELF;
            object oTarget = GetSpellTargetObject();
            int iGrappled = GetLocalInt( oTarget, "UzollruGrapple" );

            //if already grappled, don't grapple again
            if( iGrappled != 0 )
            {
                return;
            }

            string sTarget = GetName( oTarget );

            int nCBAB = GetBaseAttackBonus( oCritter );
            int nCSTR = GetAbilityModifier( ABILITY_STRENGTH, oCritter );
            int nCRoll = d20(1);
            int nCSizeMod = GetLocalInt( oCritter, "SizeModifier" );
            int nCGrapple = nCBAB + nCSTR + nCSizeMod + nCRoll;

            string sCBAB = IntToString( nCBAB );
            string sCSTR = IntToString( nCSTR );
            string sCRoll = IntToString( nCRoll );
            string sCSizeMod = IntToString( nCSizeMod );
            string sCTotal = IntToString( nCGrapple );

            int nTBAB = GetBaseAttackBonus( oTarget );
            int nTSTR = GetAbilityModifier( ABILITY_STRENGTH, oTarget );
            int nTRoll = d20(1);
            int nTSize = GetCreatureSize( oTarget );
            int nTSizeMod;
            switch (nTSize)
            {
                case 1:     nTSizeMod = -8;      break;
                case 2:     nTSizeMod = -4;      break;
                case 3:     nTSizeMod = 0;       break;
                case 4:     nTSizeMod = 4;       break;
                case 5:     nTSizeMod = 8;       break;
                default:    nTSizeMod = 0;       break;
            }
            int nTGrapple = nTBAB + nTSTR + nTSizeMod + nTRoll;

            string sTBAB = IntToString( nTBAB );
            string sTSTR = IntToString( nTSTR );
            string sTRoll = IntToString( nTRoll );
            string sTSize = IntToString( nTSizeMod );
            string sTTotal = IntToString( nTGrapple );

            int nTouch = TouchAttackMelee( oTarget, TRUE );
            int nDamage = d6(4) + 22;

            if( nTouch == 2 )
            {
                nDamage = nDamage * 2;
            }

            if( nTouch <= 1 )
            {
                if( nCGrapple > nTGrapple )
                {
                    SendMessageToPC( oTarget, "<c¥  >Uzollru</c> <cÂ† >attempts Grapple on "+sTarget+" : *success* : (d20:"+sCRoll+" + BAB:"+sCBAB+" + STR:"+sCSTR+" + Size:"+sCSizeMod+" = "+sCTotal+") <cþ  >vs</c> (d20:"+sTRoll+" + BAB:"+sTBAB+" + STR:"+sTSTR+" + Size:"+sTSize+" = "+sTTotal+")</c>" );

                    effect eGrapple = EffectVisualEffect( VFX_DUR_STONEHOLD );
                    effect eTrap = EffectCutsceneParalyze();
                    effect eLink1 = EffectLinkEffects( eTrap, eGrapple );
                    eLink1 = SupernaturalEffect( eLink1 );

                    effect eConstrict = EffectDamage( nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL );

                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, 6.0 );
                    SetLocalInt( oTarget, "UzollruGrapple", 1 );

                    DelayCommand( 3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eConstrict, oTarget ) );
                    DelayCommand( 6.0, DeleteLocalInt( oTarget, "UzollruGrapple" ) );

                    string sThrow = "<c þþ>**The Uzollru catches you in a claw and begins to crush the life from you!**</c>";
                    SendMessageToPC( oTarget, sThrow );
                }
                else
                {
                    SendMessageToPC( oTarget, "<c¥  >Uzollru</c> <cÂ† >attempts Grapple on "+sTarget+" : *failure* : (d20:"+sCRoll+" + BAB:"+sCBAB+" + STR:"+sCSTR+" + Size:"+sCSizeMod+" = "+sCTotal+") <cþ  >vs</c> (d20:"+sTRoll+" + BAB:"+sTBAB+" + STR:"+sTSTR+" + Size:"+sTSize+" = "+sTTotal+")</c>" );
                }
            }
            break;
        }
        default:{
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
