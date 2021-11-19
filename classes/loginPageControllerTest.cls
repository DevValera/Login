@isTest
private class loginPageControllerTest {
    @TestSetup
    static void makeData(){
        UserInfo__c user = new UserInfo__c(Name='Testing',Password__c = '794613',Email__c = 'test@gmail.com');
        insert user;
		Boolean state = true;
    }

    
}