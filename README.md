# GeocodeService
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
| Google Geocode API Key | Google_Geocode_API_Key | [[ replace with your API key ]] |
| Output Type | Output_Type | json? |



### Sample code
```java
GeocodeData geocode = GeolocationServiceUtility.getGeocodeForAddress('Laser 1199 Parque Industrial Maran','Mexicali', 'B.C.');
System.debug('Latitude: ' + geocode.latitude);
System.debug('Longitude:' + geocode.longitude);
System.debug('Status: ' + geocode.status + ': ' + geocode.statusText);
```
