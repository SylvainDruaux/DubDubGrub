//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 29/01/2024.
//

import SwiftUI

struct LocationDetailView: View {
    @ObservedObject var viewModel: LocationDetailViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                BannerImageView(image: viewModel.location.bannerImage)
                AddressHStack(address: viewModel.location.address)
                DescriptionView(text: viewModel.location.description)
                ActionButtonHStack(viewModel: viewModel)
                GridHeaderTextView(number: viewModel.checkedInProfiles.count)
                AvatarGridView(viewModel: viewModel)
            }

            if viewModel.isShowingProfileModal {
                FullScreenBlackTransparencyView()

                if let selectedProfile = viewModel.selectedProfile {
                    ProfileModalView(isShowingProfileModal: $viewModel.isShowingProfileModal, profile: selectedProfile)
                }
            }
        }
        .task {
            viewModel.getCheckedInProfiles()
            viewModel.getCheckedInStatus()
        }
        .sheet(isPresented: $viewModel.isShowingProfileSheet) {
            if let selectedProfile = viewModel.selectedProfile {
                NavigationStack {
                    ProfileSheetView(profile: selectedProfile)
                        .toolbar {
                            Button("Dismiss") { viewModel.isShowingProfileSheet = false }
                        }
                }
            }
        }
        .alert(item: $viewModel.alertItem) { $0.alert }
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LocationDetailView(viewModel: LocationDetailViewModel(location: DDGLocation(record: MockData.chipotle)))
    }
}

private struct LocationActionButton: View {
    var color: Color
    var image: String

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    .brandPrimary
                        .gradient
                        .shadow(.drop(color: .black.opacity(0.5), radius: 5, x: 2, y: 2))
                )
                .frame(width: 60, height: 60)

            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(.white)
        }
    }
}

private struct FirstNameAvatarView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    var profile: DDGProfile

    var body: some View {
        VStack {
            AvatarView(
                image: profile.avatarImage,
                size: dynamicTypeSize >= .accessibility3 ? 100 : 64
            )
            Text(profile.firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Shows \(profile.firstName) profile pop up.")
        .accessibilityLabel("\(profile.firstName) \(profile.lastName)")
    }
}

private struct BannerImageView: View {
    var image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
            .accessibilityHidden(true)
    }
}

private struct AddressHStack: View {
    var address: String

    var body: some View {
        HStack {
            Label(address, systemImage: "mappin.and.ellipse")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding(.horizontal)
    }
}

private struct DescriptionView: View {
    var text: String

    var body: some View {
        Text(text)
            .minimumScaleFactor(0.75)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
    }
}

private struct ActionButtonHStack: View {
    @ObservedObject var viewModel: LocationDetailViewModel

    var body: some View {
        HStack(spacing: 20) {
            Button {
                viewModel.getDirectionsToLocation()
            } label: {
                LocationActionButton(color: .brandPrimary, image: "location.fill")
            }
            .accessibilityLabel("Get directions.")

            Link(destination: URL(string: viewModel.location.websiteURL)!) {
                LocationActionButton(color: .brandPrimary, image: "network")
            }
            .accessibilityRemoveTraits(.isButton)
            .accessibilityLabel("Go to website.")

            Button {
                viewModel.callLocation()
            } label: {
                LocationActionButton(color: .brandPrimary, image: "phone.fill")
            }
            .accessibilityLabel("Call location.")

            if CloudKitManager.shared.profileRecordID != nil {
                Button {
                    viewModel.updateCheckInStatus(to: viewModel.isCheckedIn ? .checkedOut : .checkedIn)
                } label: {
                    LocationActionButton(color: viewModel.buttonColor, image: viewModel.buttonImageTitle)
                }
                .accessibilityLabel(viewModel.buttonA11yLabel)
                .disabled(viewModel.isLoading)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(Color(.secondarySystemBackground))
        .clipShape(.capsule)
    }
}

private struct GridHeaderTextView: View {
    var number: Int

    var body: some View {
        Text("Who's Here?")
            .font(.title2).bold()
            .accessibilityAddTraits(.isHeader)
            .accessibilityLabel("How's here? \(number) checked in")
            .accessibilityHint("Bottom section is scrollable.")
    }
}

private struct GridEmptyStateTextView: View {
    var body: some View {
        VStack {
            Text("Nobody' here 😔")
                .bold()
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.top, 30)

            Spacer()
        }
    }
}

private struct FullScreenBlackTransparencyView: View {
    var body: some View {
        Color(.black)
            .ignoresSafeArea()
            .opacity(0.9)
            .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
            .zIndex(1)
            .accessibilityHidden(true)
    }
}

private struct AvatarGridView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @ObservedObject var viewModel: LocationDetailViewModel

    var body: some View {
        ZStack {
            if viewModel.checkedInProfiles.isEmpty {
                GridEmptyStateTextView()
            } else {
                ScrollView {
                    LazyVGrid(columns: determineColumns(for: dynamicTypeSize)) {
                        ForEach(viewModel.checkedInProfiles) { profile in
                            FirstNameAvatarView(profile: profile)
                                .onTapGesture {
                                    withAnimation { viewModel.show(profile, in: dynamicTypeSize) }
                                }
                        }
                    }
                }
            }

            if viewModel.isLoading { LoadingView() }
        }
    }
}
