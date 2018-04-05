# GeocodeService
This code requires custom metadata to pull in API info for Google's Geocode API

| Name | Value |
| -------------- | -------------------- |
| Singular Label | Geolocation Settings |
| Plural Label | Geolocation Settings |
| Object Name | Geolocation_Settings |
| Custom Fields | Value; Value__c (Text 50) |


### Sample code
```java
GeocodeData geocode = GeolocationServiceUtility.getGeocodeForAddress('Laser 1199 Parque Industrial Maran','Mexicali', 'B.C.');
System.debug('Latitude: ' + geocode.latitude);
System.debug('Longitude:' + geocode.longitude);
System.debug('Status: ' + geocode.status + ': ' + geocode.statusText);
```
