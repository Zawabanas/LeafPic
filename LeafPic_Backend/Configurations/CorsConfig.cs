namespace LeafPick_Backend.Configurations
{
    public static class CorsConfig
    {
        public static void Configure(IServiceCollection services)
        {
            services.AddCors(options =>
            {
                options.AddPolicy("LeafPickCors", builder =>
                {
                    builder.WithOrigins(
                            "http://localhost:3000",  // React típico
                            "http://localhost:4200",  // Angular típico
                            "http://localhost:8080")  // Vue típico
                        .AllowAnyMethod()
                        .AllowAnyHeader()
                        .AllowCredentials()
                        .WithExposedHeaders("Token-Expired");
                });
            });
        }
    }
}