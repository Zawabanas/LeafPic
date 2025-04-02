using LeafPick_Backend.Configurations;
using LeafPick_Backend.Data;
using LeafPick_Backend.Models.Entities;
using LeafPick_Backend.Services;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Configuración de Serilog
Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Information()
    .WriteTo.Console()
    .WriteTo.File("Logs/log-.txt", rollingInterval: RollingInterval.Day)
    .CreateLogger();

builder.Host.UseSerilog();

try
{
    Log.Information("Iniciando LeafPick_Backend...");

    // Configuración de servicios
    builder.Services.AddControllers();

    builder.Services.AddSingleton<IEmailService, EmailService>();
    builder.Services.AddScoped<IImageService, ImageService>();

    // Configuración para manejo de archivos grandes
    builder.Services.Configure<FormOptions>(options =>
    {
        options.MultipartBodyLengthLimit = 52428800; // 50MB
    });

    // Configuración de Identity
    builder.Services.AddIdentity<ApplicationUser, IdentityRole>(options =>
    {
        options.Password.RequireDigit = true;
        options.Password.RequiredLength = 8;
        options.Password.RequireNonAlphanumeric = false;
        options.Password.RequireUppercase = true;
        options.Password.RequireLowercase = true;

        options.User.RequireUniqueEmail = true;
        options.SignIn.RequireConfirmedEmail = false; // Cambiar a true si usas confirmación por email
    })
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();

    // Configuración de cookies (opcional)
    builder.Services.ConfigureApplicationCookie(options =>
    {
        options.Cookie.HttpOnly = true;
        options.ExpireTimeSpan = TimeSpan.FromMinutes(60);
        options.LoginPath = "/Account/Login";
        options.AccessDeniedPath = "/Account/AccessDenied";
        options.SlidingExpiration = true;
    });

    // Configuraciones personalizadas
    DatabaseConfig.Configure(builder.Services, builder.Configuration);
    JwtConfig.Configure(builder.Services, builder.Configuration);
    SwaggerConfig.Configure(builder.Services);
    CorsConfig.Configure(builder.Services);

    var app = builder.Build();

    // Configurar pipeline HTTP
    app.UseStaticFiles(); //  Correcto: ahora 'app' está definido

    if (app.Environment.IsDevelopment())
    {
        app.UseSwagger();
        app.UseSwaggerUI();
    }

    app.UseHttpsRedirection();
    app.UseCors("LeafPickCors");
    app.UseAuthentication();
    app.UseAuthorization();

    app.MapControllers();

    // Aplicar migraciones automáticamente (solo para desarrollo)
    if (app.Environment.IsDevelopment())
    {
        using var scope = app.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        await db.Database.MigrateAsync(); //  Usar MigrateAsync en lugar de Migrate
    }

    // Inicializar base de datos
    using (var scope = app.Services.CreateScope())
    {
        var services = scope.ServiceProvider;
        try
        {
            await AppDbInitializer.InitializeAsync(services, app.Configuration); //  Agregado 'await'
        }
        catch (Exception ex)
        {
            var logger = services.GetRequiredService<ILogger<Program>>();
            logger.LogError(ex, "Error inicializando la base de datos");
        }
    }

    Log.Information("Backend listo para recibir peticiones");
    await app.RunAsync(); //  Usar RunAsync para consistencia
}
catch (Exception ex)
{
    Log.Fatal(ex, "Error al iniciar la aplicación");
}
finally
{
    Log.CloseAndFlush();
}