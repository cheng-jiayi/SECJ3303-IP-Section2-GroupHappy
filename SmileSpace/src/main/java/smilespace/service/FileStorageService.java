package smilespace.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class FileStorageService {
    
    @Value("${file.upload-dir:uploads}")
    private String uploadDir;
    
    public String storeFile(MultipartFile file, String subdirectory) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }
        
        Path uploadPath = Paths.get(uploadDir, subdirectory);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        String originalFilename = file.getOriginalFilename();
        String fileExtension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        
        String uniqueFilename = UUID.randomUUID().toString() + fileExtension;
        Path filePath = uploadPath.resolve(uniqueFilename);
        
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
        
        return Paths.get(subdirectory, uniqueFilename).toString().replace("\\", "/");
    }
    
    public boolean deleteFile(String filePath) throws IOException {
        if (filePath == null || filePath.trim().isEmpty()) {
            return false;
        }
        
        Path fullPath = Paths.get(uploadDir, filePath);
        if (Files.exists(fullPath)) {
            Files.delete(fullPath);
            return true;
        }
        return false;
    }
    
    public boolean fileExists(String filePath) {
        if (filePath == null || filePath.trim().isEmpty()) {
            return false;
        }
        return Files.exists(Paths.get(uploadDir, filePath));
    }
    
    public String getFileName(String filePath) {
        if (filePath == null || filePath.trim().isEmpty()) {
            return "";
        }
        return Paths.get(filePath).getFileName().toString();
    }
}