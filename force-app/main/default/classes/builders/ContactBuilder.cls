/**
 * Builder class for creating Contact records .
 * Provides methods to set relevant fields.
 *
 * @author Carlos Martínez Pérez
 * @created 2025-08-03
 */
public class ContactBuilder {
    private Contact contact;

    public ContactBuilder() {
        contact = new Contact();
    }

    public ContactBuilder withId(String Id) {
        contact.Id = Id;
        return this;
    }

    public ContactBuilder withProduct(String product) {
        contact.Product__c = product;
        return this;
    }

    public ContactBuilder withHomeCountry(String country) {
        contact.Home_Country__c = country;
        return this;
    }

    public ContactBuilder withExternalId(String externalId) {
        contact.External_Id__c = externalId;
        return this;
    }

    public Contact build() {
        return contact;
    }
}
