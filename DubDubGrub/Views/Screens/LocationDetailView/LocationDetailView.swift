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

                        Link(destination: URL(string: viewModel.location.websiteURL)!) {
                            LocationActionButton(color: .brandPrimary, image: "network")
                        }

                        Button {
                            viewModel.callLocation()
                        } label: {
                            LocationActionButton(color: .brandPrimary, image: "phone.fill")
                        }

                        if CloudKitManager.shared.profileRecordID != nil {
                            Button {
                                viewModel.updateCheckInStatus(to: viewModel.isCheckedIn ? .checkedOut : .checkedIn)
                            } label: {
                                LocationActionButton(
                                    color: viewModel.isCheckedIn ? .pink : .brandPrimary,
                                    image: viewModel.isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark"
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal)

                Text("Who's Here?")
                    .font(.title2).bold()

                ZStack {
                    if viewModel.checkedInProfiles.isEmpty {
                        Text("Nobody' here 😔")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding(.top, 30)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: viewModel.gridItems) {
                                ForEach(viewModel.checkedInProfiles) { profile in
                                    FirstNameAvatarView(profile: profile)
                                        .onTapGesture {
                                            viewModel.isShowingProfileModal = true
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
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .opacity(0.9)
//                    .transition(.opacity)
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
                    .zIndex(1)

                ProfileModalView(isShowingProfileModal: $viewModel.isShowingProfileModal, profile: DDGProfile(record: MockData.profile))
                    .transition(.opacity.combined(with: .slide))
                    .animation(.easeInOut)
                    .zIndex(2)
            }
        }
        .onAppear {
            viewModel.getCheckedInProfiles()
            viewModel.getCheckedInStatus()
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
        LocationDetailView(viewModel: LocationDetailViewModel(location: DDGLocation(record: MockData.location)))
    }
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
    var profile: DDGProfile

    var body: some View {
        VStack {
            AvatarView(image: profile.avatarImage, size: 64)
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
            .lineLimit(3)
            .minimumScaleFactor(0.75)
            .frame(height: 70)
            .padding(.horizontal)
    }
}
