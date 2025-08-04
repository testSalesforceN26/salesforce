import { LightningElement, api, wire } from 'lwc';
import getContactProductInfo from '@salesforce/apex/ContactProductInfoController.getContactProductInfo';

export default class ContactProductInfo extends LightningElement {
    @api recordId;
    data;
    error;

    // wire service to fetch contact product info based on caseId
    @wire(getContactProductInfo, { caseId: '$recordId' })
    wiredInfo({ error, data }) {
        if (data) {
            this.data = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }

    // getters to access data from the wire service
    // get config from the metadata
    get config() {
        return this.data?.config || {};
    }
    // get field labels from the metadata
    get fieldLabels() {
        console.log('fieldLabels:' + JSON.stringify(this.data?.fieldLabels || {}));
        return this.data?.fieldLabels || {};
    }
    // getters for specific fields
    get product() {
        return this.config.Product__c ? this.config.Product__c : '';
    }
    get country() {
        return this.config.Country_Name__c ? this.config.Country_Name__c : '';
    }
    // get for monthly cost whith currency when applicable, otherwise return 'N/A'
    get monthlyCost() {
        if (this.config.Is_Not_Applicable_Monthly_Cost__c) {
            return 'N/A';
        }
        return this.config.Monthly_Cost__c != null ? this.config.Monthly_Cost__c + ' ' + this.config.Currency_Symbol__c : '';
    }
    // get for ATM fee with currency when is not free, otherwise return 'Free'
    get atmFee() {
        if (this.config.Is_Free_ATM_Fee__c) {
            return 'Free';
        }
        return this.config.ATM_Fee__c != null ? this.config.ATM_Fee__c + ' %' : '';
    }
    // get for card replacement cost with currency 
    get cardReplacementCost() {
        return this.config.Card_Replacement_Cost__c != null ? this.config.Card_Replacement_Cost__c +' ' + this.config.Currency_Symbol__c : '';
    }
}