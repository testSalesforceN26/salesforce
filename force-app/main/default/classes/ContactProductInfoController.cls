/**
 * Controller class for managing and retrieving product information related to Contacts.
 * This class enforces sharing rules and provides methods to interact with Contact and Product data.
 *
 * @author Carlos Martínez Pérez
 * @created 2025-08-03
 */
public with sharing class ContactProductInfoController {

    // selectors for querying Contact and Case records
    private ContactSelector contactRepository;
    private CaseSelector caseRepository;
    private CustomerProductInfoConfigSelector metadataRepository;

    // Default constructor
    public ContactProductInfoController() {
        contactRepository = new ContactSelector();
        caseRepository = new CaseSelector();
        metadataRepository = new CustomerProductInfoConfigSelector();
    }


    // Constructor for dependency injection 
    public ContactProductInfoController(ContactSelector contactRepository, CaseSelector caseRepository, CustomerProductInfoConfigSelector metadataRepository) {
        this.contactRepository = contactRepository;
        this.caseRepository = caseRepository;
        this.metadataRepository = metadataRepository;
    }

    /**
     * Fetches contact product information for a specific Case Id.
     *
     * @param caseId The Id of the Case for which to fetch contact product information.
     * @return A map containing product information associated with the contact.
     * @AuraEnabled(cacheable=true) Allows this method to be called from Lightning components and enables caching.
     */

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getContactProductInfo(Id caseId) {
        ContactProductInfoController instance = new ContactProductInfoController();
        return instance.getContactProductInfoInternal(caseId);
    }


    /**
     * Retrieves product information related to a contact based on the provided Case Id.
     *
     * @param caseId The Id of the Case for which contact product information is requested.
     * @return A map containing product information associated with the contact, if will have information
     *         of the contact, metadata info (config) and labels for the fields in the metadata to be displayed.
     */
    public Map<String, Object> getContactProductInfoInternal(Id caseId) {
        // result map to be returned
        Map<String, Object> result = new Map<String, Object>();

        // retrieve case
        Case caseInfo = caseRepository.getById(caseId);
        if (caseInfo == null || caseInfo.ContactId == null) {
            result.put(ContactProductInfoConstants.ERROR, ContactProductInfoConstants.CASE_CONTACT_NOT_FOUND_ERROR);
            return result;
        }
        // retrieve contact information and put it in the result map
        Contact contactInfo = contactRepository.getById(caseInfo.ContactId);
        if(contactInfo.Product__c == null || contactInfo.Home_Country__c == null) {
            result.put(ContactProductInfoConstants.ERROR, ContactProductInfoConstants.CONTACT_INFO_MISSING_ERROR);
            return result;
        }
        result.put('contact', contactInfo);

        // get metadata configuration for the product and country
        Customer_Product_Info_Config__mdt configRecord = metadataRepository.getProductInfoByProductCountry(
            contactInfo.Product__c, contactInfo.Home_Country__c
        );

        if(configRecord == null) {
            result.put(ContactProductInfoConstants.ERROR, ContactProductInfoConstants.NO_CONFIG_ERROR);
            return result;
        }
        // map with fieldDeveloperName as key and label as value
        Map<String, String> fieldLabelsByDeveloperName = new Map<String, String>();

        // get all the metadata fields
        Map<String, SObjectField> fields = Customer_Product_Info_Config__mdt.SObjectType.getDescribe().fields.getMap();
    
        // Populate field labels for the metadata configuration
        for (String fieldDeveloperName : fields.keySet()) {
            fieldLabelsByDeveloperName.put(fieldDeveloperName, fields.get(fieldDeveloperName).getDescribe().getLabel());
        }

        result.put('config', configRecord);
        result.put('fieldLabels', fieldLabelsByDeveloperName);

        return result;
    }
}
