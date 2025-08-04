/**
 * Utility class for generating fake Salesforce Ids for test purposes.
 * Note: These Ids are only suitable for logic that does not require actual database records.
 *
 * @author Carlos Martínez Pérez
 * @created 2025-08-03
 */
@IsTest
public class TestDataUtil {
    private static Integer startingNumber = 1;

    public static String generateId(Schema.SObjectType sObjectType) {
        String result = String.valueOf(startingNumber++);
        String prefix = sObjectType.getDescribe().getKeyPrefix();
        if (sObjectType == CaseHistory.SObjectType) prefix = '017';
        return prefix + '0'.repeat(12-result.length()) + result;
    }
}
