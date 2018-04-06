/**
 * Created by cbarbour on 4/4/18.
 *
 * Purpose: This class is used to model the data returned by the geocoding service
 *
 * Usage: Instantiate a new instance of this class.
 *
 */

global class GeocodeData {
    public Decimal latitude;
    public Decimal longitude;
    public String status;
    public String statusText;

    public GeocodeData(){

    }

}
