@isTest
public class TestSObjectStatisticBatch
{
    class TestResultData
    {
    	public Boolean isSuccess;
        public String error;
    	public List<SObjectStatisticBatch.StatisticData> usageFields;
    
    	public TestResultData(Boolean s0, String s1, List<SObjectStatisticBatch.StatisticData> s2)
        {
        	this.isSuccess = s0;
            this.error = s1;
        	this.usageFields = s2;            
		}
    }
    
    class TestStatisticData
    {
    	public String field;
        public Integer usage = 3;
    
    	public TestStatisticData(String s0, integer s1) {
        	this.field = s0;
        	this.usage = s1;
		}
    }
    
    @isTest
    static void testDataResult()
    {      
        Test.startTest();
        
        List<SObjectStatisticBatch.StatisticData> testList = new List<SObjectStatisticBatch.StatisticData>();
        testList.add(new SObjectStatisticBatch.StatisticData('test', 10));
        String testString = 'TheTest';
        Boolean testBoolean = true;
        
        SObjectStatisticBatch.ResultData actual = new SObjectStatisticBatch.ResultData(testBoolean, testString, testList);
        TestResultData expected = new TestResultData(testBoolean, testString, testList);       
                
        System.debug(expected);
        System.debug(actual);
		System.assertEquals(JSON.serialize(expected), JSON.serialize(actual));
		Test.stopTest();		
	}
    
    @isTest
    static void testDataStatistic()
    {      
        Test.startTest();
        
        String testString = 'TheTest';
        Integer testInt = 111;
        
        SObjectStatisticBatch.StatisticData actual = new SObjectStatisticBatch.StatisticData(testString, testInt);
        TestStatisticData expected = new TestStatisticData(testString, testInt);       
                
        System.debug(expected);
        System.debug(actual);
		System.assertEquals(JSON.serialize(expected), JSON.serialize(actual));
        
		Test.stopTest();		
	}    
}
