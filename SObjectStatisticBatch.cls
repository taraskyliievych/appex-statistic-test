global class SObjectStatisticBatch implements
    Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful
    {

    global class StatisticData
    {
    	public String field;
        public Integer usage = 3;
    
    	public StatisticData(String s0, integer s1)
        {
        	this.field = s0;
        	this.usage = s1;
		}
    }
    
    global class ResultData
    {
    	public Boolean isSuccess;
        public String error;
    	public List<StatisticData> usageFields;
    
    
    	public ResultData(Boolean s0, String s1, List<StatisticData> s2)
        {
        	this.isSuccess = s0;
            this.error = s1;
        	this.usageFields = s2;            
		}
    }  

    final String sobjectName;
    final String endPoint;
    String query;
    public Integer recordsProcessed = 0;
    Map<String, Schema.SObjectField> fieldMap;
    Integer allCount = 0;
    Exception[] errors = new Exception[0];

    List<StatisticData> statisticList = new List<StatisticData>(); 
    

    public SObjectStatisticBatch(String objectName, String endUrl)
    {
        
        sobjectName = objectName;
        endPoint = endUrl;

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
	    fieldMap = schemaMap.get(sobjectName).getDescribe().fields.getMap();

        query = 'SELECT ' + String.join(new List<String>(Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap().keySet()), ',') + ' FROM ' + objectName;

        for(String fieldName : fieldMap.keyset())
    	{
            StatisticData stobj = new StatisticData(fieldName, 0);            
            statisticList.add(stobj);
        }
    }    

    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope)
    {
        for(sobject s : scope)
        {   
            allCount = allCount + 1;
            Integer i = 0;

            for(String fieldName : fieldMap.keyset())
    		{
                if(fieldName.contains('address'))
                {
            		break;
            	}               
                
                if(s.get(fieldName) instanceof Boolean && s.get(fieldName) == FALSE)
                {
                	statisticList[i].usage = statisticList[i].usage + 1;
                } else {
                    if ( (s.get(fieldName) == null))
                    {
                        statisticList[i].usage = statisticList[i].usage + 1; 
                    }
                }
                
                i = i + 1 ;
            }
            
        }
    }

    public void finish(Database.BatchableContext bc)
    {
        Integer i = 0;

        for(String fieldName : fieldMap.keyset())
        {
            if (allCount == 0) {
				statisticList[i].usage =  0;                    
            } else if(statisticList[i].usage == 0) 
            {
            	statisticList[i].usage =  100;  
            } else {
            	statisticList[i].usage = (statisticList[i].usage/allCount)*100;
            }

            i = i + 1 ;
        }
        
        String jsonBody = '';
               
        if(errors.isEmpty())
        {
            ResultData result = new ResultData(true, null, statisticList);
            jsonBody = JSON.serialize(result);
        } else {
            ResultData result = new ResultData(false, JSON.serialize(errors), null);
            jsonBody = JSON.serialize(result);
        }

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Accept-Encoding', 'gzip,deflate');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Content-Length', String.valueOf(jsonBody.length()));
        req.setEndpoint(endPoint);
      
        System.debug('Input Request:' + jsonBody);
        req.setBody(jsonBody);
      
        Http http = new Http();
        HTTPResponse res = http.send(req); 
	}    
}
