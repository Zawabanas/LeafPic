using LeafPick_Backend.Services;
using Microsoft.Extensions.DependencyInjection;

namespace LeafPick_Backend.Configurations
{
    public static class EmailConfig
    {
        public static void Configure(IServiceCollection services, IConfiguration configuration)
        {
            services.Configure<SmtpSettings>(configuration.GetSection("SmtpSettings"));
            services.AddSingleton<IEmailService, EmailService>();

            // Configuración adicional para templates
            services.AddScoped<EmailTemplateService>();
        }
    }
}

public class SmtpSettings
{
    public string Host { get; set; }
    public int Port { get; set; }
    public string Username { get; set; }
    public string Password { get; set; }
    public string FromEmail { get; set; }
    public string FromName { get; set; }
    public bool EnableSsl { get; set; }
    public int Timeout { get; set; }
}