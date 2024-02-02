using Microsoft.EntityFrameworkCore;

namespace DotnetPlaces.EfCore
{
     public class EF_DataContext : DbContext
    {
        public EF_DataContext(DbContextOptions<EF_DataContext> options): base(options) { }
       
        public DbSet<Places> Places { get; set; }

    }
}
