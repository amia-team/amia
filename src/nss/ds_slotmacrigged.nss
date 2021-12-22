//::///////////////////////////////////////////////
//:: FileName: dg_slotmachine
//:://////////////////////////////////////////////
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
What does this do?  Basically when the gambler pulls the lever and the lever
is ready, the slot machine will print out to the gambler apples, lemons, and oranges.
Getting three of the same numbers in a row is cause for winning.  Getting all apples
is the lowest amount of winning.  All lemons is more and all oranges is the highest.
It has been added with a 'rigging' that rerolls if the player is about to
get a bit score, lowering the total expected payouts.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
//:://////////////////////////////////////////////
//:: Created By: Dagesh
//:: Created On: 5/6/08
//:://////////////////////////////////////////////
//:: Updated By: The1Kobra
//:: Updated On: 9/17/21
//:: Updated On: 10/19/21
//:://////////////////////////////////////////////

string GOLD_PAYOUT = "SlotsPayoutTotal";
void LowerPayout(object oLever, int iCost) {
    SetLocalInt(oLever, GOLD_PAYOUT, GetLocalInt(oLever,GOLD_PAYOUT)-iCost);
}
void RaisePayout(object oLever, int iCost) {
    SetLocalInt(oLever, GOLD_PAYOUT, GetLocalInt(oLever,GOLD_PAYOUT)+iCost);
}

