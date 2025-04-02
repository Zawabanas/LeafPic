using Microsoft.Extensions.Configuration;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;

namespace LeafPick_Backend.Services
{
    public interface IEmailService
    {
        Task SendEmailAsync(string to, string subject, string body);
    }

    public class EmailService : IEmailService
    {
        private readonly SmtpClient _smtpClient;
        private readonly string _fromEmail;

        public EmailService(IConfiguration configuration)
        {
            var config = configuration.GetSection("SmtpSettings");
            _fromEmail = config["FromEmail"];

            _smtpClient = new SmtpClient(config["Host"])
            {
                Port = int.Parse(config["Port"]),
                Credentials = new NetworkCredential(
                    config["Username"],
                    config["Password"]),
                EnableSsl = true,
                DeliveryMethod = SmtpDeliveryMethod.Network
            };
        }

        public async Task SendEmailAsync(string to, string subject, string body)
        {
            using var message = new MailMessage(_fromEmail, to)
            {
                Subject = subject,
                Body = body,
                IsBodyHtml = true
            };

            await _smtpClient.SendMailAsync(message);
        }
    }
}