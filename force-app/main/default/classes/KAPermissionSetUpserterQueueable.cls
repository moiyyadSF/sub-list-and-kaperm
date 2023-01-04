/*
 * 
 * This Class is upserting Permissions Set Assignments for the KAPermissionSetHelper Class
 * 
 * This is a Queueable Class because Permission Sets are a setup object
 * and must be upserted asynchronously
 * 
 */

public class KAPermissionSetUpserterQueueable implements Queueable{
    
    List<PermissionSetAssignment> psa;
    
    public KAPermissionSetUpserterQueueable (List<PermissionSetAssignment> psa )
    {
        this.psa = psa ;
    }
    
    public void execute(QueueableContext context)
    {
        upsert psa;
    }
}