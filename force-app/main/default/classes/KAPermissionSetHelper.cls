/*
 * Made By: Moiyyad
 * 
 * ADT:
 * 
 * KAPermissionSetHelper{
 *      //Get All Product Names related to Contract
 * 		public static Map<Id, Set<String>> getProductsOfContractList(List<Contract> contracts){}		
 *      
 *      //Get All Contacts/Users related to Account
 * 		public static List<User> getCommunityUsersRelatedToAccountList(List<Account>){}					
 * 
 *      //Get All KA Permission Sets related to SLI List
 * 		public static void assignPermissionSetOfAccountMapToUserList(Map<Id, Set<String>>,List<User>){} 
 * }
 * 
 */

public class KAPermissionSetHelper{
    //public static List<SBQQ__Subscription__c> getSLIofContractsMap(Map<Contract, SBQQ__Subscription__c>){}
    
    public static Map<Id, Set<String>> getProductsOfContractList(List<Contract> contracts){
        system.debug(contracts);
        
        Map<Id, Set<String>> contractProductMapping = new Map<Id, Set<String>>();
        
        //Get all Subscription Names of Subscription Items
        List<SBQQ__Subscription__c> subList = new List<SBQQ__Subscription__c>(
            [SELECT Id, SBQQ__Contract__c, SBQQ__Product__r.Name
             FROM SBQQ__Subscription__c 
             WHERE SBQQ__Contract__c IN :contracts]
        );
        system.debug(subList);
        
        //ForEach Subscription
        for(SBQQ__Subscription__c sub: subList) {
            if(!contractProductMapping.containsKey(sub.SBQQ__Contract__c)) contractProductMapping.put(sub.SBQQ__Contract__c, new Set<String>());
            
            //If Contract has AssetJunction
            if(sub.SBQQ__Product__r.Name.contains('AssetJunction') || sub.SBQQ__Product__r.Name.contains('Asset Junction')) {
                //Add AssetJunction to the Set
                contractProductMapping.get(sub.SBQQ__Contract__c).add('AssetJunction');
            }
            
            //If Contract has MortgageJunction
            else if(sub.SBQQ__Product__r.Name.contains('MortgageJunction') || sub.SBQQ__Product__r.Name.contains('Mortgage Junction')) {
                //Add MortgageJunction to the Set
                contractProductMapping.get(sub.SBQQ__Contract__c).add('MortgageJunction');
            }
        }   
        return contractProductMapping;     
    }


	public static List<User> getCommunityUsersRelatedToAccountList(List<Account> accList){
    
    	List<User> users = new List<User>([
            SELECT Id, Name, Profile.Name, AccountId, Account.Name 
            FROM User 
            Where Profile.Name = 'Community Customer Contact (Custom)' and AccountId In :accList

        ]);
        return users;
	}
    
    public static void assignPermissionSetOfAccountMapToUserList(Map<Id, Set<String>> AccountMapping,List<User> users){
        
        // Get Ids of MJ and AJ Data Category Permission Sets List
        List<PermissionSet> permissionsList = new List<PermissionSet>([SELECT Id, Name 
                                                                       FROM PermissionSet 
                                                                       WHERE Name LIKE '%AssetJunction_Data_Categories%'
                                                                       		OR Name LIKE '%MortgageJunction_Data_Categories%'
                                                                      ]);
        system.debug(permissionsList);
        
        Id mjPsetId; Id ajPsetId;
        
        
        
        if(permissionsList[0].Name == 'AssetJunction_Data_Categories') { ajPsetId =permissionsList[0].id; mjPsetId= permissionsList[1].id;}
        else{ ajPsetId =permissionsList[1].id; mjPsetId= permissionsList[0].id; }
        
        // Initializing variable for Permission set assignments
        List<PermissionSetAssignment> permissionsAssignmentList = new List<PermissionSetAssignment>();
        
        Map<Id,List<PermissionSetAssignment>> existingPermAssignments = new Map<Id,List<PermissionSetAssignment>>();
        List<User> tempUsersList =    [select Id,(select AssigneeId, PermissionSetId from PermissionSetAssignments where permissionsetId =:ajPsetId Or permissionsetId =:mjPsetId ) from user where Id in :users];
        for(User u: tempUsersList) {
			existingPermAssignments.put(u.Id, u.PermissionSetAssignments);         
        }
        
        system.debug(AccountMapping);
        system.debug(users);
        system.debug(existingPermAssignments);
        
        // For each user
        for(User user: users) {
            Boolean flag = False;
            
            // If the User has purchased AssetJunction then assign them AssetJunction Data Categories
            if(AccountMapping.get(user.AccountId).contains('AssetJunction')) {
                flag = True;
            	for(PermissionSetAssignment psa : existingPermAssignments.get(user.Id) ) {
                	if(psa.PermissionSetId == ajPsetId) flag = False;
            	}
            }  
            if(flag==True) {
                permissionsAssignmentList.add(new PermissionSetAssignment(
                    PermissionSetId = ajPsetId, AssigneeId = user.Id
                ));
            }
            
            flag = False;
            // If the User has purchased MorgageJunction then assign them MortgageJunction Data Categories
            if(AccountMapping.get(user.AccountId).contains('MortgageJunction')) {
                flag = True;
            	for(PermissionSetAssignment psa : existingPermAssignments.get(user.Id) ) {
                	if(psa.PermissionSetId == mjPsetId) flag = False;
            	}
            }
            if(flag==True) {
                permissionsAssignmentList.add(new PermissionSetAssignment(
                    PermissionSetId = mjPsetId, AssigneeId = user.Id
                ));
            }
            
        }
        
       System.enqueuejob(new KAPermissionSetUpserterQueueable(permissionsAssignmentList));

       
        system.debug(permissionsAssignmentList);

        
        return;
    }
    
    
    
}