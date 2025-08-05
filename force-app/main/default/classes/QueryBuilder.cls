/**
 * @description
 * The QueryBuilder class provides utility methods for building dynamic SOQL queries in Salesforce.
 * It supports constructing queries with flexible filtering, sorting, and field selection options.
 * 
 * @author Carlos Martínez Pérez
 * @date 2025-08-01
 */
public with sharing class QueryBuilder {
    
    private String sObjectName;
    private List<String> fields = new List<String>();
    private List<String> whereClauses = new List<String>();
    private String orderByClause;
    private Integer limitValue;

    /**
     * Specifies the SObject type to be used in the query.
     */
    // Set the SObject type
    public QueryBuilder setSObject(String sObjectName) {
        this.sObjectName = sObjectName;
        return this;
    }

    /**
     * Adds fields to the SELECT clause of the SOQL query.
     * This section is responsible for specifying which fields should be retrieved from the database.
     */
    // Add fields to select
    public QueryBuilder selectFields(List<String> fieldNames) {
        this.fields.addAll(fieldNames);
        return this;
    }
    /**
     * Adds a single field to the SELECT clause of the query.
     *
     * Use this method to specify an individual field to be retrieved when building a query.
     */
    // Add a single field to select
    public QueryBuilder selectField(String fieldName) {
        this.fields.add(fieldName);
        return this;
    }

    /**
     * Adds a WHERE clause to the query being constructed.
     * Use this method to specify filtering conditions for the SOQL query.
     */
    // Add a WHERE clause
    public QueryBuilder addWhereClause(String clause) {
        this.whereClauses.add(clause);
        return this;
    }

    /**
     * Adds an ORDER BY clause to the query being constructed.
     * Use this section to specify the sorting order of the query results.
     */
    // Add ORDER BY
    public QueryBuilder orderBy(String clause) {
        this.orderByClause = clause;
        return this;
    }

    /**
     * Adds a LIMIT clause to the SOQL query being constructed.
     * This restricts the number of records returned by the query.
     */
    // Add LIMIT
    public QueryBuilder setLimit(Integer value) {
        this.limitValue = value;
        return this;
    }

    /**
     * Constructs the SOQL query string based on the specified parameters and conditions.
     */
    // Build the query string
    public String build() {
        if (String.isBlank(sObjectName) || fields.isEmpty()) {
            throw new QueryException('SObject name and at least one field are required.');
        }
        String query = 'SELECT ' + String.join(fields, ', ') + ' FROM ' + sObjectName;
        if (!whereClauses.isEmpty()) {
            query += ' WHERE ' + String.join(whereClauses, ' AND ');
        }
        if (orderByClause != null) {
            query += ' ORDER BY ' + orderByClause;
        }
        if (limitValue != null) {
            query += ' LIMIT ' + limitValue;
        }
        return query;
    }

    /**
     * Executes the constructed SOQL query and returns the resulting records.
     * This method runs the query built by the QueryBuilder and provides the results for further processing.
     *
     * @return List<SObject> The records returned by the executed query.
     */
    // Execute the built query and return results
    public List<SObject> execute() {
        String soql = build();
        return Database.query(soql);
    }

    /**
     * Represents a custom exception used to handle errors that occur during query operations.
     * This exception can be thrown when there are issues building or executing queries.
     */
    // Custom exception for query errors
    public class QueryException extends Exception {}
}
