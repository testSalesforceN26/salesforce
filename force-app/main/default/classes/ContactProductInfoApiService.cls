/**
 * REST API service for external systems to retrieve contact product information by external UUID.
 * Returns the same data as ContactProductInfoController.getContactProductInfoInternal, but uses externalId.
 *
 * @author Carlos Martínez Pérez
 * @created 2025-08-04
 */
@RestResource(urlMapping='/contactProductInfo/*')
global with sharing class ContactProductInfoApiService {

    // Static variables for dependency injection in tests
    public static ContactSelector contactSelectorInstance;
    public static CustomerProductInfoConfigSelector configSelectorInstance;
    /**
     * HTTP GET method to retrieve contact product information by externalId.
     * This method is called when an external system makes a GET request to the API.
     */
    @HttpGet
    global static void getContactProductInfoByExternalId() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String externalId = req.params.get('externalId');
        // Use injected selectors if set, otherwise real ones
        ContactSelector contactSelector = (contactSelectorInstance != null) ? contactSelectorInstance : new ContactSelector();
        CustomerProductInfoConfigSelector configSelector = (configSelectorInstance != null) ? configSelectorInstance : new CustomerProductInfoConfigSelector();
        Map<String, Object> result = getContactProductInfoByExternalIdInternal(externalId, contactSelector, configSelector);
        res.statusCode = (result.containsKey(ContactProductInfoConstants.ERROR)) ?
                            ContactProductInfoConstants.HTTP_STATUS_BAD_REQUEST :
                            ContactProductInfoConstants.HTTP_STATUS_OK;

        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }

    // Instance method for business logic and testability
    global static Map<String, Object> getContactProductInfoByExternalIdInternal(
        String externalId,
        ContactSelector contactSelector,
        CustomerProductInfoConfigSelector configSelector
    ) {
        Map<String, Object> result = new Map<String, Object>();
        if (String.isBlank(externalId)) {
            result.put(ContactProductInfoConstants.ERROR, ContactProductInfoConstants.MISSING_EXTERNALID_ERROR);
            return result;
        }
        Contact contactInfo = contactSelector.getByExternalId(externalId);
        if (contactInfo == null) {
            result.put(ContactProductInfoConstants.ERROR, ContactProductInfoConstants.NO_CONTACT_ERROR);
            return result;
        }
        Customer_Product_Info_Config__mdt configRecord = configSelector.getProductInfoByProductCountry(contactInfo.Product__c, contactInfo.Home_Country__c);
        if (configRecord != null) {
            // Build DTO for external API response
            ContactProductInfoDTO dto = new ContactProductInfoDTO(contactInfo, configRecord);
            result.put('ContactProductInfo', dto);
        } else {
            result.put(ContactProductInfoConstants.ERROR, ContactProductInfoConstants.NO_CONFIG_ERROR);
        }
        return result;
    }
}
