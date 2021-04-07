@RestResource(urlMapping='/SObjectStatisticAPI/*')

global with sharing class SObjectStatistic
{  
    
    @HttpPost
    global static String postSobjectStatistic()
    {
        String sobjectName = RestContext.request.params.get('sobject');
        String endUrl = RestContext.request.params.get('url');
        return Database.executeBatch(new SObjectStatisticBatch(sobjectName,endUrl), 200);
    }   
}
