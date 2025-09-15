import SwiftUI
import UserNotifications

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingColorPicker = false
    @State private var notificationsEnabled = false
    @State private var reminderTime = Date()
    @State private var showingNotificationAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // Appearance Section
                Section("Appearance") {
                    // Dark mode toggle
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        
                        Toggle("Dark Mode", isOn: $themeManager.isDarkMode)
                    }
                    
                    // Accent color
                    HStack {
                        Image(systemName: "paintbrush.fill")
                            .foregroundColor(.purple)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Accent Color")
                            Text("Current: \(getCurrentColorName())")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showingColorPicker = true
                        }) {
                            Circle()
                                .fill(themeManager.accentColor)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                }
                
                // Notifications Section
                Section("Notifications") {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.orange)
                            .frame(width: 24)
                        
                        Toggle("Daily Reminders", isOn: $notificationsEnabled)
                            .onChange(of: notificationsEnabled) { enabled in
                                if enabled {
                                    requestNotificationPermission()
                                } else {
                                    disableNotifications()
                                }
                            }
                    }
                    
                    if notificationsEnabled {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.green)
                                .frame(width: 24)
                            
                            DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                .onChange(of: reminderTime) { _ in
                                    updateNotificationSchedule()
                                }
                        }
                    }
                }
                
                // Data Section
                Section("Data") {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Export Data")
                            Text("Download your expense data")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // TODO: Implement data export
                    }
                    
                    HStack {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Clear All Data")
                            Text("This action cannot be undone")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // TODO: Implement data clearing
                    }
                }
                
                // About Section
                Section("About") {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Version")
                            Text("1.0.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Made with ❤️")
                            Text("PocketWatch - Mindful spending")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                checkNotificationStatus()
            }
            .sheet(isPresented: $showingColorPicker) {
                ColorPickerSheet()
            }
            .alert("Notifications Permission Required", isPresented: $showingNotificationAlert) {
                Button("Settings") {
                    openAppSettings()
                }
                Button("Cancel", role: .cancel) {
                    notificationsEnabled = false
                }
            } message: {
                Text("Please enable notifications in Settings to receive daily reminders.")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func getCurrentColorName() -> String {
        for (name, color) in ThemeManager.predefinedColors {
            if color == themeManager.accentColor {
                return name
            }
        }
        return "Custom"
    }
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationsEnabled = settings.authorizationStatus == .authorized
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    scheduleDailyReminder()
                } else {
                    notificationsEnabled = false
                    if error == nil {
                        showingNotificationAlert = true
                    }
                }
            }
        }
    }
    
    private func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "PocketWatch Reminder"
        content.body = "Don't forget to log your expenses today! 📱"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: reminderTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    private func updateNotificationSchedule() {
        if notificationsEnabled {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            scheduleDailyReminder()
        }
    }
    
    private func disableNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

struct ColorPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Choose Accent Color")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                    ForEach(Array(ThemeManager.predefinedColors.keys.sorted()), id: \.self) { colorName in
                        let color = ThemeManager.predefinedColors[colorName]!
                        let isSelected = color == themeManager.accentColor
                        
                        Button(action: {
                            themeManager.setAccentColor(color)
                            dismiss()
                        }) {
                            VStack(spacing: 8) {
                                Circle()
                                    .fill(color)
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Circle()
                                            .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 3)
                                    )
                                
                                Text(colorName)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Accent Color")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
