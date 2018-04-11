/**
 * Created by cbarbour on 3/16/18.
 *
 * Purpose: This class is used to callout to a geocoding service (Google Geocode API) and retrieve the geocode for an address
 *
 * Usage: The GeolocationServiceUtility.getGeocodeForAddress() method required three inputs: street, city, and state. The state can be an abbreviation or full name (example, Baja California or B.C.)
 *
 */

public with sharing class GeolocationServiceUtility {

    /*
     * Define the error message values from Custom Labels
     */
    private static final String ZERO_RESULTS_MSG = System.Label.Zero_Results_Message;
    private static final String OVER_QUERY_LIMIT_MSG = System.Label.API_Quota_Limit;
    private static final String REQUEST_DENIED_MSG = System.Label.Request_Denied;
    private static final String INVALID_REQUEST_MSG = System.Label.Invalid_Request;
    private static final String UNKNOWN_ERROR_MSG = System.Label.Unknown_Error;

    /*
     * Settings for the Geocoding Service as defined in 
     * Custom Metadata Geolocation_Settings__mdt
     */
    private static Map<String, String> geoLocationSettings {
        get {
            if(geoLocationSettings == null) {
                geoLocationSettings = new Map<String, String>();
                for (Geolocation_Settings__mdt setting : [SELECT Id, DeveloperName, Value__c FROM Geolocation_Settings__mdt]) {
                    geoLocationSettings.put(setting.DeveloperName, setting.Value__c);
                }
            } 
            return geoLocationSettings;
        }
        private set;
    }
    
    // Send the callout request and return the response
    public static HttpResponse getGeocodeFromService(String aStreet, String aCity, String aPostalCode, String aState, string aCountry){

        // Build the url endpoint
        String url = geoLocationSettings.get('Google_Geocoding_API_Endpoint') + geoLocationSettings.get('Output_Type');
        String fullAddress = aStreet + ', ' + aPostalCode +  ', ' + aCity + ', ' + aState + ', ' + aCountry;
        url += '?address=' + formatAddress(fullAddress);
        url += '&key=' + geoLocationSettings.get('Google_Geocoding_API_Key');

        // Stage and send the callout to get the address's geolocation
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setHeader('Content-type', 'application/x-www-form-urlencoded');
        req.setHeader('Content-length', '0');  //I am not sure if this is required or not
        req.setEndpoint(url);
        req.setMethod('POST');

        HttpResponse response = h.send(req);

        return response;

    }

    /*
     * Main methods to use this service
     * Three variations: 
     * 1) Street, City, State
     * 2) Street, Postal Code, City, Country
     * 3) Street, Postal Code, City, State, Country
     */
    public static GeocodeData getGeocodeForAddress(String aStreet, String aCity, String aState){
        return getGeocodeForAddress(aStreet, '', aCity, aState, '');
    }

    public static GeocodeData getGeocodeForAddress(String aStreet, String aPostalCode, String aCity, String aCountry){
        return getGeocodeForAddress(aStreet, aPostalCode, aCity, '', aCountry);
    }
    
    public static GeocodeData getGeocodeForAddress(String aStreet, String aPostalCode, String aCity, String aState, String aCountry){

        HttpResponse response = getGeocodeFromService(aStreet, aCity, aPostalCode, aState, aCountry);

        return deserializeCoordinates(response.getBody());

    }

    // Make the response more useful by deserializing the response body
    @TestVisible
    private static GeocodeData deserializeCoordinates(String jsonString){

        GeocodeData gcd = new GeocodeData();

        // Deserialize the top level data into a list of objects
        Map<String,Object> topLevelResults = (Map<String,Object>)JSON.deserializeUntyped(jsonString);
        List<Object> resultsList = (List<Object>)topLevelResults.get('results');
        System.debug('Status: ' + topLevelResults.get('status'));

        gcd.status = (String)topLevelResults.get('status');

        if(gcd.status != 'OK'){

            gcd.statusText = handleError(gcd.status);

        }
        else {
            // Continue to deserialize the results
            if(resultsList.size() == 1){

                Map<String,Object> results = (Map<String, Object>)resultsList.get(0);
                System.debug('results map key set: ' + results.keySet());
                System.debug('results map geometry: ' + results.get('geometry'));

                Map<String,Object> geometry = (Map<String,Object>)results.get('geometry');
                System.debug('geometry key set: ' + geometry.keySet());
                System.debug('geometry values for location: ' + geometry.get('location'));

                Map<String,Object> location = (Map<String,Object>)geometry.get('location');
                System.debug('Location key set: ' + location.keySet());

                gcd.latitude = (Decimal)location.get('lat');
                gcd.longitude = (Decimal)location.get('lng');
                gcd.statusText = gcd.status;

            }

        }

        return gcd;

    }

    // Handle errors the geolocation service may return
    // Valid status error codes: ZERO_RESULTS, OVER_QUERY_LIMIT, REQUEST_DENIED, INVALID_REQUEST, UNKNOWN_ERROR
    @TestVisible
    private static String handleError(String status){

        // ZERO_RESULTS - the geocode was successful but returned no results. This may occur if the geocoder was passed a non-existent address.
        String errorMessage =
                status == 'ZERO_RESULTS' ? ZERO_RESULTS_MSG :
                        status == 'OVER_QUERY_LIMIT' ? OVER_QUERY_LIMIT_MSG :
                                status == 'REQUEST_DENIED' ? REQUEST_DENIED_MSG :
        							status == 'INVALID_REQUEST' ? INVALID_REQUEST_MSG :
                                        status == 'UNKNOWN_ERROR' ? UNKNOWN_ERROR_MSG : UNKNOWN_ERROR_MSG;

        return errorMessage;

    }

    // Format the address such that the whitespace is replace with '+'
    private static String formatAddress(String fullAddress){
        // The first parameter is a regex expression to identify all whitespace in a string
        return fullAddress.replaceAll('\\s+', '+');
    }
    
}
