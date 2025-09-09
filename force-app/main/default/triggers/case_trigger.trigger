trigger case_trigger on case (before insert) 
{
    new xase_trigger_handler().run()
}