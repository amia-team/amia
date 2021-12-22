// OnOpen inventory auto-restock for containers (useful for bookshelves)
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2005/01/12 jking            Initial release.
//

#include "amia_include"
#include "nw_i0_plot"
#include "logger"

void main()
{
    string tag = GetLocalString(OBJECT_SELF, "StockTag");
    if (tag == "") {
        LogWarn("op_autostock", "object " + GetName(OBJECT_SELF) +
            "(" + GetTag(OBJECT_SELF) + ") in area " + GetName(GetArea(OBJECT_SELF)) +
            " is missing StockTag variable (op_autostock script)");
        return;
    }

    string res = GetLocalString(OBJECT_SELF, "StockResRef");
    if (res == "") {
        LogWarn("op_autostock", "object " + GetName(OBJECT_SELF) +
            "(" + GetTag(OBJECT_SELF) + ") in area " + GetName(GetArea(OBJECT_SELF)) +
            " is missing StockResRef variable (op_autostock script)");
        return;
    }

    if (GetNumItems(OBJECT_SELF, tag) == 0)
        CreateItemOnObject(res);
}


