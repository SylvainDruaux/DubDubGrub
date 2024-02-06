//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 29/01/2024.
//

import CloudKit
import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    NameBackgroundView()

                    HStack(spacing: 16) {
                        ZStack {
                            AvatarView(image: viewModel.avatar, size: 84)
                            EditImageView()
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityLabel("Profile photo.")
                        .accessibilityHint("Opens the iPhone's photo picker.")
                        .padding(.leading, 12)
                        .onTapGesture { viewModel.isShowingPhotoPicker = true }

                        VStack(spacing: 1) {
                            TextField("First Name", text: $viewModel.firstName).profileNameStyle()
                            TextField("Last Name", text: $viewModel.lastName).profileNameStyle()
                            TextField("Company Name", text: $viewModel.companyName).font(.subheadline)
                        }
                        .padding(.trailing, 16)
                    }
                    .padding()
                }

                HStack {
                    CharactersRemainView(currentCount: viewModel.bio.count)
                        .accessibilityAddTraits(.isHeader)

                    Spacer()

                    if viewModel.isCheckedIn {
                        Button {
                            viewModel.checkOut()
                            playHaptic()
                        } label: {
                            Label("Check Out", systemImage: "mappin.and.ellipse")
                                .font(.system(size: 12, weight: .semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .foregroundColor(.white)
                                .background(Color.pink)
                                .cornerRadius(8)
                        }
                        .accessibilityLabel("Check out of current location.")
                    }
                }

                TextEditor(text: $viewModel.bio)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary, lineWidth: 1)
                    )
                    .accessibilityLabel("Bio, \(viewModel.bio)")
                    .accessibilityHint("This TextField has a 100 characters maximum.")

                Spacer()

                Button {
                    viewModel.profileContext == .create ? viewModel.createProfile() : viewModel.updateProfile()
                } label: {
                    DDGButton(title: viewModel.profileContext == .create ? "Create Profile" : "Update Profile")
                }
                .padding(.bottom)
            }

            if viewModel.isLoading { LoadingView() }
        }
        .padding(.horizontal)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(DeviceTypes.isiPhone8Standard ? .inline : .automatic)
        .toolbar {
            Button {
                dismissKeyboard()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
        .onAppear {
            viewModel.getProfile()
            viewModel.getCheckedInStatus()
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
        .sheet(isPresented: $viewModel.isShowingPhotoPicker) {
            PhotoPicker(image: $viewModel.avatar)
        }
        .accentColor(.brandPrimary)
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
}

struct NameBackgroundView: View {
    var body: some View {
        Color(.secondarySystemBackground)
            .frame(height: 130)
            .cornerRadius(12)
    }
}

struct EditImageView: View {
    var body: some View {
        Image(systemName: "square.and.pencil")
            .resizable()
            .scaledToFit()
            .frame(width: 14)
            .foregroundColor(.white)
            .offset(y: 30)
    }
}

struct CharactersRemainView: View {
    var currentCount: Int

    var body: some View {
        Group {
            Text("Bio: ")
                +
                Text("\(100 - currentCount)")
                .bold().foregroundColor(currentCount <= 100 ? .brandPrimary : .pink)
                +
                Text(" characters remain")
        }
        .font(.callout)
        .foregroundColor(.secondary)
    }
}
