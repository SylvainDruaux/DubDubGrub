//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 29/01/2024.
//

import SwiftUI

struct LocationDetailView: View {
    @ObservedObject var viewModel: LocationDetailViewModel
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                BannerImageView(image: viewModel.location.bannerImage)

                HStack {
                    AddressView(address: viewModel.location.address)
                    Spacer()
                }
                .padding(.horizontal)

                DescriptionView(text: viewModel.location.description)

                ZStack {
                    Capsule()
                        .frame(height: 80)
                        .foregroundColor(Color(.secondarySystemBackground))

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
                                playHaptic()
                            } label: {
                                LocationActionButton(
                                    color: viewModel.isCheckedIn ? .pink : .brandPrimary,
                                    image: viewModel.isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark"
                                )
                                .accessibilityLabel(viewModel.isCheckedIn ? "Check out of location." : "Check into location.")
                            }
                        }
                    }
                }
                .padding(.horizontal)

                Text("Who's Here?")
                    .font(.title2).bold()
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel("How's here? \(viewModel.checkedInProfiles.count) checked in")
                    .accessibilityHint("Bottom section is scrollable.")

                ZStack {
                    if viewModel.checkedInProfiles.isEmpty {
                        Text("Nobody' here 😔")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding(.top, 30)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: determineColumns(for: sizeCategory)) {
                                ForEach(viewModel.checkedInProfiles) { profile in
                                    FirstNameAvatarView(profile: profile)
                                        .accessibilityElement(children: .ignore)
                                        .accessibilityAddTraits(.isButton)
                                        .accessibilityHint("Shows \(profile.firstName) profile pop up.")
                                        .accessibilityLabel("\(profile.firstName) \(profile.lastName)")
                                        .onTapGesture {
                                            viewModel.show(profile: profile, in: sizeCategory)
                                        }
                                }
                            }
                        }
                    }

                    if viewModel.isLoading { LoadingView() }
                }

                Spacer()
            }

            if viewModel.isShowingProfileModal {
                Color(.black)
                    .ignoresSafeArea()
                    .opacity(0.9)
//                    .transition(.opacity)
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
                    .zIndex(1)
                    .accessibilityHidden(true)

                if let selectedProfile = viewModel.selectedProfile {
                    ProfileModalView(isShowingProfileModal: $viewModel.isShowingProfileModal, profile: selectedProfile)
                        .accessibilityAddTraits(.isModal)
                        .transition(.opacity.combined(with: .slide))
                        .animation(.easeInOut)
                        .zIndex(2)
                }
            }
        }
        .onAppear {
            viewModel.getCheckedInProfiles()
            viewModel.getCheckedInStatus()
        }
        .sheet(isPresented: $viewModel.isShowingProfileSheet) {
            if let selectedProfile = viewModel.selectedProfile {
                NavigationView {
                    ProfileSheetView(profile: selectedProfile)
                        .toolbar {
                            Button("Dismiss") { viewModel.isShowingProfileSheet = false }
                        }
                }
                .accentColor(.brandPrimary)
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        LocationDetailView(viewModel: LocationDetailViewModel(location: DDGLocation(record: MockData.chipotle)))
            .embedInScrollView()
    }
    .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
}

struct LocationActionButton: View {
    var color: Color
    var image: String

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 60)
                .foregroundColor(color)

            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 22)
                .foregroundColor(.white)
        }
    }
}

struct FirstNameAvatarView: View {
    @Environment(\.sizeCategory) var sizeCategory
    var profile: DDGProfile

    var body: some View {
        VStack {
            AvatarView(
                image: profile.avatarImage,
                size: sizeCategory >= .accessibilityMedium ? 100 : 64
            )
            Text(profile.firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }
}

struct BannerImageView: View {
    var image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
            .accessibilityHidden(true)
    }
}

struct AddressView: View {
    var address: String

    var body: some View {
        Label(address, systemImage: "mappin.and.ellipse")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

struct DescriptionView: View {
    var text: String

    var body: some View {
        Text(text)
            .minimumScaleFactor(0.75)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
    }
}
