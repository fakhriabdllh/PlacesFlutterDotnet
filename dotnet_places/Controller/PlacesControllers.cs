using DotnetPlaces.EfCore;
using DotnetPlaces.Model;
using Microsoft.AspNetCore.Mvc;

namespace DotnetPlaces.Controllers{

    [ApiController]
    public class PlacesController : ControllerBase{
        private readonly DbHelper _db;

        public PlacesController(EF_DataContext _dataContext){
            _db = new DbHelper(_dataContext);
        }

        
        [HttpGet]
        [Route("api/[Controller]/Places")]
        public IActionResult Get(){
            ResponseType type =   ResponseType.Success;
            try
            {
                IEnumerable<PlacesModel> data = _db.GetPlaces();
                if (!data.Any()){
                    type = ResponseType.NotFound;
                }
                return Ok(ResponseHandler.GetAppResponse(type,data));
            }
            catch (Exception ex){
                return BadRequest(ResponseHandler.GetExceptionResponse(ex));
            }
        }

        [HttpGet]
        [Route("api/[controller]/Places/{id}")]
        public IActionResult Get(int id)
        {
            ResponseType type = ResponseType.Success;
            try
            {
                PlacesModel data = _db.GetPlacesById(id);

                if (data == null)
                {
                    type = ResponseType.NotFound;
                }
                return Ok(ResponseHandler.GetAppResponse(type, data));
            }
            catch (Exception ex)
            { 
                return BadRequest(ResponseHandler.GetExceptionResponse(ex));
            }
        }

        [HttpPost]
        [Route("api/[controller]/Store")]
        public IActionResult Post([FromBody] PlacesModel model)
        {
            try
            {
                ResponseType type = ResponseType.Success;
                _db.AddPlaces(model);
                return Ok(ResponseHandler.GetAppResponse(type, model));
            }
            catch (Exception ex)
            {
                return BadRequest(ResponseHandler.GetExceptionResponse(ex));
            }
        }

        [HttpPut]
        [Route("api/[controller]/Update/{id}")]
        public IActionResult Put(int id, [FromBody] PlacesModel model)
        {
            try
            {
                ResponseType type = ResponseType.Success;
                model.id = id;
                _db.UpdatePlaces(model);
                return Ok(ResponseHandler.GetAppResponse(type, model));
            }
            catch (Exception ex)
            {
                return BadRequest(ResponseHandler.GetExceptionResponse(ex));
            }
        }

        [HttpDelete]
        [Route("api/[controller]/Delete/{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                ResponseType type = ResponseType.Success;
                _db.DeletePlaces(id);
                return Ok(ResponseHandler.GetAppResponse(type, "Delete Successfully"));
            }
            catch (Exception ex)
            {
                return BadRequest(ResponseHandler.GetExceptionResponse(ex));
            }
        }
    }}
