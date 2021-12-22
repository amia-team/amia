/*  Temple of Shar - Trigger based ambient chatter script.

    --------
    Verbatim
    --------
    Walk on the trigger, local NPCs spout out a random line.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    070706  Aleph       Initial release.
    092706  kfw         Trigger failure added: So the convo's don't fire too often.
    ----------------------------------------------------------------------------

*/


void main()

{

    // Trigger failure, 70% chance.
    if( d10( ) <= 7 )
        return;


object oPC = GetEnteringObject();

string sTrigger = GetTag(GetNearestObject(OBJECT_TYPE_TRIGGER, oPC));

int iChatter = d6();

if(sTrigger == "tshar_chat1")
{

switch(iChatter)

{

case 1:

AssignCommand(GetObjectByTag("tshar_greeter"), SpeakString ("Welcome, traveller... *She smiles warmly.*  Do take a seat somewhere and relax."));

break;

case 2:

AssignCommand(GetObjectByTag("tshar_greeter"), SpeakString ("If there is anything you need....   you need only ask."));

break;

case 3:

AssignCommand(GetObjectByTag("tshar_patron1"), SpeakString ("The mutton was lovely.  I'll take another.  Do compliment your slavehands, dear."));

break;

case 4:

AssignCommand(GetObjectByTag("tshar_patron1"), SpeakString ("Mm...  I'm a glutton for your mutton!"));

break;

case 5:
AssignCommand(GetObjectByTag("tshar_cook"), SpeakString ("What'll it be, m'lady?"));

break;

case 6:
AssignCommand(GetObjectByTag("tshar_cook"), SpeakString ("All your culinary wishes are my command, madame."));

break;

}

}

if(sTrigger == "tshar_chat2")
{

switch(iChatter)

{

case 1:

AssignCommand(GetObjectByTag("tshar_barmaid1"), SpeakString ("Come to me, my darlings, and all your troubles will drift away.  *Grins wickedly.*"));

break;

case 2:

AssignCommand(GetObjectByTag("tshar_barmaid1"), SpeakString ("* Making certain their better judgment is diluted in drink, the barmaid winks and tosses her hair flirtatiously at the gamblers as she pours their ale. * "));

break;

case 3:

AssignCommand(GetObjectByTag("tshar_gambler1"), SpeakString ("Bah!  I thought for sure I had it that time.   All right all right...   one more go!"));

break;

case 4:

AssignCommand(GetObjectByTag("tshar_gambler1"), SpeakString ("* The gambler, obiously drunk out of his wits, tosses more gold on the table, blissfully betting his riches away in a sea of vice. *"));

break;

case 5:
AssignCommand(GetObjectByTag("tshar_gambler2"), SpeakString ("* The noblewoman gives a shrill squeak of delight, jumping up and down excitedly as she scoops up her winnings before dropping them on the table to place a new bet. ''Beshaba be merciful!'' *"));

break;

case 6:
AssignCommand(GetObjectByTag("tshar_fightguy"), SpeakString ("Drat!  And I was doing so well until the fightmaster got cleaved in two!"));

break;

}

}

if(sTrigger == "tshar_chat3")
{

switch(iChatter)

{

case 1:

AssignCommand(GetObjectByTag("tshar_sharran1"), SpeakString ("All your secrets are safe with me...  *Smiles seductively.*"));

break;

case 2:

AssignCommand(GetObjectByTag("tshar_sharran2"), SpeakString ("* The young woman whispers sweet promises into the nobleman's ear, "));

break;

case 3:

AssignCommand(GetObjectByTag("tshar_sharran3"), SpeakString ("Here, dears...  * The woman passes vials of illicit brews to her companions, smilingly wickedly. *  Forget all your troubles..."));

break;

case 4:

AssignCommand(GetObjectByTag("tshar_barmaid2"), SpeakString ("May I pour you another, dears?"));

break;

case 5:
AssignCommand(GetObjectByTag("tshar_barmaid2"), SpeakString ("* The barmaid pours a thick red substance into a cup, handing it to a nearby nobleman.  He winces and wretches with every sip, yet eagerly gulps it down before slinking back in his chair in a blissful daze. *"));

break;

case 6:
AssignCommand(GetObjectByTag("tshar_nobleguy"), SpeakString ("I think....   you're right...   the only way to get rid of her is...  * A sad look washes over the nobleman's face, following by a grim stare. *  Yes.   It must be done."));

break;

}

}

}
