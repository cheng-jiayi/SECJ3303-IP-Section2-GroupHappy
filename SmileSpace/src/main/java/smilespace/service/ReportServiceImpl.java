package smilespace.service;

import org.springframework.stereotype.Service;
import smilespace.dao.ReportDAO;
import smilespace.model.Report;
import java.util.List;

@Service
public class ReportServiceImpl implements ReportService {

    private final ReportDAO reportDAO;

    public ReportServiceImpl(ReportDAO reportDAO) {
        this.reportDAO = reportDAO;
    }

    @Override
    public void createReport(Report report) {
        reportDAO.createReport(report);
    }

    @Override
    public List<Report> getAllReports() {
        return reportDAO.getAllReports();
    }

    @Override
    public List<Report> getReportsByUser(int userId) {
        return reportDAO.getReportsByUserId(userId);
    }

    @Override
    public List<Report> getReportsAgainstUser(int userId) {
        return reportDAO.getReportsAgainstUserId(userId);
    }

    @Override
    public Report getReportById(int reportId) {
        return reportDAO.getReportById(reportId);
    }

    @Override
    public void updateReportStatus(int reportId, String status, String actionTaken) {
        reportDAO.updateReportStatus(reportId, status, actionTaken);
    }

    @Override
    public List<Report> getReportsByStatus(String status) {
        return reportDAO.getReportsByStatus(status);
    }
}