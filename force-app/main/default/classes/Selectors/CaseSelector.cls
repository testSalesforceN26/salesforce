/**
 * Selector class for Case objects.
 * Implements the ISelector interface to provide methods for querying and manipulating Case records.
 *
 * @author Carlos Martínez Pérez
 * @created 2025-08-01
 */
public virtual with sharing class CaseSelector implements ISelector {

    // base fields to be queried in queries, add more if it is needed.
    private static final List <String> CASE_BASE_FIELDS = new List<String>{
        'Id',
        'ContactId'
    };

    /**
     * Retrieves a single Case record by its unique identifier.
     *
     * @param recordId The Id of the record to retrieve.
     * @return The Case corresponding to the provided Id, or null if not found.
     */
    public virtual Case getById(Id recordId) {
        List<Case> cases = getByIds(new List<Id>{recordId});
        if (!cases.isEmpty()) {
            return cases[0];
        }
        return null;
    }

    
    /**
     * Retrieves a list of Case records based on the provided list of record IDs.
     *
     * @param recordIds List of record IDs to retrieve.
     * @return List of Case records corresponding to the given IDs.
     */
    public List<Case> getByIds(List<Id> recordIds) {
        return (List<Case>) new QueryBuilder()
            .setSObject('Case')
            .selectFields(CASE_BASE_FIELDS)
            .addWhereClause('Id IN (\'' + String.join((List<String>)recordIds, '\',\'') + '\')')
            .execute();
    }
}
