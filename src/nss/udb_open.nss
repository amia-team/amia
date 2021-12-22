//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:
//group:
//used as:
//date: yyyy-mm-dd
//author:
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
void CreateBook( string sTag );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){


    object oPC      = GetLastOpenedBy();
    object oPLC     = OBJECT_SELF;
    string sTag     = GetTag( oPLC );
    string sName    = GetName( oPLC );


    if ( sTag == "udb_lich_shelf" ){

        if ( GetIsBlocked() < 1 ){

            if ( GetTag( GetFirstItemInInventory( ) ) != "udb_lich_book" ){

                SetBlockTime();

                if ( d6() == 1 || GetLocalInt( OBJECT_SELF, "opened" ) == 1 ){

                    CreateBook( "udb_lich_book" );

                    SetLocalInt( OBJECT_SELF, "opened", 1 );
                }
                else{

                    object oBook = CreateItemOnObject( "ds_base_book", OBJECT_SELF, 1, "udb_lich_book" );

                    SetName( oBook, "A boring book" );

                    SetDescription( oBook, "This is really not the kind of book a bored lich will accept." );

                    SetItemCursedFlag( oBook, 1 );
                }
            }
        }
    }
    else if ( sTag == "udb_ork_chest" ){

        if ( GetTag( GetFirstItemInInventory( ) ) != "udb_ork_orb" ){

            CreateItemOnObject( "udb_ork_orb" );
        }
    }
}


