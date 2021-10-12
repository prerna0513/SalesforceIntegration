public class GetAccountUsingRESTAPI {
    private final String clientId = '3MVG9pRzvMkjMb6nVEmKFiGhe5_g44YZlvGlKuWfme6arZbSErAs0pNwnM5XOkgfYmwmQxrdbx.posHdKMuSP';
    private final String clientSecret = 'F6F5B6BA106638D3DC4AB68ECD1A8D82B8A3495292A65EA7EE00D0398A79C63B';
    private final String username = 'prerna@ama.com';
    private final String password = 'testing13$';
    private final String endpoint='https://amacom-dev-ed.my.salesforce.com/services/oauth2/token';

    public class deserializeResponse
    {
        public String id;
        public String access_token;
    }
    public String ReturnAccessToken (GetAccountUsingRESTAPI acount)
    {
        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
        Httprequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setBody('grant_type=password' + '&client_id='+clientId + 
            '&client_secret='+clientSecret + '&username='+username + '&password='+password);

        request.setBody(reqbody);
        request.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId()); 
        system.debug('request:::'+request.getbody());
        Http http = new Http();
        HttpResponse res;
        try{
            res = http.send(request);
            System.debug(res.toString());
            System.debug('STATUS:'+res.getStatus());
            System.debug('STATUS_CODE:'+res.getStatusCode());
            System.debug('Content: ' + res.getBody());
        }
        catch(System.CalloutException ex){
            system.debug('EXCEPTION::'+ex.getMessage());
        }
        
        deserializeResponse response = (deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);
        system.debug('@@@@access_token@@'+response);
        return response.access_token;
    }
    public static List<accountWrapper> callGetAccount(String accName)
    {
        GetAccountUsingRESTAPI acount1 = new GetAccountUsingRESTAPI();
        List<accountWrapper> accDataList = new List<accountWrapper>();
        String accessToken;
        accessToken = acount1.ReturnAccessToken(acount1);
        list<account> ListAccount=new List<account>();
        if(accessToken != null) {
            String endPoint = 'https://amacom-dev-ed.my.salesforce.com/services/apexrest/v1/getAccounts/'+accName;
            Http h2 = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer ' +accessToken);
                req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setMethod('GET');
            req1.setEndpoint(endPoint);
            system.debug('REQUEST:::'+req1.getEndpoint());
            HttpResponse res1 = h2.send(req1);
            System.debug(res1.toString());
            System.debug('STATUS 66:'+res1.getStatus());
            System.debug('STATUS_CODE 67:'+res1.getStatusCode());
            System.debug('Content 68: ' + res1.getBody());
            
            String trimmedResponse = res1.getBody().unescapeCsv().remove('\\');
            system.debug('@@@RESPONSE@@'+trimmedResponse);
            JSONParser parser = JSON.createParser(res1.getBody());
            system.debug('parser:::'+parser);
            List<accountWrapper> accList=new List<accountWrapper>();
            
            
            system.debug('AccountList@@@@'+(List<accountWrapper>) JSON.deserialize(trimmedResponse,List<accountWrapper>.class));
            accDataList = (List<accountWrapper>) JSON.deserialize(trimmedResponse,List<accountWrapper>.class);
        }
        return accDataList;
    }
    
    
    
}