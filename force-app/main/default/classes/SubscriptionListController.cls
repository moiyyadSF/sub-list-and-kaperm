public without sharing class SubscriptionListController {
@AuraEnabled(cacheable=true)

public static List<SBQQ__Subscription__c> getSubscriptions(String userId) {

  Id uid = UserInfo.getUserId();
  
  String strKey = userId;
  User userList = [SELECT Id,ContactId, AccountId 
                    FROM User WHERE Id = :uid  
                    LIMIT 1];

  List<SBQQ__Subscription__c> activeSubs = [SELECT Id, SBQQ__Contract__r.AccountId, SBQQ__Product__r.name, SBQQ__SubscriptionStartDate__c, SBQQ__SubscriptionEndDate__c, Name  
                                            FROM SBQQ__Subscription__c 
                                            WHERE SBQQ__Contract__r.AccountId = :userList.AccountId];
   return activeSubs;
 }

}