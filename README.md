# GeocodeService
This code can be used to retrieve the geocode for a provided address using Google's Geocoding API. You will need to provide your own API key in order for this service to work.

Get your API key [here](https://developers.google.com/maps/documentation/geocoding/get-api-key).

## Custom Metadata
This code requires custom metadata to pull in API info for Google's Geocode API

### Schema
| Name | Value |
| -------------- | -------------------- |
| Singular Label | Geolocation Settings |
| Plural Label | Geolocation Settings |
| Object Name | Geolocation_Settings |
| Custom Fields | Value; Value__c (Text 50) |

### Records
| Label | Name | Value |
| --- | --- | --- |
| Geolocation Endpoint | Geolocation_Endpoint | https://maps.googleapis.com/maps/api/geocode/ |
| Google Geocoding API Key | Google_Geocoding_API_Key | [[ replace with your API key ]] |
| Output Type | Output_Type | json? |



## Sample code
```java
GeocodeData geocode = GeolocationServiceUtility.getGeocodeForAddress('Laser 1199 Parque Industrial Maran','Mexicali', 'B.C.');
System.debug('Latitude: ' + geocode.latitude);
System.debug('Longitude:' + geocode.longitude);
System.debug('Status: ' + geocode.status + ': ' + geocode.statusText);
```
