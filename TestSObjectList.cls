@isTest
public class TestSObjectList 
{
	@isTest
	static void testGetAllSObjects()
	{	
        Test.startTest();
        list<string> actual= SObjectList.getAllSObjects();
        List<String> expected = new List<String>();
		
    	for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
    	{
        	Schema.DescribeSObjectResult describeSObjectResultObj = objTyp.getDescribe();
        	String name = objTyp.getDescribe().getName();
        	expected.add(name);
        }
        
        System.debug(expected);
        System.debug(actual);
		System.assertEquals(expected, actual);
		Test.stopTest();		
	}
}
