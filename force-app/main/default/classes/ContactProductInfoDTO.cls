/**
 * DTO for Contact Product Info API response.
 * Maps Salesforce fields to external API field names.
 *
 * @author Carlos Martínez Pérez
 * @created 2025-08-04
 */
public class ContactProductInfoDTO {
    public String CRMContactId;
    public String Home_Country;
    public String Country_Code;
    public String Currency_Code;
    public String Currency_Symbol;
    public String Plan_Type;
    public Decimal Cost_per_Calendar_Month;
    public Boolean Is_Not_Applicable_Monthly_Cost;
    public Decimal ATM_Fee;
    public Boolean Is_Free_ATM_Fee;
    public Decimal Card_Replacement_Cost;

    public ContactProductInfoDTO(Contact contact, Customer_Product_Info_Config__mdt config) {
        this.CRMContactId = contact.Id;
        this.Home_Country = contact.Home_Country__c;
        this.Country_Code = (String)config.get('Country_Code__c');
        this.Currency_Code = (String)config.get('Currency_Code__c');
        this.Currency_Symbol = (String)config.get('Currency_Symbol__c');
        this.Plan_Type = contact.Product__c;
        this.Cost_per_Calendar_Month = (Decimal)config.get('Monthly_Cost__c');
        this.Is_Not_Applicable_Monthly_Cost = (Boolean)config.get('Is_Not_Applicable_Monthly_Cost__c');
        this.ATM_Fee = (Decimal)config.get('ATM_Fee__c');
        this.Is_Free_ATM_Fee = (Boolean)config.get('Is_Free_ATM_Fee__c');
        this.Card_Replacement_Cost = (Decimal)config.get('Card_Replacement_Cost__c');
    }
}
