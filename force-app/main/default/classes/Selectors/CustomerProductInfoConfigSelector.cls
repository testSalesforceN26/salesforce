/**
 * Selector class for retrieving and managing Customer_Product_Info_Config__mdt metadata.
 * Implements the IGenericMetadataSelector interface to provide standardized selection logic.
 *
 * This class is designed to encapsulate queries and operations related to Customer_Product_Info_Config__mdt records,
 * ensuring consistent access patterns and sharing rules.
 *
 * @author Carlos Martínez Pérez
 * @created 2025-08-01
 */
global virtual with sharing class CustomerProductInfoConfigSelector implements IGenericMetadataSelector {

    // fields to query from metadata
    public static final List<String> METADATA_CONFIG_FIELD = new List<String>{
        'MasterLabel',
        'Product__c',
        'Country_Name__c',
        'Country_Code__c',
        'Currency_Code__c',
        'Currency_Symbol__c',
        'Monthly_Cost__c',
        'Is_Not_Applicable_Monthly_Cost__c',
        'ATM_Fee__c',
        'Is_Free_ATM_Fee__c',
        'Card_Replacement_Cost__c'
    };
   
    /**
     * Retrieves a Customer_Product_Info_Config__mdt record by its DeveloperName.
     *
     * @param developerName The DeveloperName of the Customer_Product_Info_Config__mdt record to retrieve.
     * @return The Customer_Product_Info_Config__mdt record matching the specified DeveloperName, or null if not found.
     */
    public Customer_Product_Info_Config__mdt getByDeveloperName(String developerName) {
        List<Customer_Product_Info_Config__mdt> results = (List<Customer_Product_Info_Config__mdt>) new QueryBuilder()
            .setSObject('Customer_Product_Info_Config__mdt')
            .selectFields(METADATA_CONFIG_FIELD)
            .addWhereClause('DeveloperName = \'' + developerName + '\'')
            .setLimit(1)
            .execute();
        return results.isEmpty() ? null : results[0];
    }


    
    /**
     * Retrieves the Customer Product Info Config custom metadata record for a given product and country.
     *
     * @param product The name or identifier of the product.
     * @param country The name or code of the country.
     * @return Customer_Product_Info_Config__mdt The matching custom metadata record, or null if not found.
     */
    global virtual Customer_Product_Info_Config__mdt getProductInfoByProductCountry(String product, String country) {

        List<Customer_Product_Info_Config__mdt> configs = (List<Customer_Product_Info_Config__mdt>) new QueryBuilder()
            .setSObject('Customer_Product_Info_Config__mdt')
            .selectFields(METADATA_CONFIG_FIELD)
            .addWhereClause('Product__c = \'' + product + '\'')
            .addWhereClause('Country_Name__c = \'' + country + '\'')
            .setLimit(1)
            .execute();

        if (!configs.isEmpty()) {
            return configs[0];
        }
        return null;
    }
}
