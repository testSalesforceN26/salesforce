/**
 * This interface should be implemented by classes that need to query
 * custom metadata records using the DeveloperName field. Implementations
 * are expected to define the logic for retrieving metadata records
 * relevant to their specific use case.
 * @author Carlos Martínez Pérez
 * @created 2025-08-01
 * 
 * Example usage:
 *   IGenericMetadataSelector selector = new MyGenericMetadataSelector();
 *   CustomMetadata__mdt metadata = selector.getByDeveloperName('recordRecordDeveloperName');
 */
public interface IGenericMetadataSelector {
    /**
     * Retrieves a custom metadata record by its DeveloperName.
     * @param developerName The DeveloperName of the metadata record.
     * @return The custom metadata SObject record, or null if not found.
     */
    SObject getByDeveloperName(String developerName);
}
