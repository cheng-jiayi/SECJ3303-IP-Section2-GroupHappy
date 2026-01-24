package smilespace.dao;

import smilespace.model.Report;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ReportDAOImpl implements ReportDAO {

    private final JdbcTemplate jdbcTemplate;

    public ReportDAOImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void createReport(Report report) {
        String sql = "INSERT INTO reports(reporter_id, post_id, reply_id, reason) VALUES(?,?,?,?)";
        jdbcTemplate.update(sql,
                report.getReporterId(),
                report.getPostId(),
                report.getReplyId(),
                report.getReason());
    }

    @Override
    public List<Report> getAllReports() {
        String sql = "SELECT r.*, u.full_name FROM reports r JOIN users u ON r.reporter_id = u.user_id ORDER BY r.created_at DESC";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Report report = new Report();
            report.setReportId(rs.getInt("report_id"));
            report.setReporterId(rs.getInt("reporter_id"));
            report.setReporterName(rs.getString("full_name"));
            report.setPostId(rs.getObject("post_id", Integer.class));
            report.setReplyId(rs.getObject("reply_id", Integer.class));
            report.setReason(rs.getString("reason"));
            report.setStatus(rs.getString("status"));
            report.setActionTaken(rs.getString("action_taken"));
            report.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            if (rs.getTimestamp("updated_at") != null)
                report.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
            return report;
        });
    }

    @Override
    public List<Report> getReportsByUserId(int userId) {
        String sql = "SELECT r.*, u.full_name FROM reports r JOIN users u ON r.reporter_id = u.user_id WHERE r.reporter_id = ? ORDER BY r.created_at DESC";
        return jdbcTemplate.query(sql, new Object[]{userId}, (rs, rowNum) -> {
            Report report = new Report();
            report.setReportId(rs.getInt("report_id"));
            report.setReporterId(rs.getInt("reporter_id"));
            report.setReporterName(rs.getString("full_name"));
            report.setPostId(rs.getObject("post_id", Integer.class));
            report.setReplyId(rs.getObject("reply_id", Integer.class));
            report.setReason(rs.getString("reason"));
            report.setStatus(rs.getString("status"));
            report.setActionTaken(rs.getString("action_taken"));
            report.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            if (rs.getTimestamp("updated_at") != null)
                report.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
            return report;
        });
    }

    @Override
    public List<Report> getReportsAgainstUserId(int userId) {
        String sql =
            "SELECT r.*, u.full_name " +
            "FROM reports r " +
            "JOIN users u ON r.reporter_id = u.user_id " +
            "LEFT JOIN posts p ON r.post_id = p.post_id " +
            "LEFT JOIN replies rp ON r.reply_id = rp.reply_id " +
            "WHERE (p.user_id = ? OR rp.user_id = ?) " +
            "OR r.status IN ('RESOLVED', 'DISMISSED', 'REPORTED')" +
            "ORDER BY r.created_at DESC";

        return jdbcTemplate.query(sql, new Object[]{userId, userId}, (rs, rowNum) -> {
            Report report = new Report();
            report.setReportId(rs.getInt("report_id"));
            report.setReporterId(rs.getInt("reporter_id"));
            report.setReporterName(rs.getString("full_name"));
            report.setPostId(rs.getObject("post_id", Integer.class));
            report.setReplyId(rs.getObject("reply_id", Integer.class));
            report.setReason(rs.getString("reason"));
            report.setStatus(rs.getString("status"));
            report.setActionTaken(rs.getString("action_taken"));
            report.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            if (rs.getTimestamp("updated_at") != null)
                report.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
            return report;
        });
    }

    @Override
    public Report getReportById(int reportId) {
        String sql = "SELECT * FROM reports WHERE report_id = ?";
        return jdbcTemplate.queryForObject(sql, new Object[]{reportId}, (rs, rowNum) -> {
            Report report = new Report();
            report.setReportId(rs.getInt("report_id"));
            report.setReporterId(rs.getInt("reporter_id"));
            report.setPostId(rs.getObject("post_id", Integer.class));
            report.setReplyId(rs.getObject("reply_id", Integer.class));
            report.setReason(rs.getString("reason"));
            report.setStatus(rs.getString("status"));
            report.setActionTaken(rs.getString("action_taken"));
            report.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            if (rs.getTimestamp("updated_at") != null)
                report.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
            return report;
        });
    }

    @Override
    public void updateReportStatus(int reportId, String status, String actionTaken) {
        Report report = getReportById(reportId);
        
        if ("RESOLVED".equalsIgnoreCase(status)) {
            if (report.getPostId() != null) {
                String deletePostSql = "DELETE FROM posts WHERE post_id = ?";
                jdbcTemplate.update(deletePostSql, report.getPostId());
            } else if (report.getReplyId() != null) {
                String deleteReplySql = "DELETE FROM replies WHERE reply_id = ?";
                jdbcTemplate.update(deleteReplySql, report.getReplyId());
            }
        }
        
        String updateSql = "UPDATE reports SET status = ?, action_taken = ?, updated_at = NOW() WHERE report_id = ?";
        jdbcTemplate.update(updateSql, status, actionTaken, reportId);
    }

    @Override
    public List<Report> getReportsByStatus(String status) {
        String sql = "SELECT r.*, u.full_name FROM reports r JOIN users u ON r.reporter_id = u.user_id WHERE r.status = ? ORDER BY r.created_at DESC";
        return jdbcTemplate.query(sql, new Object[]{status}, (rs, rowNum) -> {
            Report report = new Report();
            report.setReportId(rs.getInt("report_id"));
            report.setReporterId(rs.getInt("reporter_id"));
            report.setReporterName(rs.getString("full_name"));
            report.setPostId(rs.getObject("post_id", Integer.class));
            report.setReplyId(rs.getObject("reply_id", Integer.class));
            report.setReason(rs.getString("reason"));
            report.setStatus(rs.getString("status"));
            report.setActionTaken(rs.getString("action_taken"));
            report.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            if (rs.getTimestamp("updated_at") != null)
                report.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
            return report;
        });
    }
}
