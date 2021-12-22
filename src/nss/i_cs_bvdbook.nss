// Book of Revelations :: Lore check DC 40 to read some interesting chapters about Babylon

/* Includes */
#include "x2_inc_switches"

void main( ){

    // Variables
    int nEvent      = GetUserDefinedItemEventNumber( );
    int nResult     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC      = GetItemActivator( );

            if( GetIsSkillSuccessful( oPC, SKILL_LORE, 40 ) )
                SendMessageToPC(
                    oPC,
                    "- You page through this most ancient tome, coughing occasionally from turning its dusty pages, until "     +
                    "you chance upon some text that describes the cursed Temple of Set and the one known as Babylon:\n"         +
                    "Fools who dare tread risk dread for women with jealousy in their eyes, envy in their hearts and "          +
                    "lust on their forked tongues lurk here. Above all one rules, one with bruising eyes, a poisoned heart "    +
                    "and the deepest of crimson lips - A harlot of hell and a seducer of men, Babylon.\n"                       +
                    "Line her palm with silver and thou shalt receive naught but lust.\n"                                       +
                    "Pay her a sum in rocks and witness a broken heart.");

            else
                SendMessageToPC(
                    oPC,
                    "- You page through this most ancient tome, coughing occasionally from turning its dusty pages, but "       +
                    "your eyes become dry and itchy and you carelessely toss the book aside.");

            break;

        }

    }

    SetExecutedScriptReturnValue( nResult );

}
