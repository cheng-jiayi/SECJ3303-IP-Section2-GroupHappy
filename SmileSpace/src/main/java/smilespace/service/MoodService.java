package smilespace.service;

import smilespace.model.MoodEntry;
import smilespace.model.MoodWeeklySummary;
import java.time.LocalDate;
import java.time.DayOfWeek;
import java.util.*;
import java.util.stream.Collectors;

public class MoodService {
    private List<MoodEntry> moodEntries = new ArrayList<>();
    private int nextId = 1;

    public MoodService() {
        initializeSampleData();
    }

    private void initializeSampleData() {
        // Sample data with lowercase tags to match checkbox values
        List<String> feelings1 = Arrays.asList("Stressed", "Anxious");
        Set<String> tags1 = new HashSet<>(Arrays.asList("exam_stress", "group_project", "overwhelmed"));
        
        MoodEntry entry1 = new MoodEntry();
        entry1.setFeelings(feelings1);
        entry1.setReflection("I've been working on my project all night");
        entry1.setTags(tags1);
        entry1.setEntryDate(LocalDate.of(2025, 11, 7));
        
        List<String> feelings2 = Arrays.asList("Happy", "Relaxed");
        Set<String> tags2 = new HashSet<>(Arrays.asList("friends", "weekend", "good_day"));
        
        MoodEntry entry2 = new MoodEntry();
        entry2.setFeelings(feelings2);
        entry2.setReflection("Had a great time with friends");
        entry2.setTags(tags2);
        entry2.setEntryDate(LocalDate.of(2025, 11, 6));

        addMoodEntry(entry1);
        addMoodEntry(entry2);
    }

    public void addMoodEntry(MoodEntry entry) {
        entry.setId(nextId++);
        moodEntries.add(entry);
    }

    public List<MoodEntry> getAllMoodEntries() {
        return new ArrayList<>(moodEntries);
    }

    public MoodEntry getLatestMoodEntry() {
        if (moodEntries.isEmpty()) {
            return null;
        }
        return moodEntries.stream()
                .max(Comparator.comparing(MoodEntry::getEntryDate))
                .orElse(moodEntries.get(moodEntries.size() - 1));
    }

    public Map<String, Integer> getMoodTrends() {
        Map<String, Integer> trends = new HashMap<>();
        for (MoodEntry entry : moodEntries) {
            String primaryFeeling = entry.getFeelings().isEmpty() ? "Unknown" : entry.getFeelings().get(0);
            trends.put(primaryFeeling, trends.getOrDefault(primaryFeeling, 0) + 1);
        }
        return trends;
    }

    public MoodWeeklySummary getWeeklySummary(LocalDate date) {
        LocalDate weekStart = date.with(DayOfWeek.MONDAY);
        LocalDate weekEnd = weekStart.plusDays(6);
        
        List<MoodEntry> weekEntries = moodEntries.stream()
                .filter(entry -> !entry.getEntryDate().isBefore(weekStart) && 
                                !entry.getEntryDate().isAfter(weekEnd))
                .collect(Collectors.toList());

        MoodWeeklySummary summary = new MoodWeeklySummary();
        summary.setWeekStart(weekStart);
        summary.setWeekEnd(weekEnd);
        summary.setTotalEntries(weekEntries.size());

        if (!weekEntries.isEmpty()) {
            // Calculate dominant feeling
            Map<String, Long> feelingCounts = weekEntries.stream()
                    .flatMap(entry -> entry.getFeelings().stream())
                    .collect(Collectors.groupingBy(feeling -> feeling, Collectors.counting()));
            
            String dominantFeeling = feelingCounts.entrySet().stream()
                    .max(Map.Entry.comparingByValue())
                    .map(Map.Entry::getKey)
                    .orElse("No data");
            summary.setDominantMood(dominantFeeling);

            // Calculate most frequent tags
            Map<String, Long> tagCounts = weekEntries.stream()
                    .flatMap(entry -> entry.getTags().stream())
                    .collect(Collectors.groupingBy(tag -> tag, Collectors.counting()));
            
            List<String> topTags = tagCounts.entrySet().stream()
                    .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
                    .limit(3)
                    .map(Map.Entry::getKey)
                    .collect(Collectors.toList());
            summary.setMostFrequentTags(topTags);

            // Calculate mood stability
            double stability = calculateMoodStability(weekEntries);
            summary.setMoodStability(stability);
        }

        return summary;
    }

    private double calculateMoodStability(List<MoodEntry> entries) {
        if (entries.size() <= 1) return 100.0;
        
        int changes = 0;
        String previousPrimaryFeeling = entries.get(0).getFeelings().isEmpty() ? "" : entries.get(0).getFeelings().get(0);
        
        for (int i = 1; i < entries.size(); i++) {
            String currentPrimaryFeeling = entries.get(i).getFeelings().isEmpty() ? "" : entries.get(i).getFeelings().get(0);
            if (!currentPrimaryFeeling.equals(previousPrimaryFeeling)) {
                changes++;
            }
            previousPrimaryFeeling = currentPrimaryFeeling;
        }
        
        double stability = 100.0 - ((double) changes / (entries.size() - 1)) * 100.0;
        return Math.round(stability * 10.0) / 10.0;
    }
}