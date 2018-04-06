/**
 * Created by cbarbour on 4/4/18.
 *
 * Purpose: This class is used to test the GeolocationServiceUtility class
 *
 * Usage: N/A
 *
 */

@isTest
private class GeolocationServiceUtility_Test {

    @isTest static void testCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new GeolocationHttpCalloutMock());

        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        HttpResponse res = GeolocationServiceUtility.getGeocodeFromService('Laser 1199 Parque Industrial Maran','Mexicali', 'B.C.');

        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"results" : [{"address_components" : [{"long_name" : "1199","short_name" : "1199","types" : [ "street_number" ]},{"long_name" : "Laser","short_name" : "Laser","types" : [ "route" ]},{"long_name" : "Marán","short_name" : "Marán","types" : [ "political", "sublocality", "sublocality_level_1" ]},{"long_name" : "Mexicali","short_name" : "Mexicali","types" : [ "locality", "political" ]},{"long_name" : "Baja California","short_name" : "B.C.","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "Mexico","short_name" : "MX","types" : [ "country", "political" ]},{"long_name" : "21385","short_name" : "21385","types" : [ "postal_code" ]}],"formatted_address" : "Laser 1199, Marán, 21385 Mexicali, B.C., Mexico","geometry" : {"location" : {"lat" : 32.6029296,"lng" : -115.432567},"location_type" : "ROOFTOP","viewport" : {"northeast" : {"lat" : 32.6042785802915,"lng" : -115.4312180197085},"southwest" : {"lat" : 32.6015806197085,"lng" : -115.4339159802915}}},"partial_match" : true,"place_id" : "ChIJu5Qz8NNw14ARICyzNOqDIFU","types" : [ "street_address" ]}],"status" : "OK"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }


    // Test the deserialization of geocode data from the JSON response, no errors
    @isTest static void testGeocodeDeserialization(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new GeolocationHttpCalloutMock());

        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        HttpResponse res = GeolocationServiceUtility.getGeocodeFromService('Laser 1199 Parque Industrial Maran','Mexicali', 'B.C.');

        // Test private method for deserializing JSON response
        GeocodeData testGeoCodeData = GeolocationServiceUtility.deserializeCoordinates(res.getBody());
        System.assertEquals(32.6029296, testGeoCodeData.latitude);
        System.assertEquals(-115.432567, testGeoCodeData.longitude);
        System.assertEquals('OK',testGeoCodeData.status);
        System.assertEquals('OK',testGeoCodeData.statusText);

    }


    // Test the deserialization of geocode data from the JSON response, with error: ZERO_RESULTS
    @isTest static void testErrorZeroResults(){

        String testErrorMessage = GeolocationServiceUtility.handleError('ZERO_RESULTS');

        System.assertEquals('The geocode was successful but returned no results. This may occur if the geocoder was passed a non-existent address.', testErrorMessage);

    }


    // Test the deserialization of geocode data from the JSON response, with error: OVER_QUERY_LIMIT_MSG
    @isTest static void testErrorQueryLimit(){

        String testErrorMessage = GeolocationServiceUtility.handleError('OVER_QUERY_LIMIT');

        System.assertEquals('You are over your quota.', testErrorMessage);

    }


    // Test the deserialization of geocode data from the JSON response, with error: REQUEST_DENIED
    @isTest static void testErrorRequestDenied(){

        String testErrorMessage = GeolocationServiceUtility.handleError('REQUEST_DENIED');

        System.assertEquals('Your request was denied.', testErrorMessage);

    }


    // Test the deserialization of geocode data from the JSON response, with error: UNKNOWN_ERROR
    @isTest static void testErrorUnknownError(){

        String testErrorMessage = GeolocationServiceUtility.handleError('UNKNOWN_ERROR');

        System.assertEquals('The query (address, components, or latitude/longitude) is missing.', testErrorMessage);

    }

}
