/**
 * Created by cbarbour on 2/20/18.
 */

public with sharing class GeocodeUtility {

    public static void rerunGeocodeService(){

    }

    public static void clearGeocode(){

    }

    private static void restoreAddress(){

        //Deserialize JSON to restore the addresses

    }

    private static void forceAddressUpdate(){
        oldCity = wo.City;
        wo.City = '';
        update wo;

        //Serialize historical values for later use

    }

    //WorkOrder wo = [select Id, City, Latitude, Longitude from WorkOrder WHERE City !='' AND Latitude = 0 Limit 1];
//String oldCity = wo.City;

//System.debug('Geo before: ' + wo.Latitude + ', ' + wo.Longitude);

    resetGeocode();
//forceAddressUpdate();
//restoreAddress();


//System.debug('Geo after: ' + wo.Latitude + ', ' + wo.Longitude);


void resetGeocode(){
WorkOrder wo2 = [select Id, City, State, StateCode, PostalCode, Address, Latitude, Longitude, LastModifiedDate from WorkOrder WHERE Id = '0WOB00000002P70OAE'];
wo2.Latitude = null;
wo2.Longitude = null;
update wo2;
}


void restoreAddress(){
//wo.City = oldCity;
//update wo;
}

}