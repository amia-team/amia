// Bridge for Amia OnActivated custom scripting (prefix i_)
// you could #include the script here but it would make 2 compiled copies
// which is just silly.

void main()
{
    ExecuteScript("cb_bark", OBJECT_SELF);
}

