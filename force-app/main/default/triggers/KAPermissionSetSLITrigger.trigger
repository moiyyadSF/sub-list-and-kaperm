trigger KAPermissionSetSLITrigger on SBQQ__Subscription__c (after insert, after update) {
    
    List<Contract> contracts = new List<Contract>();

	// Gathering Asset and Mortgage Junction SLIs    
    List<SBQQ__Subscription__c> subList = new List<SBQQ__Subscription__c>([SELECT Id,  SBQQ__ProductName__c, SBQQ__Contract__c, SBQQ__Contract__r.Status 
																			FROM SBQQ__Subscription__c 
																			WHERE SBQQ__Contract__r.Status='Activated' AND 
                                                                           		(SBQQ__ProductName__c LIKE '%AssetJunction%' OR 
                                                                                SBQQ__ProductName__c LIKE '%MortgageJunction%' OR
                                                                               	SBQQ__ProductName__c LIKE '%Asset Junction%' OR 
                                                                                SBQQ__ProductName__c LIKE '%Mortgage Junction%'
                                                                                )                                                                         
                                                                          ]);
    
    for(SBQQ__Subscription__c subscription:subList) {
        contracts.add(new Contract(Id = subscription.SBQQ__Contract__c));
    }
    
    //Initializing a Controller Class
    KAPermissionSetContractController kacontroller = new KAPermissionSetContractController();
    
    // Passing activated Contracts to Controller Class
    if(contracts.size() > 0) kacontroller.permissionSetAssigner(contracts);
}