trigger KAPermissionSetUserTrigger on User (after insert, after update) {
	List<User> users = new List<User>([Select id, AccountId, IsActive from User where IsActive= true AND Id in :Trigger.New AND profile.name='Community Customer Contact (Custom)']);
    List<User> usersToUpdate = new List<User>();
    
    
    List<Account> accs = new List<Account>();
    List<Contract> cons = new List<Contract>();
    Map<Id, Set<String>> permissionMapAccountToProduct = new Map<Id, Set<String>>();

    if(Trigger.isUpdate){
    	for(User user: users) {
        
        	if(Trigger.newMap.get(user.Id).IsActive == True || Trigger.newMap.get(user.Id).profile.name == 'Community Customer Contact (Custom)'){
        		usersToUpdate.add(user);
            
            	accs.add(new Account(Id=user.AccountId));
       
        	}
    	}
    }
    if(Trigger.isInsert){
        for(User user: users) {
        
        if(Trigger.newMap.get(user.Id).IsActive == True || Trigger.newMap.get(user.Id).profile.name == 'Community Customer Contact (Custom)'){
        	usersToUpdate.add(user);
            
            accs.add(new Account(Id=user.AccountId));
       
        }
    }
    }
    
    cons= [Select id, AccountId, Status FROM Contract WHERE accountId in :accs AND Status ='Activated' ];
    
    Map<Id, Set<String>> permissionMapContractToProduct = KAPermissionSetHelper.getProductsOfContractList(cons);
    
    for(Contract contract:cons) {
            // Mapping Account to Products Set
            if(permissionMapContractToProduct.get(contract.Id)!=null) { 
                permissionMapAccountToProduct.put(contract.AccountId, 
                                                  new Set<String>(permissionMapContractToProduct.get(contract.Id))); 
		}      
    }
    KAPermissionSetHelper.assignPermissionSetOfAccountMapToUserList(permissionMapAccountToProduct, users);  
}