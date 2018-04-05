/**
 * Created by Salesforce on 3/16/18.
 *
 * Purpose: This class is used to model the data returned by the geocoding service
 *
 * Usage: Instantiate a new instance of this class. The constructor can handle either no inputs or key-value pairs.
 *
 */

global class GeocodeData {
    public Decimal latitude;
    public Decimal longitude;
    public String status;
    public String statusText;

    public GeocodeData(){

    }

    public GeocodeData(String aStatus, String aStatusText, Decimal aLatitude, Decimal aLongitude){
        status = aStatus;
        statusText = aStatusText;
        latitude = aLatitude;
        longitude = aLongitude;
    }

}