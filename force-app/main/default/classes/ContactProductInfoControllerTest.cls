/**
 * Test class for ContactProductInfoController.
 * Uses builders and mock selectors for dependency injection and isolation.
 *
 * @author Carlos Martínez Pérez
 * @created 2025-08-03
 */
@IsTest
public class ContactProductInfoControllerTest {

    // Mock selector for Contact
    private class MockContactSelector extends ContactSelector {
        private final Contact contact;
        public MockContactSelector(Contact contact) { this.contact = contact; }
        public override Contact getById(Id contactId) { return contact; }
    }

    // Mock selector for Case
    private class MockCaseSelector extends CaseSelector {
        private final Case caseRecord;
        public MockCaseSelector(Case caseRecord) { this.caseRecord = caseRecord; }
        public override Case getById(Id caseId) { return caseRecord; }
    }

    // Mock selector for Custom Metadata
    private class MockMetadataSelector extends CustomerProductInfoConfigSelector {
        private final Customer_Product_Info_Config__mdt config;
        public MockMetadataSelector(Customer_Product_Info_Config__mdt config) { this.config = config; }
        public override Customer_Product_Info_Config__mdt getProductInfoByProductCountry(String product, String country) { return config; }
    }


    @IsTest
    static void testGetContactProductInfoInternal_Success() {
        // Arrange
        Contact fakeContact = new ContactBuilder()
            .withId(TestDataUtil.generateId(Contact.sObjectType))
            .withProduct('Standard')
            .withHomeCountry('Spain')
            .build();

        Case fakeCase = new CaseBuilder()
            .withId(TestDataUtil.generateId(Case.sObjectType))
            .withContactId(fakeContact.Id)
            .build();

        Customer_Product_Info_Config__mdt config = new Customer_Product_Info_Config__mdt();
        config.Product__c = 'Standard';
        config.Country_Name__c = 'Spain';
        config.MasterLabel = 'Test Config';

        ContactSelector mockContactSelector = new MockContactSelector(fakeContact);
        CaseSelector mockCaseSelector = new MockCaseSelector(fakeCase);
        CustomerProductInfoConfigSelector mockMetadataSelector = new MockMetadataSelector(config);
        ContactProductInfoController controller = new ContactProductInfoController(mockContactSelector, mockCaseSelector, mockMetadataSelector);

        // Act
        Map<String, Object> result = controller.getContactProductInfoInternal(fakeCase.Id);

        // Assert
        System.assertEquals('Standard', ((Contact)result.get('contact')).Product__c);
        System.assertEquals('Spain', ((Contact)result.get('contact')).Home_Country__c);
        System.assertEquals('Test Config', ((Customer_Product_Info_Config__mdt)result.get('config')).MasterLabel);
        System.assert(result.get('fieldLabels') != null);
        System.assert(!result.containsKey('error'));
    }


    @IsTest
    static void testGetContactProductInfoInternal_NoContact() {
        // Arrange
        Id fakeContactId = TestDataUtil.generateId(Contact.sObjectType);
        Case fakeCase = new CaseBuilder()
            .withId(TestDataUtil.generateId(Case.sObjectType))
            //.withContactId(fakeContactId)
            .build();

        // Mock selector returns null for contact
        ContactSelector mockContactSelector = new MockContactSelector(null);
        CaseSelector mockCaseSelector = new MockCaseSelector(fakeCase);
        CustomerProductInfoConfigSelector mockMetadataSelector = new MockMetadataSelector(null);
        ContactProductInfoController controller = new ContactProductInfoController(mockContactSelector, mockCaseSelector, mockMetadataSelector);

        // Act
        Map<String, Object> result = controller.getContactProductInfoInternal(fakeCase.Id);

        // Assert
        System.assertEquals(ContactProductInfoConstants.CASE_CONTACT_NOT_FOUND_ERROR, result.get('error'));
        System.assert(!result.containsKey('contact'));
        System.assert(!result.containsKey('config'));
    }


     @IsTest
    static void testGetContactProductInfoInternal_NoContactValues() {
        // Arrange
        Contact fakeContact = new ContactBuilder()
            .withId(TestDataUtil.generateId(Contact.sObjectType))
            .build();

        Case fakeCase = new CaseBuilder()
            .withId(TestDataUtil.generateId(Case.sObjectType))
            .withContactId(fakeContact.Id)
            .build();

        // Mock selector returns null for config
        ContactSelector mockContactSelector = new MockContactSelector(fakeContact);
        CaseSelector mockCaseSelector = new MockCaseSelector(fakeCase);
        CustomerProductInfoConfigSelector mockMetadataSelector = new MockMetadataSelector(null);
        ContactProductInfoController controller = new ContactProductInfoController(mockContactSelector, mockCaseSelector, mockMetadataSelector);

        // Act
        Map<String, Object> result = controller.getContactProductInfoInternal(fakeCase.Id);

        // Assert
        System.assertEquals(ContactProductInfoConstants.CONTACT_INFO_MISSING_ERROR, result.get('error'));
        System.assert(!result.containsKey('config'));
    }


     @IsTest
    static void testGetContactProductInfoInternal_NoConfig() {
        // Arrange
        Contact fakeContact = new ContactBuilder()
            .withId(TestDataUtil.generateId(Contact.sObjectType))
            .withProduct('Standard')
            .withHomeCountry('Spain')
            .build();

        Case fakeCase = new CaseBuilder()
            .withId(TestDataUtil.generateId(Case.sObjectType))
            .withContactId(fakeContact.Id)
            .build();

        // Mock selector returns null for config
        ContactSelector mockContactSelector = new MockContactSelector(fakeContact);
        CaseSelector mockCaseSelector = new MockCaseSelector(fakeCase);
        CustomerProductInfoConfigSelector mockMetadataSelector = new MockMetadataSelector(null);
        ContactProductInfoController controller = new ContactProductInfoController(mockContactSelector, mockCaseSelector, mockMetadataSelector);

        // Act
        Map<String, Object> result = controller.getContactProductInfoInternal(fakeCase.Id);

        // Assert
        System.assertEquals(ContactProductInfoConstants.NO_CONFIG_ERROR, result.get('error'));
        System.assertEquals(fakeContact, result.get('contact'));
        System.assert(!result.containsKey('config'));
    }
}