namespace DotnetPlaces.Model{
    public class PlacesModel{
        public int id {get; set;}
        public string ownerName {get;set;} = string.Empty;
        public string placeName {get;set;}= string.Empty;
        public string address {get;set;}= string.Empty;
        public string longitude {get; set;}= string.Empty;
        public string latitude {get; set;}= string.Empty;
        public string placeType {get;set;}= string.Empty;
        public string image_url {get; set;} = string.Empty;
        public DateTime inputDate {get;set;}

    }
}