void main()
{

    //This is used in setting
    string  sLever      = ObjectToString( OBJECT_SELF );

    object  oPC         = GetLastUsedBy();


      //This is the amount of the wager. Change this to alter the players bet amount.
      //Set w/ variable on the lever.
    int     nbet         = GetLocalInt( OBJECT_SELF, "nBet" );

    // Check to see if the slot machine lost too much this reset
    int PAYOUT_LIMIT = nbet*110;
    if (GetLocalInt(OBJECT_SELF,GOLD_PAYOUT) > PAYOUT_LIMIT) {
        SendMessageToPC(oPC, "The lever is stuck, it seems this device is broken.");
        return;
    }


      // PoS: I've messed with these payouts to try to balance them... who said slots can't be fixed?
      //All 1's
    int     nJackpot1    = nbet * 6;//1/9

      //All 2's
    int     nJackpot2    = nbet * 30;//1/54

      //All 3's
    int     nJackpot3    = nbet * 60;//1/108

      //Apple, Lemon, Orange.  Get your money back.
    int     nJackpot4    = nbet * 1;

    //This is to make sure the PC has enough gold to play.
    if( GetGold( oPC ) < nbet ){

        SendMessageToPC(oPC, "You cannot afford this game.");

    }

    //This is if the object is in use and a player tries to use it.
    if( GetLocalInt( OBJECT_SELF, sLever ) == 1 ){

        //Sends a message so that the gambler knows to try again in a moment
        SendMessageToPC( oPC,
                "This slot is not ready. Please wait a moment and try again." );

        //keeps the gambler from spamming the slot machine
        AssignCommand( oPC, ClearAllActions( TRUE ));
    }

    //This is a check to make sure the slot machine isn't in use
    else if(GetLocalInt( OBJECT_SELF, sLever ) != 1 ){

        SetLocalInt( OBJECT_SELF, sLever, 1 );

        //Sets the lever to be ready to use again in 3 seconds
        DelayCommand( 3.0, DeleteLocalInt( OBJECT_SELF, sLever ));

        //If the last guy to use it has more money than the nbet...
        if ( GetGold( oPC ) > nbet ){

            //I cleared all actions so that the gambler can't spam the slot
            //machine and just sit there for five minutes.
            AssignCommand( oPC, ClearAllActions( TRUE ));

            //The nbet leaves the pocket.  Declared above.
            TakeGoldFromCreature( nbet, oPC, TRUE );
            LowerPayout(OBJECT_SELF,nbet);

            //Play the animation for the lever to move up then
            //back down after 1.5 seconds
            PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE );

            DelayCommand( 1.5,
                        PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE ));

            string  sA, sB, sC;

            //=========================|
            switch ( Random( 6 ) ){

                case 0:    sA = "Apple";
                break;

                case 1:    sA = "Lemon";
                break;

                case 2:    sA = "Orange";
                break;

            //----|

                case 3:   sA = "Apple";
                break;

                case 4:    sA = "Lemon";
                break;

                case 5:    sA = "Orange";
                break;

            }
            //==========================|
            switch ( Random( 6 ) ){

                case 0:    sB = "Apple";
                break;

                case 1:    sB = "Lemon";
                break;

                case 2:    sB = "Orange";
                break;

            //----|

                case 3:   sB = "Apple";
                break;

                case 4:    sB = "Apple";
                break;

                case 5:    sB = "Lemon";
                break;

            }
                //=====================|
            switch ( Random( 6 ) ){

                case 0:    sC = "Apple";
                break;

                case 1:
                    sC = "Lemon";
                    if (sA == "Lemon" && sB == "Lemon") {
                        int iRand = Random(6);
                        if (iRand == 0 || iRand >= 3) {
                            sC = "Apple";
                        } else if (iRand == 1) {
                           sC = "Lemon";
                        } else if (iRand == 2) {
                            sC = "Orange";
                        }
                    }
                    break;
                case 2:
                    sC = "Orange";
                    if (sA == "Orange" && sB == "Orange") {
                        int iRand = Random(6);
                        if (iRand == 0 || iRand >= 3) {
                            sC = "Apple";
                        } else if (iRand == 1) {
                           sC = "Lemon";
                        } else if (iRand == 2) {
                            sC = "Orange";
                        }
                    }
                    break;

                //----|

                case 3:   sC = "Apple";
                break;

                case 4:    sC = "Apple";
                break;

                case 5:    sC = "Apple";
                break;

            }
            //=================|

            SendMessageToPC( oPC, sA + " * " + "*" );

            DelayCommand( 1.5,
            SendMessageToPC( oPC, sA + " " + sB + " *" ));

            DelayCommand( 3.0,
            SendMessageToPC( oPC, sA + " " + sB + " " + sC ));

            //If the player gets all 1's this is what happens
            if( sA == "Apple" && sB == "Apple" && sC == "Apple" ){

    //This is the visual effect that is applied to the gambler when
    //getting all apples.  It is timed to go off at the same time he/she gets their
    //last printed number
                DelayCommand( 3.0,

                ApplyEffectToObject( DURATION_TYPE_INSTANT,

                EffectVisualEffect( VFX_IMP_HEALING_M ),

                oPC, 3.0 ));

                //pays out the selected jackpot
                DelayCommand( 3.0, GiveGoldToCreature( oPC, nJackpot1 ));
                RaisePayout(OBJECT_SELF,nJackpot1);

            }

            //If the player gets all 2's this is what happens
            if ( sA == "Lemon" && sB == "Lemon" && sC == "Lemon" ){

    //This is the visual effect that is applied to the gambler when
    //getting all lemons. It is timed to go off at the same time he/she gets their
    //last printed number
                DelayCommand( 3.0,

                ApplyEffectToObject( DURATION_TYPE_INSTANT,

                EffectVisualEffect( VFX_IMP_HEALING_G ),

                oPC, 3.0 ));

                //Pays out the selected jackpot
                DelayCommand( 3.0, GiveGoldToCreature( oPC, nJackpot2 ));
                RaisePayout(OBJECT_SELF,nJackpot2);

            }
            //If the player gets all oranges this is what happens
            if ( sA == "Orange" && sB == "Orange" && sC == "Orange" ){

                //This is the visual effect that is applied to the gambler when
                //getting all 3's.
                DelayCommand(3.0,

                ApplyEffectToObject( DURATION_TYPE_INSTANT,

                EffectVisualEffect( VFX_IMP_HEALING_X ),

                oPC, 3.0 ));

                //Pays out the selected jackpot
                DelayCommand( 3.0, GiveGoldToCreature( oPC, nJackpot3 ));
                RaisePayout(OBJECT_SELF,nJackpot2);

            }

            //If the player gets one of each this is what happens
            if ( sA == "Apple" && sB == "Lemon" && sC == "Orange" ){

                //This is the visual effect that is applied to the gambler when
                //getting all 3's.
                DelayCommand(3.0,

                ApplyEffectToObject( DURATION_TYPE_INSTANT,

                EffectVisualEffect( VFX_IMP_HEAD_HEAL ),

                oPC, 3.0 ));

                //Pays out the selected jackpot
                DelayCommand( 3.0, GiveGoldToCreature( oPC, nJackpot4 ));
                RaisePayout(OBJECT_SELF,nJackpot4);

            }
        }
    }
}
