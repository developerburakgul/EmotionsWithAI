//
//  SettingsView.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 3.06.2025.
//
import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    @EnvironmentObject var container: DependencyContainer
    @State private var showPremiumView = false

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                mainContent
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.large)
                    .overlay {
                        if viewModel.isLoading {
                            ProgressView("Loading...")
                                .progressViewStyle(.circular)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }
                    }
                    .alert("Error", isPresented: .init(
                        get: { viewModel.errorMessage != nil },
                        set: { _ in viewModel.errorMessage = nil }
                    )) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text(viewModel.errorMessage ?? "Unknown Error")
                    }
                    .fileImporter(
                        isPresented: $viewModel.showFileImporterForImport,
                        allowedContentTypes: [.json]
                    ) { result in
                        do {
                            let selectedFileURL = try result.get()
                            Task { await viewModel.importData(from: selectedFileURL) }
                        } catch {
                            viewModel.errorMessage = "Error on file selection: \(error.localizedDescription)"
                        }
                    }
                    .fileExporter(
                        isPresented: $viewModel.showFileImporterForExport,
                        document: JSONDocument(),
                        contentType: .json,
                        defaultFilename: "UserData_\(viewModel.username).json"
                    ) { result in
                        do {
                            let selectedFileURL = try result.get()
                            Task { await viewModel.exportData(to: selectedFileURL) }
                        } catch {
                            viewModel.errorMessage = "File export failed: \(error.localizedDescription)"
                        }
                    }
                    .sheet(isPresented: $viewModel.shouldNavigateToPremium) {
                        PremiumUpgradeView(
                            viewModel: .init(container: container)
                        )
                    }
            }
            .onAppear {
                viewModel.fetchUserData()
            }
            
            
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        Form {
            Section("User Information") {
                userInfo
                totalRequestsCell
                usageRequestsCell
                remainingRequestsCell
            }
            
            Section("Premium") {
                premiumStatus
            }

            Section("App Settings") {
                language
            }

            Section {
                if viewModel.isPremium {
                    importSection
                    exportSection
                    cloudStorageSection
                } else {
                    importSection
                        .opacity(0.5)
                        .disabled(true)
                    exportSection
                        .opacity(0.5)
                        .disabled(true)
                    cloudStorageSection
                        .opacity(0.5)
                        .disabled(true)
                }
            } header: {
                HStack(spacing: 6) {
                    Text(viewModel.isPremium ? "Data" : "Data (Premium Only)")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)
                    if !viewModel.isPremium {
                        Image(systemName: "lock.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .tint(.blue)
    }

    private var userInfo: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.fill")
                .foregroundStyle(.blue)
                .frame(width: 24)
            Text("Username")
            Spacer()
            Text(viewModel.username)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Username: \(viewModel.username)")
    }

    private var totalRequestsCell: some View {
        HStack(spacing: 12) {
            Image(systemName: "arrow.up.arrow.down")
                .foregroundStyle(.orange)
                .frame(width: 24)
            Text("Total Requests")
            Spacer()
            Text("\(viewModel.totalRequests)")
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Total Requests: \(viewModel.totalRequests)")
    }

    private var usageRequestsCell: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .frame(width: 24)
            Text("Used Requests")
            Spacer()
            Text("\(viewModel.usedRequests)")
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Used Requests: \(viewModel.usedRequests)")
    }

    private var remainingRequestsCell: some View {
        HStack(spacing: 12) {
            Image(systemName: "hourglass")
                .foregroundStyle(viewModel.remainingRequests < 5 ? .red : .blue)
                .frame(width: 24)
            Text("Remaining Requests")
            Spacer()
            Text("\(viewModel.remainingRequests)")
                .foregroundStyle(viewModel.remainingRequests < 5 ? .red : .secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Remaining Requests: \(viewModel.remainingRequests)")
    }

    private var premiumStatus: some View {
        HStack(spacing: 12) {
            Image(systemName: "crown.fill")
                .foregroundStyle(.yellow)
                .frame(width: 24)
            Text("Premium Status")
            Spacer()
            if viewModel.isPremium {
                Text("Active")
                    .foregroundStyle(.green)
                    .font(.subheadline.weight(.semibold))
            } else {
                Button(action: {
                    viewModel.goToPremiumPage()
                }) {
                    Text("Go Premium")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .accessibilityLabel("Go to premium upgrade")
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Premium Status: \(viewModel.isPremium ? "Active" : "Not active, go to premium upgrade")")
    }

    private var language: some View {
        HStack(spacing: 12) {
            Image(systemName: "globe")
                .foregroundStyle(.blue)
                .frame(width: 24)
            Text("Language")
            Spacer()
            Menu {
                Picker("", selection: $viewModel.selectedLanguage) {
                    ForEach(viewModel.allLanguages) { language in
                        Text(language.languageModel.name)
                            .tag(language)
                    }
                }
            } label: {
                Text(viewModel.selectedLanguage.languageModel.name)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityLabel("Language: \(viewModel.selectedLanguage.languageModel.name)")
    }

    private var importSection: some View {
        Button(action: {
            viewModel.showFileImporterForImport = true
        }) {
            HStack(spacing: 12) {
                Text("Import")
                Spacer()
                Image(systemName: "square.and.arrow.down.on.square.fill")
                    .foregroundStyle(.blue)
                    .frame(width: 24)
            }
        }
        .accessibilityLabel("Import user data")
    }

    private var exportSection: some View {
        Button(action: {
            viewModel.showFileImporterForExport = true
        }) {
            HStack(spacing: 12) {
                Text("Export")
                Spacer()
                Image(systemName: "square.and.arrow.up.on.square.fill")
                    .foregroundStyle(.blue)
                    .frame(width: 24)
            }
        }
        .accessibilityLabel("Export user data")
    }

    private var cloudStorageSection: some View {
        Button(action: {
            viewModel.errorMessage = "Cloud storage feature coming soon!"
        }) {
            HStack(spacing: 12) {
                Text("Cloud Storage")
                Spacer()
                Image(systemName: "externaldrive.badge.icloud")
                    .foregroundStyle(.blue)
                    .frame(width: 24)
            }
        }
        .accessibilityLabel("Access cloud storage")
    }
}

struct JSONDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    static var writableContentTypes: [UTType] { [.json] }
    
    init() {}
    
    init(configuration: ReadConfiguration) throws {}
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        throw GenericError.detail("Not found")
    }
}

#Preview {
    let container = DevPreview.shared.container
    return SettingsView(viewModel: .init(container: container))
        .previewEnvironmentObject()
}
