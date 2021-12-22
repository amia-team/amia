//author: tarnus
//date: 02.09
// This a chathandler for the nwnx chat plugin, presently configured to handle emotes.
#include "nwnx_chat"
#include "x3_inc_string"

//StringToRGBString(sMessage, STRING_COLOR_RED)

void send_message(int iMessagechannel, string sMessage, object oSender, object oTarget)
{
    // simply sends the chat message as received
    NWNX_Chat_SkipMessage();
    NWNX_Chat_SendMessage(iMessagechannel, sMessage, oSender, oTarget);
}

void text_colorizer(int iMessagechannel, string sMessage, object oSender, object oTarget, string sEmotesymbol)
{
    // This function will search for a set emote symbol and replace text between them with blue.
    int iMessagelength = GetStringLength(sMessage);
    int iSearchPosition = 0;
    string sOutput = sMessage;
    int endofstringreached = FALSE;
    int iIteration = 0;
    string sEmote;
    int iShiftPosition;
    int iShiftStringposition;
    string sFirstTwoCharacters;
    // check if the message is a comment
    sFirstTwoCharacters = GetStringLeft(sMessage, 2);
    if(sFirstTwoCharacters == "//" | sFirstTwoCharacters == "((")
    {
        string sOOC = "[OOC]" + GetStringRight(sMessage, iMessagelength-2);
        sOOC = StringToRGBString(sOOC, "742");
        send_message(iMessagechannel, sOOC, oSender, oTarget);
        return;
    }

    // colorize emotes. The loop will continue through a message until no more emotes are found
    do
    {
        int iEmotestringposition = FindSubString(sMessage, sEmotesymbol, iSearchPosition);
        // Check if there are any emote indicators in the next, if no, just send the unmodified message
        if (iEmotestringposition == -1)
        {
            send_message(iMessagechannel, sOutput, oSender, oTarget);
            return;
        }
        else
        {
            iShiftPosition = iEmotestringposition+1;
            iShiftStringposition = FindSubString(sMessage, sEmotesymbol, iShiftPosition);
            // Check if there is a second emote indicator in the string, if no send the unmodified message
            if (iShiftStringposition == -1)
            {
                send_message(iMessagechannel, sOutput, oSender, oTarget);
                return;
            }
            // Extract emotes from the message and colorize them
            int icharactercount = iShiftStringposition-iEmotestringposition+1; // get the amounts of characters in the emote
            string sPLACEHOLDER = GetSubString(sMessage, iEmotestringposition, icharactercount);
            sEmote = StringToRGBString(sPLACEHOLDER, "377");
            sOutput = StringReplace(sOutput, sPLACEHOLDER, sEmote);
        }

    // check if the string has been sarched till the end, if so set the variable to true, which will end the execution on the next check
    if (iShiftPosition+1 == iMessagelength)
    {
        endofstringreached = TRUE;
        send_message(iMessagechannel, sOutput, oSender, oTarget);
    }
    iIteration = iIteration +1;
    iSearchPosition = iShiftStringposition+1;
    } while (endofstringreached == FALSE);

}

void main()
{
    int iChannel = NWNX_Chat_GetChannel();
    string sMessage = NWNX_Chat_GetMessage();
    object oSender = NWNX_Chat_GetSender();
    object oTarget = NWNX_Chat_GetTarget();

    string sPLACEHOLDEREMOTESYMBOL = "*";//this should be replaced
    // Talk or whisper channel
    if (iChannel == 1)
    {
        text_colorizer(iChannel, sMessage, oSender, oTarget, sPLACEHOLDEREMOTESYMBOL);
    }
    else if (iChannel == 3)
    {
        text_colorizer(iChannel, sMessage, oSender, oTarget, sPLACEHOLDEREMOTESYMBOL);
    }
    // playershout channel
    else if (iChannel == 2)
    {
        NWNX_Chat_SkipMessage();
        // text_colorizer(iChannel, sMessage, oSender, oSender, sPLACEHOLDEREMOTESYMBOL);
    }
    else if (iChannel == 4)
    {
        if (TestStringAgainstPattern("Command:**", sMessage))
        {
            send_message(iChannel, sMessage, oSender, oSender);
        }
        else
        {
            send_message(iChannel, sMessage, oSender, oTarget);
        }
    }
    else if (iChannel == 18)
    {
        if (TestStringAgainstPattern("Command:**", sMessage))
        {
            send_message(iChannel, sMessage, oSender, oSender);
        }
        else
        {
            send_message(iChannel, sMessage, oSender, oTarget);
        }
    }
    else if (iChannel == 20)
    {
        if (TestStringAgainstPattern("Command:**", sMessage))
        {
            send_message(iChannel, sMessage, oSender, oSender);
        }
        else
        {
            send_message(iChannel, sMessage, oSender, oTarget);
        }
    }
    else
    {
        send_message(iChannel, sMessage, oSender, oTarget);
    }
}
