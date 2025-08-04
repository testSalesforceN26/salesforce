/**
 * Interface for selector classes used to encapsulate SOQL queries and data retrieval logic.
 * Implementing classes should define methods for selecting and querying Salesforce records.
 *
 *
 * @author Carlos Martínez Pérez
 * @created 2025-08-03
 */
public interface ISelector{
  
    /**
     * Retrieves a record of the specified SObject by its unique identifier.
     *
     * @param recordId The Id of the record to retrieve.
     * @return The record of the specified SObject corresponding to the given Id.
     */
    SObject getById(Id recordId);


    /**
     * Retrieves multiple records of the specified SObject by their unique identifiers.
     *
     * @param recordIds The list of Ids of the records to retrieve.
     * @return A list of records of the specified SObject corresponding to the provided Ids.
     */
    List<SObject> getByIds(List<Id> recordIds);
}
