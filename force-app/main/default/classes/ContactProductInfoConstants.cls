/**
 * Constants for Contact Product Info error messages and keys.
 *
 * @author Carlos Martínez Pérez
 * @created 2025-08-04
 */
public class ContactProductInfoConstants {

    // Api Service Constants
    public static final String ERROR = 'error';
    public static final String NO_CONTACT_ERROR = 'No Contact found for the provided externalId';
    public static final String NO_CONFIG_ERROR = 'No configuration found for the specified product and country.';
    public static final String MISSING_EXTERNALID_ERROR = 'Missing externalId parameter';
    public static final Integer HTTP_STATUS_OK = 200;
    public static final Integer HTTP_STATUS_BAD_REQUEST = 400;

    // Constants for error messages
    public static final String CASE_CONTACT_NOT_FOUND_ERROR = 'No Contact associated with this Case';
    public static final String CONTACT_INFO_MISSING_ERROR = 'No Product/Country information found for the associated Contact.';
}
