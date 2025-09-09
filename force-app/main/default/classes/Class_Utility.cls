public with sharing class Class_Utility {

    private static final String Handler_Name = 'xase_trigger_handler';

    public Class_Utility() 
    {

        public static void updatecasesubject(list<case> caselist)
        {
            for(case cs: caselist)
            {
                cs.subject= 'kewl new subject';
            }
        }
    }
    public static void createcase()
    {
        TriggerHandler.bypass(Handler_Name);


        case newcase = new case();
        newcase.subject='awesome case';
        insert newcase;


        TriggerHandler.clearbypass(Handler_Name);
    }

}