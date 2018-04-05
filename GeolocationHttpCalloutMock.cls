/**
 * Created by Salesforce on 4/4/18.
 *
 * Purpose: This class is used create a mock callout response for unit testing the GeolocationServiceUtility class
 *
 * Usage: Add the following line to the unit test: Test.setMock(HttpCalloutMock.class, new GeolocationHttpCalloutMock());
 *
 */

@isTest
global class GeolocationHttpCalloutMock implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response.
        // Set response values, and
        // return response.
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"results" : [{"address_components" : [{"long_name" : "1199","short_name" : "1199","types" : [ "street_number" ]},{"long_name" : "Laser","short_name" : "Laser","types" : [ "route" ]},{"long_name" : "Marán","short_name" : "Marán","types" : [ "political", "sublocality", "sublocality_level_1" ]},{"long_name" : "Mexicali","short_name" : "Mexicali","types" : [ "locality", "political" ]},{"long_name" : "Baja California","short_name" : "B.C.","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "Mexico","short_name" : "MX","types" : [ "country", "political" ]},{"long_name" : "21385","short_name" : "21385","types" : [ "postal_code" ]}],"formatted_address" : "Laser 1199, Marán, 21385 Mexicali, B.C., Mexico","geometry" : {"location" : {"lat" : 32.6029296,"lng" : -115.432567},"location_type" : "ROOFTOP","viewport" : {"northeast" : {"lat" : 32.6042785802915,"lng" : -115.4312180197085},"southwest" : {"lat" : 32.6015806197085,"lng" : -115.4339159802915}}},"partial_match" : true,"place_id" : "ChIJu5Qz8NNw14ARICyzNOqDIFU","types" : [ "street_address" ]}],"status" : "OK"}');


        return res;
    }

}