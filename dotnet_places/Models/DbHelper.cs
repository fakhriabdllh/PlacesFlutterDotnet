using DotnetPlaces.EfCore;

namespace DotnetPlaces.Model{
    public class DbHelper{
        private EF_DataContext _context;
        public DbHelper(EF_DataContext context){
            _context = context;
        }
        public List<PlacesModel> GetPlaces(){
            List<PlacesModel> response = new List<PlacesModel>();
            var dataList = _context.Places.ToList();
            dataList.ForEach(data => response.Add(new PlacesModel(){
                id=data.id,
                ownerName = data.ownerName,
                placeName = data.placeName,
                address = data.address,
                longitude = data.longitude,
                latitude = data.latitude,
                placeType = data.placeType,
                image_url = data.image_url,
                inputDate = data.inputDate,
            })) ;
            return response;
        }

         public PlacesModel GetPlacesById(int id)
        {
            PlacesModel response = new PlacesModel();
            var data = _context.Places.Where(d=>d.id.Equals(id)).FirstOrDefault();
            return new PlacesModel() {
                id = data!.id,
                ownerName = data.ownerName,
                placeName = data.placeName,
                address = data.address,
                longitude = data.longitude,
                latitude = data.latitude,
                placeType = data.placeType,
                image_url = data.image_url,
                inputDate = data.inputDate,
            }; 
        }

        public void AddPlaces(PlacesModel placesModel)
        {
            Places dbTable = new Places();
            dbTable.ownerName = placesModel.ownerName;
            dbTable.placeName = placesModel.placeName;
            dbTable.address = placesModel.address;
            dbTable.longitude = placesModel.longitude;
            dbTable.latitude = placesModel.latitude;
            dbTable.placeType = placesModel.placeType;
            dbTable.image_url = placesModel.image_url;
            dbTable.inputDate = DateTime.UtcNow;
           
             _context.Places.Add(dbTable);
            _context.SaveChanges();
        }

        public void UpdatePlaces(PlacesModel placesModel)
        {
            Places dbTable = new Places();
            //PUT
            dbTable = _context.Places.Where(d => d.id.Equals(placesModel.id)).FirstOrDefault()!;
            if(dbTable != null)
            {
                dbTable.ownerName = placesModel.ownerName;
                dbTable.placeName = placesModel.placeName;
                dbTable.address = placesModel.address;
                dbTable.longitude = placesModel.longitude;
                dbTable.latitude = placesModel.latitude;
                dbTable.placeType = placesModel.placeType;
                dbTable.image_url = placesModel.image_url;
                dbTable.inputDate = DateTime.UtcNow;
            }      
            _context.SaveChanges();
        }

          public void DeletePlaces(int id)
        {
            var places = _context.Places.Where(d => d.id.Equals(id)).FirstOrDefault();
            if (places != null)
            {
                _context.Places.Remove(places);
                _context.SaveChanges();
            }
        }
    }
}