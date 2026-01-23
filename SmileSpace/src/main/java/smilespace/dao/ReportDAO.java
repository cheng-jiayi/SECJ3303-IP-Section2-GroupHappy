package smilespace.dao;

import smilespace.model.Report;
import java.util.List;

public interface ReportDAO {
    void createReport(Report report);
    List<Report> getAllReports();
    List<Report> getReportsByUserId(int userId);
    List<Report> getReportsAgainstUserId(int userId);
    Report getReportById(int reportId);
    void updateReportStatus(int reportId, String status, String actionTaken);
    List<Report> getReportsByStatus(String status);
}
