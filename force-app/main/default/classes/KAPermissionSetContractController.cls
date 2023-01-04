public class KAPermissionSetContractController {
    public void permissionSetAssigner(List<Contract> contracts){
        
        Map<Id, Set<String>> permissionMapAccountToProduct = new Map<Id, Set<String>>();
        List<Account> accList = new List<Account>();
        
        // Contract List
        List<Contract> conList = new List<Contract>([
            SELECT Id, AccountId 
            From Contract 
            Where Id In :contracts
        ]);
        
        // Contract to Product Map
        Map<Id, Set<String>> permissionMapContractToProduct = KAPermissionSetHelper.getProductsOfContractList(conList);
        system.debug(permissionMapContractToProduct);
        
        //Mapping Account to Product
        for(Contract contract: conList) {
            // Mapping Account to Products Set
            if(permissionMapContractToProduct.get(contract.Id)!=null) { permissionMapAccountToProduct.put(contract.AccountId, new Set<String>(permissionMapContractToProduct.get(contract.Id)));
        	
            //Creating accList
        	accList.add(new Account(Id= contract.AccountId));
                                                                      }
        }
        
        system.debug(accList);
        
        List<User> users = KAPermissionSetHelper.getCommunityUsersRelatedToAccountList(accList);
        
        system.debug(users);
        system.debug(permissionMapAccountToProduct);

        KAPermissionSetHelper.assignPermissionSetOfAccountMapToUserList(permissionMapAccountToProduct ,users);        
    }
}