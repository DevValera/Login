public  class loginPageController {
    public String username {get;set;}
    public String password {get;set;}
    public String email {get;set;}
    public String name {get;set;}
    public Boolean admin {get;set;}
    public String nameAttachment {get;set;}
    public String descriptionAttachment {get;set;}
    public UserInfo__c newUser {get;set;}
    public Boolean state {get;set;}
    public UserInfo__c user {get;set;}
    public Boolean showEdit {get;set;}
    Pagereference redirectPage = new Pagereference('/apex/UserInfoPage');
    Pagereference currentPage = ApexPages.currentPage();
    public Pagereference previousPage = new Pagereference('/apex/LogInPage');

    public loginPageController() {
        this.newUser = new UserInfo__c();
        this.state = true;
        this.showEdit = false;
    }

    public Pagereference logUp() {
        if(username == '' || password == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Fill in all the fields!')); 
            return currentPage;
        }

        user = [SELECT  ID, Email__c, Name__c, Login__c, OwnerId, Password__c, Admin__c 
                FROM UserInfo__c WHERE (Login__c = :username  OR Email__c = :username)];

        if(user == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid login or create acc before log in!')); 
            return currentPage;
        }else if(user.Password__c != password){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Wrong password!')); 
            return currentPage;
        } else {
            return redirectPage.setRedirect(false);
        }      
    } 
    
    public Boolean getStateStatus(){
        return state;
    }
	
    public Pagereference signUp(){
        if(String.isBlank(username) || String.isBlank(email) || String.isBlank(password)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Fill in all the fields!'));
            return currentPage;
        } else if ([SELECT Login__c FROM UserInfo__c WHERE Login__c = :username].size() == 1) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'This Login is already exists!'));
            return currentPage;
        } else {
            user = new UserInfo__c(Name = username, Email__c = email, Password__c = password, Login__c = username,
                                      Name__c = name, Admin__c = admin);
            insert user;
            return redirectPage;
        }
       
    }
    
    public Pagereference logOut(){
        return previousPage.setRedirect(true);
    }
    public List<Attachment__c> getAttachment(){
        if(user.Admin__c == true){
            List<Attachment__c> attachmentList = [SELECT Name, Description__c, UserInfo__c FROM Attachment__c];
            System.debug(attachmentList[0]);
            return attachmentList;
        }
        List<Attachment__c> attachmentList = [SELECT Name,Description__c,UserInfo__c FROM Attachment__c
                                              WHERE UserInfo__c =:user.Id];
        return attachmentList;
    }
    
    public Boolean getEditStatus(){
        return showEdit;
    }
    
    public void editAccount(){
        showEdit = true;
    }
    
    public void saveAttachment(){
        Attachment__c attachment = new Attachment__c(Name = nameAttachment, Description__c = descriptionAttachment, 
                                                  UserInfo__c = user.Id);
        insert attachment;
    }
    
 	
    public void saveUser(){
        if(String.isBlank(name)){
            name = user.Name__c;
        } else if(String.isBlank(username)){
            username = user.Login__c;
        } else if(String.isBlank(email)){
            email = user.Email__c;
        }
        user.Name = username;
    	user.Name__c = name;    
        user.Login__c = username;
        user.Email__c = email;
        showEdit = false;
        update user;
    }
    
    public void signIn(){
        state = false;
    }
    public void logIn(){
        state = true;
    }
}