@RestResource(urlMapping='/SObjectListAPI/*')

global with sharing class SObjectList
{
    
    @HttpPost
    global static List<String> getAllSObjects()
	{
    	List<String> sObjectList = new List<String>();
    	for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
    	{
        	Schema.DescribeSObjectResult describeSObjectResultObj = objTyp.getDescribe();
        	String name = objTyp.getDescribe().getName();
        	sobjectList.add(name);
        }
    
    	return sObjectList;
	}
}
