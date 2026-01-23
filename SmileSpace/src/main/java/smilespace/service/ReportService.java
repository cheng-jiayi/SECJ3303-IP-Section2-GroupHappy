package smilespace.service;

import smilespace.model.Report;
import java.util.List;

public interface ReportService {
    void createReport(Report report);
    List<Report> getAllReports();
    List<Report> getReportsByUser(int userId);
    List<Report> getReportsAgainstUser(int userId);  // NEW
    Report getReportById(int reportId);
    void updateReportStatus(int reportId, String status, String actionTaken);
    List<Report> getReportsByStatus(String status);
}