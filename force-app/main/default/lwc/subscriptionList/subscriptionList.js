import { LightningElement, wire, track } from 'lwc';
import getSubscriptions from '@salesforce/apex/SubscriptionListController.getSubscriptions';
//import userId from '@salesforce/user/Id';
const columns = [
    { label: 'Name', fieldName: 'name' },
    { label: 'Subsciption Line Item Name', fieldName: 'productname' },
    { label: 'Subscription Start Date', fieldName: 'start' },
    { label: 'Subscription End Date', fieldName: 'end' }

];


export default class SubscriptionList extends LightningElement {
    columns=columns;
    @track data=[];
@wire(getSubscriptions)
wiredData({ error, data }) {
    if (data) {
        let newdata =[];
        
        //console.log(element.SBQQ__Product__r.Name);
        data.forEach(element => {
            let newdataline = {};
            newdataline.productname = element.SBQQ__Product__r.Name;
            newdataline.start = element.SBQQ__SubscriptionStartDate__c;
            newdataline.end = element.SBQQ__SubscriptionEndDate__c;
            newdataline.name = element.Name;

            newdata.push(newdataline);
        });
        this.data = newdata;

  } else if (error) {
    console.error('Error:', error);
  }

}


}