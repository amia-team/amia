/* Neo-Vodak Brain Custom Power

Spews random dialogue when used.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
04/06/13 Glim             Initial Release

*/
#include "amia_include"
#include "x2_inc_switches"

void ActivateItem()
{
    object oItem = GetItemActivated();
    object oPC = GetItemActivator();
    int nDelay = GetLocalInt( oItem, "SpamBlock" );

    if( nDelay == TRUE )
    {
        SendMessageToPC( oPC, "You must wait a little longer to use this again, lest you over tax the connection." );
        return;
    }
    else
    {
        int nRandom = Random( 50 );
        string sSpeak;

        switch (nRandom)
        {
            case 0:      sSpeak = "Hippopotamus milk is pink.";       break;
            case 1:      sSpeak = "An average human walks 115,000 miles in their life span.";       break;
            case 2:      sSpeak = "Ants enslave other ants.";       break;
            case 3:      sSpeak = "Salt is the only rock intentionally consumed by humanoids.";       break;
            case 4:      sSpeak = "Ravensbluff is also known as the living city.";       break;
            case 5:      sSpeak = "Elminster snores very loudly.";       break;
            case 6:      sSpeak = "Nilbog result from space time inversion corruption.";       break;
            case 7:      sSpeak = "An adult Aboleth weighs 6500 pounds and is 20 feet long.";       break;
            case 8:      sSpeak = "Dragons are not true reptiles.";       break;
            case 9:      sSpeak = "Ravens mate for life.";       break;
            case 10:     sSpeak = "The weasel is the only natural predator of the Cockatrice.";       break;
            case 11:     sSpeak = "The Grand Abyss is found on the fourth layer of the Abyss.";       break;
            case 12:     sSpeak = "Mosquitoes are attracted to the color blue.";       break;
            case 13:     sSpeak = "Ghukliak is the spoken language of goblinoids.";       break;
            case 14:     sSpeak = "Khelben 'Blackstaff' Arunsun had three childhood nick names, Biir, Bhin and Zenar.";       break;
            case 15:     sSpeak = "If your stomach does not produce new layers of mucus it will digest itself.";       break;
            case 16:     sSpeak = "Thauglorimorgorus the Purple is the black dragon who adorns Cormyrs coat of arms.";       break;
            case 17:     sSpeak = "Waterdhavian cheese is a pale, full of holes and has a sharp, tangy taste.";       break;
            case 18:     sSpeak = "Volothamp Geddarm is the Realms' most prolific travel writer.";       break;
            case 19:     sSpeak = "Drinking from the River Styx is not recommended.";       break;
            case 20:     sSpeak = "Elves do not have canine teeth naturally.";       break;
            case 21:     sSpeak = "Bulette eggs are covered in spines.";       break;
            case 22:     sSpeak = "Ogrillon are half orc, half ogre, and not to be confused with Orog who are underdark orcs.";       break;
            case 23:     sSpeak = "Fey Crossroads are magical portals only accessible to feykind.";       break;
            case 24:     sSpeak = "Rats can last longer without water than a camel.";       break;
            case 25:     sSpeak = "Honey cannot spoil.";       break;
            case 26:     sSpeak = "Bats always turn left when exiting a cave.";       break;
            case 27:     sSpeak = "A jiffy is a measurement of time equal to one, one-hundredth of a second.";       break;
            case 28:     sSpeak = "Almonds are related to peaches.";       break;
            case 29:     sSpeak = "A young eel is called an elver.";       break;
            case 30:     sSpeak = "Pearls melt in vinegar.";       break;
            case 31:     sSpeak = "You cannot sneeze with your eyes open.";       break;
            case 32:     sSpeak = "All polar bears are left handed.";       break;
            case 33:     sSpeak = "A duck's quack does not echo, this is a common myth!";       break;
            case 34:     sSpeak = "Butterflies taste with their feet.";       break;
            case 35:     sSpeak = "Midnight is the third being to be Mystra.";       break;
            case 36:     sSpeak = "Traditional Gnomeish weddings typically last seven to ten days.";       break;
            case 37:     sSpeak = "All Derro are insane.";       break;
            case 38:     sSpeak = "Knucklehead trout are Icewind Dales only export.";       break;
            case 39:     sSpeak = "Blood is red because it contains iron.";       break;
            case 40:     sSpeak = "A new starfsh grows form each of its severed limbs.";       break;
            case 41:     sSpeak = "Illithid eat many organs, brains are just their favorite.";       break;
            case 42:     sSpeak = "*you engage in a rousing game of solitare*";       break;
            case 43:     sSpeak = "Error!";       break;
            case 44:     sSpeak = "The Answer is forty-two.";       break;
            case 45:     sSpeak = "Does not compute!";       break;
            case 46:     sSpeak = "Password required to proceed!";       break;
            case 47:     sSpeak = "*the sphere turns a shade of blue and refuses to work until it is reactivated*";       break;
            case 48:     sSpeak = "We will devour all knowledge for we are... *you hastily deactivate the sphere and double check its wards*";       break;
            case 49:     sSpeak = "You are not alone.";       break;
            default: break;
        }

        AssignCommand( oItem, SpeakString( sSpeak ) );
        SetLocalInt( oItem, "SpamBlock", 1 );
        DelayCommand( 30.0, DeleteLocalInt( oItem, "SpamBlock" ) );
    }
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
