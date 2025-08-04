/**
 * Builder class for creating Case records for tests.
 * Provides methods to set relevant fields and insert Case records.
 *
 * @author Carlos Martínez Pérez
 * @created 2025-08-03
 */
public class CaseBuilder {
    private Case caseRecord;

    public CaseBuilder() {
        caseRecord = new Case();
    }

    public CaseBuilder withId(String Id) {
        caseRecord.Id = Id;
        return this;
    }

    public CaseBuilder withContactId(Id contactId) {
        caseRecord.ContactId = contactId;
        return this;
    }

    public Case build() {
        return caseRecord;
    }
}