void CreateBook( string sTag ){

    string sTitleAdj;
    string sTitleNoun;
    string sBookAdj;
    string sBookNoun;
    string sBookTopic1;
    string sBookTopic2;
    string sName;
    string sTitle;
    string sDescription;

    int nTitleAdj  = d20();
    int nTitleNoun = d20();
    int nBookAdj   = d20();
    int nBookNoun  = d20();
    int nBookTopic = d20();
    int nName      = 1 + Random( 7 );
    int nTitle     = d8();
    int nBookCover = 1 + Random( 36 );


    switch ( nTitleAdj ){

        case 1: sTitleAdj = "Outrageous"; break;
        case 2: sTitleAdj = "Holy"; break;
        case 3: sTitleAdj = "Glorious"; break;
        case 4: sTitleAdj = "Devious"; break;
        case 5: sTitleAdj = "Exotic"; break;
        case 6: sTitleAdj = "Erotic"; break;
        case 7: sTitleAdj = "True"; break;
        case 8: sTitleAdj = "Dark"; break;
        case 9: sTitleAdj = "Black"; break;
        case 10: sTitleAdj = "Mesmerising"; break;
        case 11: sTitleAdj = "Bloody Stupid"; break;
        case 12: sTitleAdj = "Spiritual"; break;
        case 13: sTitleAdj = "Magical"; break;
        case 14: sTitleAdj = "Fantastic"; break;
        case 15: sTitleAdj = "Wonderful"; break;
        case 16: sTitleAdj = "Strange"; break;
        case 17: sTitleAdj = "Amazing"; break;
        case 18: sTitleAdj = "Early"; break;
        case 19: sTitleAdj = "Metaphysical"; break;
        case 20: sTitleAdj = "Transcendent"; break;
    }

    switch ( nTitleNoun ){

        case 1: sTitleNoun = "Works"; break;
        case 2: sTitleNoun = "Teachings"; break;
        case 3: sTitleNoun = "Essays"; break;
        case 4: sTitleNoun = "Records"; break;
        case 5: sTitleNoun = "Voyages"; break;
        case 6: sTitleNoun = "Deeds"; break;
        case 7: sTitleNoun = "Journals"; break;
        case 8: sTitleNoun = "Travelogues"; break;
        case 9: sTitleNoun = "Confessions"; break;
        case 10: sTitleNoun = "Poetry"; break;
        case 11: sTitleNoun = "Prayers"; break;
        case 12: sTitleNoun = "Writings"; break;
        case 13: sTitleNoun = "Philosophy"; break;
        case 14: sTitleNoun = "Musings"; break;
        case 15: sTitleNoun = "Verses"; break;
        case 16: sTitleNoun = "Wisdom"; break;
        case 17: sTitleNoun = "Words"; break;
        case 18: sTitleNoun = "Sayings"; break;
        case 19: sTitleNoun = "Sermons"; break;
        case 20: sTitleNoun = "Plays"; break;
    }

    switch ( nBookAdj ){

        case 1: sBookAdj = "well-known"; break;
        case 2: sBookAdj = "hilarious"; break;
        case 3: sBookAdj = "obscure"; break;
        case 4: sBookAdj = "blasphemous"; break;
        case 5: sBookAdj = "amusing"; break;
        case 6: sBookAdj = "arousing"; break;
        case 7: sBookAdj = "annoying"; break;
        case 8: sBookAdj = "stimulating"; break;
        case 9: sBookAdj = "challenging"; break;
        case 10: sBookAdj = "bewildering"; break;
        case 11: sBookAdj = "excellent"; break;
        case 12: sBookAdj = "entertaining"; break;
        case 13: sBookAdj = "delightful"; break;
        case 14: sBookAdj = "intoxicating"; break;
        case 15: sBookAdj = "beautiful"; break;
        case 16: sBookAdj = "funny"; break;
        case 17: sBookAdj = "amazing"; break;
        case 18: sBookAdj = "interesting"; break;
        case 19: sBookAdj = "fascinating"; break;
        case 20: sBookAdj = "exhuberant"; break;
    }

    switch ( nBookNoun ){

        case 1: sBookNoun = "book"; break;
        case 2: sBookNoun = "tome"; break;
        case 3: sBookNoun = "publication"; break;
        case 4: sBookNoun = "novel"; break;
        case 5: sBookNoun = "autobiography"; break;
        case 6: sBookNoun = "journal"; break;
        case 7: sBookNoun = "autobiography"; break;
        case 8: sBookNoun = "travelogue"; break;
        case 9: sBookNoun = "biography"; break;
        case 10: sBookNoun = "compendium"; break;
        case 11: sBookNoun = "text"; break;
        case 12: sBookNoun = "booklet"; break;
        case 13: sBookNoun = "dissertation"; break;
        case 14: sBookNoun = "edition"; break;
        case 15: sBookNoun = "work"; break;
        case 16: sBookNoun = "monograph"; break;
        case 17: sBookNoun = "collection"; break;
        case 18: sBookNoun = "portfolio"; break;
        case 19: sBookNoun = "tract"; break;
        case 20: sBookNoun = "volume"; break;
    }

    switch ( nBookTopic ){

        case 1: sBookTopic1 = "was written a long time ago by the esteemed"; sBookTopic2 = ". It's somewhat dense at places but worth a read anyway"; break;
        case 2: sBookTopic1 = "details the "+GetStringLowerCase(sTitleAdj)+" journeys of"; sBookTopic2 = ". The style of the author is breathtaking"; break;
        case 3: sBookTopic1 = "contemplates on the (sometimes "+GetStringLowerCase(sTitleAdj)+") views of"; sTitle = "About "; break;
        case 4: sBookTopic1 = "gives an outstanding overview of the "+GetStringLowerCase(sTitleAdj)+" themes in"; sBookTopic2 = "'s later works"; break;
        case 5: sBookTopic1 = "is a lively account of"; sBookTopic2 = "'s "+GetStringLowerCase(sTitleAdj)+" life by an anonymous author"; break;
        case 6: sBookTopic1 = "is the long lost (and "+GetStringLowerCase(sTitleAdj)+") papers of"; break;
        case 7: sBookTopic1 = "was published by"; sBookTopic2 = " and narrates the "+GetStringLowerCase(sTitleAdj)+" life and times of the author"; break;
        case 8: sBookTopic1 = "contains the complete work of"; sBookTopic2 = ". It's a "+GetStringLowerCase(sTitleAdj)+" piece of literature"; break;
        case 9: sBookTopic1 = "analyses"; sBookTopic2 ="'s most critical failures. This is a book everybody can learn from."; break;
        case 10: sBookTopic1 = "lists the "+GetStringLowerCase(sTitleAdj)+" writings of"; break;
        case 11: sBookTopic1 = "shows how"; sBookTopic2 =" got things done (preferably in a "+GetStringLowerCase(sTitleAdj)+" way)"; break;
        case 12: sBookTopic1 = "tells of the various things"; sBookTopic2 =" was interested in. It contains every detail imaginable"; break;
        case 13: sBookTopic1 = "puts"; sBookTopic2 ="'s "+GetStringLowerCase(sTitleAdj)+" life in a negative light"; break;
        case 14: sBookTopic1 = "portrays"; sBookTopic2 ="'s "+GetStringLowerCase(sTitleAdj)+" deeds in a positive way"; break;
        case 15: sBookTopic1 = "recounts"; sBookTopic2 ="'s "+GetStringLowerCase(sTitleAdj)+" exploits"; break;
        case 16: sBookTopic1 = "recapitulates the "+GetStringLowerCase(sTitleAdj)+" theories laid down by"; break;
        case 17: sBookTopic1 = "is clearly a misrepresentation of"; sBookTopic2 ="'s life and "+GetStringLowerCase(sTitleAdj)+" works but a good read nonetheless"; break;
        case 18: sBookTopic1 = "describes the rituals of the Church of Sune and"; sBookTopic2 ="'s role in it in a manner that leaves little room for imagination";  break;
        case 19: sBookTopic1 = "produces damning evidence against"; sBookTopic2 ="'s infamous "+sTitleAdj+" "+sTitleNoun; sTitle = "On "; break;
        case 20: sBookTopic1 = "elaborates on"; sBookTopic2 ="'s virtue in a most peculiar yet "+GetStringLowerCase(sTitleAdj)+" way"; break;
    }

    sName = RandomName( ( ( 3 * nName ) + 1 - d2() ) ) + " "+ RandomName( ( 3 * nName ) + 1 );

    switch ( nTitle ){

        case 1: sTitle += sName+"'s "+sTitleAdj+" "+sTitleNoun; break;
        case 2: sTitle += "The "+sTitleAdj+" "+sTitleNoun+" of "+sName; break;
        case 3: sTitle += sName+"'s Complete "+sTitleNoun; break;
        case 4: sTitle += sName+"'s Best "+sTitleNoun; break;
        case 5: sTitle = "Selected "+sTitleNoun+" of "+sName; break;
        case 6: sTitle = "The Illustrated "+sTitleNoun+" of "+sName; break;
        case 7: sTitle += sTitleAdj+" "+sTitleNoun+", Volume "+IntToString( d4() ); break;
        case 8: sTitle += sName+"'s "+sTitleAdj+" "+sTitleNoun+", Part "+IntToString( d10() ); break;
    }

    sDescription = "This "+sBookAdj+" "+sBookNoun+" "+sBookTopic1+" "+sName+sBookTopic2+".";

    object oBook1 = CreateItemOnObject( "ds_base_book", OBJECT_SELF, 1, sTag );

    object oBook2 = CopyItemAndModify( oBook1, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nBookCover );

    DestroyObject( oBook1 );

    SetName( oBook2, "<c þþ>"+sTitle+"</c>" );
    SetDescription( oBook2, sDescription );
}
