//
//  CityListViewUI.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 17/12/21.
//

import SwiftUI

struct CityListViewUI: View {
    @ObservedObject var viewModel: CityListViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            
            HStack(alignment: .center, spacing: 0) {
                SearchTextField(searchText: $viewModel.searchKeyword,
                                isFirstResponder: viewModel.isFirstResponder,
                                placeholderText: "Search",
                                onChangeHandler: { text in
                                    viewModel.searchKeyword = text
                                },
                                onCommitHandler: {},
                                onClearHandler: {
                                    viewModel.clear()
                                })
                    .padding(.top, 10)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                
                PrimaryButton(isDisabled: viewModel.buttonTitleIsDisable,
                              radius: 0,
                              btnText: viewModel.buttonTitle) {
                    viewModel.onSearchButtonPress()
                }
                .disabled(viewModel.buttonTitleIsDisable)
                .frame(width: 70, height: 48)
                .padding(.top, 10)
                .padding(.trailing, 10)
            }
            
            if viewModel.loading {
                LoaderView(tintColor: .primaryButtonColor, scaleSize: 2)
            } else {
                    List {
                        ForEach(Array(viewModel.citiesList.enumerated()), id: \.offset) { index, cityModel in
                            CityRow(cityModel: cityModel)
                                .onTapGesture {
                                    viewModel.openCityDetailsScreen(name: cityModel.name)
                                }
                                .id(UUID())
                        }
                    }.listStyle(InsetListStyle())
                    .padding(.top, 10)
                    .padding(.trailing, 10)
            }
        })
    }
    
    struct SearchTextField: View {

        @Binding var searchText: String
        var isFirstResponder: Bool = false
        var placeholderText: String
        var onChangeHandler: ((String) -> Void)?
        var onCommitHandler: (() -> Void)?
        var onClearHandler: (() -> Void)?

        var body: some View {
            ZStack(content: {
                HStack(alignment: .center, spacing: 0, content: {
                    UIKitTextField(searchText: $searchText,
                                   isFirstResponder: isFirstResponder,
                                   placeholder: placeholderText,
                                   returnType: .search,
                                   onChangeHandler: { newString in
                                       searchText = newString
                                       onChangeHandler?(newString)
                                   },
                                   onCommitHandler: onCommitHandler)
                                   .frame(height: 48)
                                   .padding(.leading, 10)
                                   .padding(.trailing, 10)
                                        
                    Spacer(minLength: 50)
                })

                HStack(alignment: .center, spacing: 0, content: {
                    Spacer()

                    Image.clear
                        .onTapGesture {
                            onClearHandler?()
                        }
                        .padding()
                })
            })
            .frame(
                minWidth: 0,
                minHeight: 0,
                maxHeight: 48,
                alignment: .center
            )
            .background(Color.white)
            .cornerRadius(3)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.borderStrokeColor, lineWidth: 1)
            )
            .shadow(color: Color.appBlack.opacity(0.05), radius: 2, x: 0, y: 2)
        }
    }
    
    struct CityRow: View {
        var cityModel: CityModel

        var body: some View {
            HStack(spacing: 0) {
                Text(cityModel.name)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 25,
                        alignment: .leading
                    )
             }
            .background(Color.white)
        }
    }
}

struct CityListViewUI_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CityListViewModel(coordinator: CityListCoordinator())
        CityListViewUI(viewModel: viewModel)
    }
}
