@isTest
public class SubscriptionListControllerTest {
@isTest
    public static void testInit(){
        Id uid = UserInfo.getUserId();
        SubscriptionListController.getSubscriptions(uid);
    }
}