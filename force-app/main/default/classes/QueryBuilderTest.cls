@isTest
public class QueryBuilderTest {
    @isTest
    static void testBuildBasicQuery() {
        QueryBuilder qb = new QueryBuilder()
            .setSObject('Contact')
            .selectFields(new List<String>{'Id', 'Name', 'Email'});
        String soql = qb.build();
        System.assertEquals('SELECT Id, Name, Email FROM Contact', soql);
    }

    @isTest
    static void testBuildWithWhereOrderLimit() {
        QueryBuilder qb = new QueryBuilder()
            .setSObject('Contact')
            .selectFields(new List<String>{'Id', 'Name'})
            .addWhereClause('Email != null')
            .addWhereClause('Name != null')
            .orderBy('Name ASC')
            .setLimit(5);
        String soql = qb.build();
        System.assertEquals('SELECT Id, Name FROM Contact WHERE Email != null AND Name != null ORDER BY Name ASC LIMIT 5', soql);
    }

    @isTest
    static void testExceptionOnMissingSObjectOrFields() {
        Boolean exceptionThrown = false;
        try {
            QueryBuilder qb = new QueryBuilder();
            qb.build();
        } catch (QueryBuilder.QueryException e) {
            exceptionThrown = true;
        }
        System.assert(exceptionThrown, 'Exception should be thrown if sObject or fields are missing');
    }

    @isTest
    static void testExecuteMethod() {
        // Create a test Contact
        Contact contactTest = new Contact(LastName='Test', Email='test@example.com', Product__c='Black', Home_Country__c='France');
        insert contactTest;
        QueryBuilder qb = new QueryBuilder()
            .setSObject('Contact')
            .selectFields(new List<String>{'Id', 'Email'})
            .addWhereClause('Email = \'test@example.com\'')
            .setLimit(1);
        List<SObject> results = qb.execute();
        System.assertEquals(1, results.size(), 'Should return one Contact');
        System.assertEquals(contactTest.Id, results[0].get('Id'));
    }
}
