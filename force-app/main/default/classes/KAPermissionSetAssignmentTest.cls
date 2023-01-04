@isTest
public class KAPermissionSetAssignmentTest {
	@isTest
    static void dataCreator() {
        
        Product2 prod= new Product2(
            Name='MortgageJunction test',
            IsActive=True            
        );
        insert prod;
        
        /*Pricebook2 pricebook= new Pricebook2(
            Name='Standard Pricebook',
            IsActive=True
        );
        insert pricebook;
        
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
		*/
        Id pricebookId = Test.getStandardPricebookId();
			Pricebook2 standardPricebook = new Pricebook2(
    		Id = pricebookId,
    		IsActive = true
		);
		update standardPricebook;
        
        PricebookEntry	pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id= prod.Id,
            UnitPrice=1000,
            IsActive=True
        );
        insert pbe;
        
        
        Account acc = new Account(
            Name= 'Test Account'
        );
        insert acc;
        
        Contract con = new Contract(
            Status='Draft',
            AccountId=acc.Id,
            
       
            StartDate= Date.newInstance(1960, 2, 17),
            ContractTerm=12
        );
        insert con;
        
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c(
            SBQQ__Account__c= acc.Id,
            SBQQ__Contract__c= con.Id,
            SBQQ__Quantity__c = 1,
            SBQQ__Product__c= prod.Id	
        );
        insert sub;
        
        con.Status='Activated';
        update con;            

        Id profileId = [Select Id From Profile Where Name = 'Community Customer Contact (Custom)' LIMIT 1].Id;
        Contact contact = new Contact(LastName ='testCon',AccountId = acc.Id);
        insert contact;


        User communityUser = new User(FirstName = 'Test', LastName = 'User',
                                  Email = 'test.user@invalid.com',
                                  ContactId = contact.Id,
                                  ProfileId = profileId, UserName =  'tuserstest-user@fakeemail.com',
                                  Alias = 'tuser1', CommunityNickName = 'tusers', TimeZoneSidKey = 'America/New_York',
                                  LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US', isActive = True
                                  );
    	insert communityUser;
        
	}
}