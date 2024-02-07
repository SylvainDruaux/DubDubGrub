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
                HStack(spacing: 16) {
                    ProfileImageView(image: viewModel.avatar)
                        .onTapGesture { viewModel.isShowingPhotoPicker = true }

                    VStack(spacing: 1) {
                        TextField("First Name", text: $viewModel.firstName).profileNameStyle()
                        TextField("Last Name", text: $viewModel.lastName).profileNameStyle()
                        TextField("Company Name", text: $viewModel.companyName).font(.subheadline)
                    }
                    .padding(.trailing, 16)
                }
                .padding(.vertical)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                HStack {
                    CharactersRemainView(currentCount: viewModel.bio.count)
                        .accessibilityAddTraits(.isHeader)

                    Spacer()

                    if viewModel.isCheckedIn {
                        Button {
                            viewModel.checkOut()
                        } label: {
                            CheckOutButton()
                        }
                        .accessibilityLabel("Check out of current location.")
                        .disabled(viewModel.isLoading)
                    }
                }

                BioTextEditor(text: $viewModel.bio)
                    .accessibilityLabel("Bio, \(viewModel.bio)")

                Spacer()

                Button {
                    viewModel.buttonAction
                } label: {
                    DDGButton(title: viewModel.buttonTitle)
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
        .alert(item: $viewModel.alertItem) { $0.alert }
        .sheet(isPresented: $viewModel.isShowingPhotoPicker) { PhotoPicker(image: $viewModel.avatar) }
        .accentColor(.brandPrimary)
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
}

private struct NameBackgroundView: View {
    var body: some View {
        Color(.secondarySystemBackground)
            .frame(height: 130)
            .cornerRadius(12)
    }
}

private struct ProfileImageView: View {
    var image: UIImage

    var body: some View {
        ZStack {
            AvatarView(image: image, size: 84)

            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 14)
                .foregroundColor(.white)
                .offset(y: 30)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel("Profile photo.")
        .accessibilityHint("Opens the iPhone's photo picker.")
        .padding(.leading, 12)
    }
}

private struct CharactersRemainView: View {
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

struct CheckOutButton: View {
    var body: some View {
        Label("Check Out", systemImage: "mappin.and.ellipse")
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .foregroundColor(.white)
            .background(Color.pink)
            .cornerRadius(8)
    }
}

struct BioTextEditor: View {
    var text: Binding<String>

    var body: some View {
        TextEditor(text: text)
            .frame(height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary, lineWidth: 1)
            )
            .accessibilityHint("This TextField has a 100 characters maximum.")
    }
}
