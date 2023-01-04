trigger KAPermissionSetContractTrigger on Contract (after insert, after update) {
    
    List<Contract> contractsRemoved= new List<Contract>();
    List<Contract> contractsActivated = new List<Contract>();

    if(Trigger.isUpdate){
    // For all Contract
    	for(Contract c : Trigger.new){
        
        //Collecting all Contracts that were deactivated
        
        	if(c.Status != Trigger.oldMap.get(c.Id).Status && Trigger.oldMap.get(c.Id).Status == 'Activated') {
            contractsRemoved.add(c);
        	}
        
        
        //Collecting all Contracts that were activated
        //
        	if(c.Status != Trigger.oldMap.get(c.Id).Status && c.Status == 'Activated') {
            contractsActivated.add(c);
        	}
    	}
    }
    
    if (Trigger.isInsert){
        for(Contract c : Trigger.new){
        
        //Collecting all Contracts that were deactivated
        
        if(c.Status != 'Activated') {
            contractsRemoved.add(c);
        }
        
        
        //Collecting all Contracts that were activated
        //
        if(c.Status == 'Activated') {
            contractsActivated.add(c);
        }
    }
    }
    
    
    system.debug(contractsActivated);
    
    //Initializing a Controller Class
    KAPermissionSetContractController kacontroller = new KAPermissionSetContractController();
    
    // Passing activated Contracts to Controller Class
    if(contractsActivated.size() > 0) kacontroller.permissionSetAssigner(contractsActivated);
    
}