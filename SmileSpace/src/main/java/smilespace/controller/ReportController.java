package smilespace.controller;

import smilespace.model.Report;
import smilespace.model.User;
import smilespace.service.ReportService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.util.List;

@Controller
@RequestMapping("/reports")
public class ReportController {

    private final ReportService reportService;

    public ReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    @PostMapping("/submit")
    public String submitReport(@RequestParam String type,
                               @RequestParam int targetId,
                               @RequestParam String reason,
                               HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        Report report = new Report();
        report.setReporterId(user.getUserId());
        report.setReason(reason);

        if ("post".equalsIgnoreCase(type)) {
            report.setPostId(targetId);
        } else if ("reply".equalsIgnoreCase(type)) {
            report.setReplyId(targetId);
        }

        reportService.createReport(report);
        return "redirect:/forum?reportSubmitted=true";
    }

    @GetMapping("/my")
    public String myReports(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        List<Report> myReports = reportService.getReportsByUser(user.getUserId());
        List<Report> againstMe = reportService.getReportsAgainstUser(user.getUserId());

        model.addAttribute("myReports", myReports);
        model.addAttribute("againstMe", againstMe);

        return "/peerSupportForumModule/myReports";
    }

    @GetMapping("/admin")
    public String adminReports(@RequestParam(required = false) String status, Model model) {
        List<Report> reports;
        
        if (status != null && !status.isEmpty()) {
            reports = reportService.getReportsByStatus(status);
        } else {
            reports = reportService.getAllReports();
        }
        
        model.addAttribute("reports", reports);
        return "/peerSupportForumModule/adminReports";
    }

    @PostMapping("/admin/update")
    public String updateReport(@RequestParam int reportId,
                               @RequestParam String status,
                               @RequestParam(required = false) String actionTaken) {
        reportService.updateReportStatus(reportId, status, actionTaken);
        return "redirect:/reports/admin";
    }
}
