/**
 * Unit tests for ContactProductInfoApiService
 *
 * @author Carlos Martínez Pérez
 * @created 2025-08-04
 */
@IsTest
global class ContactProductInfoApiServiceTest {
    @IsTest
    static void testMissingExternalId() {
        // Arrange
        ContactSelector contactSelector = new ContactSelectorMock();
        CustomerProductInfoConfigSelector configSelector = new CustomerProductInfoConfigSelectorMock();
        // Act
        Map<String, Object> result = ContactProductInfoApiService.getContactProductInfoByExternalIdInternal(
            '', contactSelector, configSelector);
        // Assert
        System.assertEquals(ContactProductInfoConstants.MISSING_EXTERNALID_ERROR, result.get(ContactProductInfoConstants.ERROR));
    }

    @IsTest
    static void testNoContactFound() {
        // Arrange
        ContactSelector contactSelector = new ContactSelectorMock();
        CustomerProductInfoConfigSelector configSelector = new CustomerProductInfoConfigSelectorMock();
        // Act
        Map<String, Object> result = ContactProductInfoApiService.getContactProductInfoByExternalIdInternal(
            'externalIdNotFound', contactSelector, configSelector);
        // Assert
        System.assertEquals(ContactProductInfoConstants.NO_CONTACT_ERROR, result.get(ContactProductInfoConstants.ERROR));
    }

    @IsTest
    static void testNoConfigFound() {
        // Arrange
        Id contactId = TestDataUtil.generateId(Contact.sObjectType);
        Contact contact = new ContactBuilder()
            .withId(contactId)
            .withProduct('Metal')
            .withHomeCountry('Spain')
            .build();
        ContactSelector contactSelector = new ContactSelectorMock(contact);
        CustomerProductInfoConfigSelector configSelector = new CustomerProductInfoConfigSelectorMock(null);
        // Act
        Map<String, Object> result = ContactProductInfoApiService.getContactProductInfoByExternalIdInternal(
            contactId, contactSelector, configSelector);
        // Assert
        System.assertEquals(ContactProductInfoConstants.NO_CONFIG_ERROR, result.get(ContactProductInfoConstants.ERROR));
    }

    @IsTest
    static void testSuccess() {
        // Arrange
        Id contactId = TestDataUtil.generateId(Contact.sObjectType);
        Contact contact = new ContactBuilder()
            .withId(contactId)
            .withProduct('Metal')
            .withHomeCountry('Spain')
            .build();

        Customer_Product_Info_Config__mdt config = new Customer_Product_Info_Config__mdt();
        config.Product__c = 'Metal';
        config.Country_Name__c = 'Spain';
        config.Currency_Symbol__c = '€';
        config.Monthly_Cost__c = 16.90;
        config.Is_Not_Applicable_Monthly_Cost__c = false;
        config.Is_Free_ATM_Fee__c = true;
        config.Card_Replacement_Cost__c = 45.00;

        ContactSelector contactSelector = new ContactSelectorMock(contact);
        CustomerProductInfoConfigSelector configSelector = new CustomerProductInfoConfigSelectorMock(config);
        // Act
        Map<String, Object> result = ContactProductInfoApiService.getContactProductInfoByExternalIdInternal(
            contactId, contactSelector, configSelector);
        // Assert
        ContactProductInfoDTO dto = (ContactProductInfoDTO)result.get('ContactProductInfo');
        System.assertEquals(contactId, dto.CRMContactId);
        System.assertEquals('Spain', dto.Home_Country);
        System.assertEquals('Metal', dto.Plan_Type);
        System.assertEquals('€', dto.Currency_Symbol);
        System.assertEquals(16.90, dto.Cost_per_Calendar_Month);
        System.assertEquals(false, dto.Is_Not_Applicable_Monthly_Cost);
        System.assertEquals(true, dto.Is_Free_ATM_Fee);
        System.assertEquals(45.00, dto.Card_Replacement_Cost);
    }

    // Mocks for dependency injection
    global class ContactSelectorMock extends ContactSelector {
        private Contact contact;
        public ContactSelectorMock() {}
        public ContactSelectorMock(Contact contact) { this.contact = contact; }
        global override Contact getByExternalId(String externalId) {
            if (contact != null && contact.Id == externalId) return contact;
            return null;
        }
    }
    
    global class CustomerProductInfoConfigSelectorMock extends CustomerProductInfoConfigSelector {
        private Customer_Product_Info_Config__mdt config;
        public CustomerProductInfoConfigSelectorMock() {}
        public CustomerProductInfoConfigSelectorMock(Customer_Product_Info_Config__mdt config) { this.config = config; }
        global override Customer_Product_Info_Config__mdt getProductInfoByProductCountry(String product, String country) {
            return config;
        }
    }
    
    @IsTest
    static void testRestResourceMethod() {
        // Arrange
        Id contactId = TestDataUtil.generateId(Contact.sObjectType);
        Contact contact = new ContactBuilder()
            .withId(contactId)
            .withProduct('Metal')
            .withHomeCountry('Spain')
            .build();

        Customer_Product_Info_Config__mdt config = new Customer_Product_Info_Config__mdt();
        config.Product__c = 'Metal';
        config.Country_Name__c = 'Spain';
        config.Currency_Symbol__c = '€';
        config.Monthly_Cost__c = 16.90;
        config.Is_Not_Applicable_Monthly_Cost__c = false;
        config.Is_Free_ATM_Fee__c = true;
        config.Card_Replacement_Cost__c = 45.00;

        // Inject mocks using Test.setMock (if using HttpCalloutMock) or by replacing selectors if possible
        // For direct RESTResource method, set up RestContext
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/contactProductInfo';
        req.httpMethod = 'GET';
        req.addParameter('externalId', String.valueOf(contactId));
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Inject mocks for selectors
        ContactProductInfoApiService.contactSelectorInstance = new ContactSelectorMock(contact);
        ContactProductInfoApiService.configSelectorInstance = new CustomerProductInfoConfigSelectorMock(config);

        Test.startTest();
        ContactProductInfoApiService.getContactProductInfoByExternalId();
        Test.stopTest();

        // Assert
        System.assertEquals(ContactProductInfoConstants.HTTP_STATUS_OK, RestContext.response.statusCode);
        String responseBody = RestContext.response.responseBody != null ? RestContext.response.responseBody.toString() : '';
        System.assert(responseBody.contains('ContactProductInfo'));
        // Clean up static injection
        ContactProductInfoApiService.contactSelectorInstance = null;
        ContactProductInfoApiService.configSelectorInstance = null;
    }
}