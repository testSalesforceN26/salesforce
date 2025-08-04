/**
 * Selector class for Contact objects.
 * Implements the ISelector interface to provide methods for querying and selecting Contact records.
 *
 * @author Carlos Martínez Pérez
 * @created 2025-08-01
 */
global virtual with sharing class ContactSelector implements ISelector {
    
    // base fields to be queried in queries, add more if it is needed.
    private static final List<String> CONTACT_BASE_FIELDS = new List<String>{
        'Id',
        'Home_Country__c',
        'Product__c'
    };
    
    /**
     * Retrieves a single Contact record by its unique identifier.
     *
     * @param recordId The Id of the record to retrieve.
     * @return The Contact corresponding to the provided Id.
     */
    public virtual Contact getById(Id recordId) {
        List<Contact> contacts = getByIds(new List<Id>{recordId});
        if (!contacts.isEmpty()) {
            return contacts[0];
        }
        return null;
    }


    /**
     * Retrieves multiple Contacts records by their unique identifiers.
     *
     * @param recordIds The list of Ids of the records to retrieve.
     * @return A list of Contacts corresponding to the provided Ids.
     */
    public List<Contact> getByIds(List<Id> recordIds) {
        return (List<Contact>) new QueryBuilder()
            .setSObject('Contact')
            .selectFields(CONTACT_BASE_FIELDS)
            .addWhereClause('Id IN (\'' + String.join((List<String>)recordIds, '\',\'') + '\')')
            .execute();
    }

    /**
     * Retrieves a single Contact record by its External_Id__c field.
     *
     * @param externalId The external identifier (UUID) mapped to the Contact.
     * @return The Contact corresponding to the provided externalId, or null if not found.
     */
    global virtual Contact getByExternalId(String externalId) {
        List<Contact> contacts = (List<Contact>) new QueryBuilder()
            .setSObject('Contact')
            .selectFields(CONTACT_BASE_FIELDS)
            .addWhereClause('External_Id__c = \'' + externalId + '\'')
            .setLimit(1)
            .execute();
        return !contacts.isEmpty() ? contacts[0] : null;
    }

}
