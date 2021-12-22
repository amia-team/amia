// Oracle item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/24/2004 jpavelch         Initial Release
//

#include "x2_inc_switches"


string GetOracleMessage( )
{
    string sMessage;
    int nRoll = d20( );

    switch ( nRoll ) {
        case 1:     sMessage = "Signs point to yes.";       break;
        case 2:     sMessage = "Yes.";                      break;
        case 3:     sMessage = "Reply hazy, try again.";    break;
        case 4:     sMessage = "Without a doubt.";          break;
        case 5:     sMessage = "My sources say no.";        break;
        case 6:     sMessage = "As I see it, yes.";         break;
        case 7:     sMessage = "You may rely on it.";       break;
        case 8:     sMessage = "Concentrate and ask again.";    break;
        case 9:     sMessage = "Outlook not so good.";      break;
        case 10:    sMessage = "It is decidedly so.";       break;
        case 11:    sMessage = "Better not tell you now.";  break;
        case 12:    sMessage = "Very doubtful.";            break;
        case 13:    sMessage = "Yes - definitely.";         break;
        case 14:    sMessage = "It is certain.";            break;
        case 15:    sMessage = "Cannot predict now.";       break;
        case 16:    sMessage = "Most likely.";              break;
        case 17:    sMessage = "Ask again later.";          break;
        case 18:    sMessage = "My reply is no.";           break;
        case 19:    sMessage = "Outlook good.";             break;
        case 20:    sMessage = "Don't count on it.";        break;
    }

    return sMessage;
}


//

void OracleSpeak( object oOracle )
{
    string sMessage = GetOracleMessage( );
    AssignCommand( oOracle, SpeakString(sMessage) );
}

//
void ActivateItem( )
{
    object oPC = GetItemActivator( );

    AssignCommand( oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 2.0) );

    object oOracle = CreateObject(
                         OBJECT_TYPE_PLACEABLE,
                         "ar_oracleinvis",
                         GetLocation(oPC)
                     );
    DelayCommand( 3.0, OracleSpeak(oOracle) );
    DestroyObject( oOracle, 5.0 );
}


void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
