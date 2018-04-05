/**
 * Created by Salesforce on 3/16/18.
 *
 * Purpose: This class is used to callout to a geocoding service (Google Geocode API) and retrieve the geocode for an address
 *
 * Usage: The GeolocationServiceUtility.getGeocodeForAddress() method required three inputs: street, city, and state. The state can be an abbreviation or full name (example, Baja California or B.C.)
 *
 */

public with sharing class GeolocationServiceUtility {

    private static Map<String, String> geolocationSettings;
    private static final String ZERO_RESULTS_MSG = 'The geocode was successful but returned no results. This may occur if the geocoder was passed a non-existent address.';
    private static final String OVER_QUERY_LIMIT_MSG = 'You are over your quota.';
    private static final String REQUEST_DENIED_MSG = 'Your request was denied.';
    private static final String UNKNOWN_ERROR_MSG = 'The query (address, components, or latitude/longitude) is missing.';

    // Send the callout request and return the response
    public static HttpResponse getGeocodeFromService(String aStreet, String aCity, String aState){


        // Get geolocation settings from custom metadata
        getGeolocationSettings();

        // Build the url endpoint
        String url = geolocationSettings.get('Geolocation_Endpoint');
        url += geolocationSettings.get('Output_Type');
        String fullAddress = aStreet + ', ' + aCity + ', ' + aState;
        url += 'address=' + formatAddress(fullAddress);
        url += '&key=' + geolocationSettings.get('Google_Geolocation_API');

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


    // Deserialize the callout response
    public static GeocodeData getGeocodeForAddress(String aStreet, String aCity, String aState){

        HttpResponse response = getGeocodeFromService(aStreet, aCity, aState);

        return deserializeCoordinates(response.getBody());

    }


    // Build a map of geolocation settings
    private static void getGeolocationSettings(){

        if(geolocationSettings == null) {

            geolocationSettings = new Map<String, String>();

            for (Geolocation_Settings__mdt setting : [SELECT Id, DeveloperName, Value__c FROM Geolocation_Settings__mdt]) {
                System.debug('===========> setting: ' + setting);
                geolocationSettings.put(setting.DeveloperName, setting.Value__c);
            }

        }

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
    // Valid status error codes: ZERO_RESULTS, OVER_QUERY_LIMIT, REQUEST_DENIED, UNKNOWN_ERROR
    @TestVisible
    private static String handleError(String status){

        // ZERO_RESULTS - the geocode was successful but returned no results. This may occur if the geocoder was passed a non-existent address.
        String errorMessage =
                status == 'ZERO_RESULTS' ? ZERO_RESULTS_MSG :
                        status == 'OVER_QUERY_LIMIT' ? OVER_QUERY_LIMIT_MSG :
                                status == 'REQUEST_DENIED' ? REQUEST_DENIED_MSG :
                                        status == 'UNKNOWN_ERROR' ? UNKNOWN_ERROR_MSG : 'An undocumented error code was received. Please consult Google\'s documentation.';

        return errorMessage;

    }


    // Format the address such that the whitespace is replace with '+'
    private static String formatAddress(String fullAddress){

        // The first parameter is a regex expression to identify all whitespace in a string
        return fullAddress.replaceAll('\\s+', '+');

    }


}