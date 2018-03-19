global class GoogleChatWebhook {
    
    global class GoogleChatData {
        @InvocableVariable
        public String webhookUrl;
        @InvocableVariable
        public Id accountId;
        @InvocableVariable
        public String accountName;
        @InvocableVariable
        public String accountNo;
    }
    
    @InvocableMethod
    public static void sendChat(List<GoogleChatData> chatData) {
        for (Integer i=0;i<chatData.size();i++) {
            sendOutputMessageToRoom(chatData.get(i).webhookUrl,
                                    chatData.get(i).accountId, 
                                    chatData.get(i).accountName,
                                    chatData.get(i).accountNo);
        }
    }
    
    @future(callout=true)
    public static void sendOutputMessageToRoom(String webhookUrl,
                                               String accountId,
                                               String accountName,
                                               String accountNo) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(webhookUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        String url = System.Url.getSalesforceBaseUrl().toExternalForm();
        String accountUrl = url + '/lightning/r/Account/' + accountId + '/view'; // Using the new URL format!
        
        String message = '{"cards":[{"header":{"title":"Salesforce Account alert","subtitle":"via Webhooks"},"sections":[{"widgets":[{"keyValue":{"topLabel":"Account No.","content":"' + accountNo + '"}},{"keyValue":{"topLabel":"Account Name","content":"' + accountName + '"}}]},{"widgets":[{"buttons":[{"textButton":{"text":"Open Account record","onClick":{"openLink":{"url":"' + accountUrl + '"}}}}]}]}]}]}';
        
        req.setBody(message);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
    
}