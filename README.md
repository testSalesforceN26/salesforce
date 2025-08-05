
# Technical Analysis & Component Documentation

## Data Model

This project introduces three custom fields on the `Contact` object:
- `Product__c`
- `Home_Country__c`
- `External_Id__c`

The fields "Product and Home Country" are configured as mandatory on the Contact Layout to ensure data consistency and prevent incomplete records. Notably, `Product__c` and `Home_Country__c` are implemented as text fields rather than picklists. This design choice avoids future maintenance overhead and ensures that values are always aligned with the entries in the custom metadata type `Customer_Product_Info_Config__mdt`, which acts as the source of truth for valid products and countries.

To further enforce data integrity, the flow `Contact_Validate_Product_Country_Fields` has been developed. This flow validates that the product and country fields on a contact are always accurate and non-empty, preventing the creation or update of inconsistent records.

## Metadata Structure & Data Consistency

The custom metadata type `Customer_Product_Info_Config__mdt` defines the valid combinations of product and country, along with related configuration fields. Some fields, such as `ATM_Fee__c` and `Monthly_Cost__c`, may have values that are not strictly numeric (e.g., "Free" or "N/A"). To ensure data consistency and support future automation, additional boolean fields have been introduced:
- `Is_Free_ATM_Fee__c`: Indicates when the ATM fee is free.
- `Is_Not_Applicable_Monthly_Cost__c`: Indicates when the monthly cost does not apply.

This approach ensures that all data is structured and machine-readable, enabling future operations or reporting without the need for complex transformations.

<img width="1604" height="519" alt="image" src="https://github.com/user-attachments/assets/a87d3275-470b-4169-a5c8-260145d30508" />


## Flows

- **Contact_Validate_Product_Country_Fields**: Validates that the product and country fields on a contact are always accurate and non-empty, preventing the creation or update of inconsistent records.

## Apex Architecture & Best Practices

The codebase follows Apex best practices, particularly the Separation of Concerns (SOC) principle. Key patterns and components include:

- **Selectors**: Classes such as `ContactSelector`, `CaseSelector`, and `CustomerProductInfoConfigSelector` encapsulate all SOQL queries and metadata retrieval logic. This centralizes data access and simplifies future changes.

- **Builders**: Classes like `ContactBuilder` and `CaseBuilder` are used in test classes to construct SObject instances without performing DML operations. This improves test performance and avoids issues with database state or record locking.

- **Mocks**: All test classes use mock selector implementations to inject test data and isolate logic, ensuring that tests do not depend on actual database records. This approach prevents future errors when data models change and keeps tests fast and reliable.

- **Constants**: The class `ContactProductInfoConstants` centralizes error and status codes, ensuring consistency across the API and controller logic.

- **DTOs**: The `ContactProductInfoDTO` class is used to shape API responses, mapping internal Salesforce fields to external API field names and ensuring a clean, maintainable contract for integrations.

- **Test Classes**: All test classes are designed for high coverage and isolation, using builders and mocks to avoid DML and ensure fast, reliable execution. Each test scenario (success and error cases) is covered, following best practices for maintainability and future-proofing.

## Lightning Components & UI

- **contactProductInfo**: A Lightning Web Component (LWC) for displaying contact product information, leveraging the structured data model and metadata for dynamic rendering, it will only be visible on Case Layout when Product__c and Home_country__c are not empty.

  <img width="1255" height="717" alt="image" src="https://github.com/user-attachments/assets/a2c8f528-60ae-4d48-9ae4-55b9330f83e9" />


## API Service: Contact Product Info

The `ContactProductInfoApiService` class exposes a REST API endpoint for retrieving product information for a contact by external ID. This service is designed for external integrations and follows best practices for maintainability and testability.

### How to Test the API

You can test the API using Salesforce Workbench, Postman, or any REST client. The endpoint URL format is:

```
/services/apexrest/contactProductInfo?externalId=1234
```
<img width="837" height="183" alt="image" src="https://github.com/user-attachments/assets/418008b1-bbc2-4106-9b31-e6a0917fdcfb" />


Replace `1234` with the actual external ID of the contact you want to query. The response will be in JSON format, structured according to the `ContactProductInfoDTO`.

### JSON Response Scenarios

#### Scenario 1: All Data Present

The response includes all fields, including ATM Fee and Cost per Calendar Month:

<img width="387" height="304" alt="image" src="https://github.com/user-attachments/assets/eb24733d-1aa8-42a8-9f50-344259fbff4a" />


#### Scenario 2: ATM Fee is Free or Cost per Calendar Month Not Applicable

The response will show `Is_Free_ATM_Fee` as `true` and `ATM_Fee` may be null or omitted also if 
it is not applicable `Is_Not_Applicable_Monthly_Cost` as `true` and `Cost_per_Calendar_Month` may be null or omitted:

<img width="403" height="306" alt="image" src="https://github.com/user-attachments/assets/b4308032-16c0-438c-8e8a-6dda322d31a4" />

#### Scenario 4: Error Cases

If the contact or config is not found, the response will include an `error` field with a descriptive message (Example):

<img width="753" height="401" alt="image" src="https://github.com/user-attachments/assets/22b1a567-a734-4352-84ee-eb5ef4b64a92" />


## Summary

This project is designed for maintainability, data consistency, and future extensibility. By leveraging custom metadata, flows, and best-practice Apex patterns, it ensures that business logic, data validation, and integration contracts remain robust and easy to evolve.
