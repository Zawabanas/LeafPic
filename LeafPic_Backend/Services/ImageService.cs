using LeafPick_Backend.Data;
using LeafPick_Backend.Models.DTOs.Images;
using LeafPick_Backend.Models.Entities;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System.IO;
using System.Threading.Tasks;

namespace LeafPick_Backend.Services
{
    public interface IImageService
    {
        Task<ImageResponseDto> UploadImage(ImageUploadDto imageUpload, string userId);
        Task ProcessImage(int imageId);
    }

    public class ImageService : IImageService
    {
        private readonly ApplicationDbContext _context;
        private readonly IWebHostEnvironment _environment;

        public ImageService(
            ApplicationDbContext context,
            IWebHostEnvironment environment)
        {
            _context = context;
            _environment = environment;
        }

        public async Task<ImageResponseDto> UploadImage(ImageUploadDto imageUpload, string userId)
        {
            // Crear directorio si no existe
            var uploadsPath = Path.Combine(_environment.WebRootPath, "uploads");
            if (!Directory.Exists(uploadsPath))
                Directory.CreateDirectory(uploadsPath);

            // Generar nombre único para el archivo
            var uniqueFileName = $"{Guid.NewGuid()}_{imageUpload.File.FileName}";
            var filePath = Path.Combine(uploadsPath, uniqueFileName);

            // Guardar el archivo
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await imageUpload.File.CopyToAsync(stream);
            }

            // Guardar en base de datos
            var image = new Image
            {
                FileName = imageUpload.File.FileName,
                FilePath = filePath,
                ContentType = imageUpload.File.ContentType,
                FileSize = imageUpload.File.Length,
                UserId = userId,
                Title = imageUpload.Title,
                Description = imageUpload.Description
            };

            _context.Images.Add(image);
            await _context.SaveChangesAsync();

            return new ImageResponseDto
            {
                Id = image.Id,
                FileName = image.FileName,
                FileUrl = $"/uploads/{uniqueFileName}",
                ContentType = image.ContentType,
                FileSize = image.FileSize,
                Title = image.Title,
                Description = image.Description,
                UploadDate = image.UploadDate
            };
        }

        public async Task ProcessImage(int imageId)
        {
            var image = await _context.Images.FindAsync(imageId);
            if (image == null) return;

            // Aquí iría la lógica de procesamiento de imágenes
            // Ejemplo: análisis con IA, detección de hojas, etc.

            // Simulación de procesamiento
            await Task.Delay(2000); // Simula procesamiento

            image.ProcessingResult = "Procesamiento completado - Resultados simulados";
            image.Processed = true;

            await _context.SaveChangesAsync();
        }
    }
}