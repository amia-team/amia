  /* Random boss spawn script

  */

#include "bbs_include"
#include "nwnx_webhook"

void spawn_boss (object oEngine, string nSpawnLocation, string nBossTag, string nBossResRef);

void main()
{
    object oMaster      = GetObjectByTag ("random_boss_master_engine");
    int    iActivated   = GetLocalInt (oMaster, "Spaw_on");
    string nBossSetting;

        //not spawn more then 1 boss per reset
        if (iActivated == 1){return;}

        else if (iActivated == 0 ){

            switch( d12(1) ){

                case 1 : nBossSetting = "random_boss_1_engine"  ;    break; //random_boss_1_*
                case 2 : nBossSetting = "random_boss_2_engine"  ;    break; //random_boss_2_*
                case 3 : nBossSetting = "random_boss_3_engine"  ;    break; //random_boss_3_*
                case 4 : nBossSetting = "random_boss_4_engine"  ;    break; //random_boss_4_*
                case 5 : nBossSetting = "random_boss_5_engine"  ;    break; //random_boss_5_*
                case 6 : nBossSetting = "random_boss_6_engine"  ;    break; //random_boss_6_*
                case 7 : nBossSetting = "random_boss_7_engine"  ;    break; //random_boss_7_*
                case 8 : nBossSetting = "random_boss_8_engine"  ;    break; //random_boss_8_*
                case 9 : nBossSetting = "random_boss_9_engine"  ;    break; //random_boss_9_*
                case 10: nBossSetting = "random_boss_10_engine" ;    break; //random_boss_10_*
                case 11: nBossSetting = "non" ;    break; //no boss
                case 12: nBossSetting = "non" ;    break; //no boss


                default:                                        break;


                if (nBossSetting == "non"){SetLocalInt (oMaster, "Spaw_on", 1);return;}

                else{

                    object oEngine          = GetObjectByTag (nBossSetting);
                    string nSpawnLocation   = GetLocalString (oEngine, "boss_spawn_point");
                    string nBossTag         = GetLocalString (oEngine, "boss_tag");
                    string nBossResRef      = GetLocalString (oEngine, "boss_resref");
                    string nBossHintName    = GetLocalString (oEngine, "boss_hint_name");
                    string nBossHintLoc     = GetLocalString (oEngine, "boss_hint_loc");
                    string nBossHintDef     = GetLocalString (oEngine, "boss_hint_def");

                    object oBBS             = GetNearestObjectByTag ("BBS");
                    string nPoster          = "W&S";
                    string nTitle           = "S Class job! Monster Hunting";
                    string nMessage         = "A Dangerous "+nBossHintName +" has been sighted at "+nBossHintLoc +" Be sure to bring many people and someting against "+nBossHintDef;



                    bbs_add_notice(oBBS, nPoster, nTitle, nMessage, "");
                    SetLocalInt (oMaster, "Spaw_on", 1);

                }
            }
        }
}

void spawn_boss (object oEngine, string nSpawnLocation, string nBossTag, string nBossResRef){}
