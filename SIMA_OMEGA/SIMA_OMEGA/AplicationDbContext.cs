using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using SIMA_OMEGA.Entities;
using Microsoft.AspNetCore.Identity;

namespace SIMA_OMEGA
{
    public class ApplicationUser : IdentityUser
    {
        public string? ProfileImage { get; set; }
    }
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

        // Aquí agregaremos DbSet para cada entidad, por ejemplo:
        //public DbSet<Faction> Factions { get; set; }
        //public DbSet<Character> Characters { get; set; }
        //public DbSet<Unit> Units { get; set; }

    }
}
