//
//  PackageContentHeaderView.swift
//  delivery
//
//  Created by Aref Chucri on 03/02/25.
//

import SwiftUI

struct PackageContentHeaderView: View {
    var packages: [EPackageType]
    @Binding var selectionId: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2.0) {
            Text("Package Selection")
                .foregroundStyle(.primary)
                .font(.title2)
                .bold()
            Text("Please select the package type for your intended delivery.")
                .foregroundStyle(.secondary)
                .font(.headline)
            Spacer().frame(maxWidth: .infinity)
        }
        .padding(.horizontal, hMargin)
    }

    private func scrollToNextID() {
            guard let id = selectionId, id != packages.last?.id,
                  let index = packages.firstIndex(where: { $0.id == id })
            else { return }
            
            withAnimation {
                selectionId = packages[index + 1].id
            }
        }
        
        private func scrollToPreviousID() {
            guard let id = selectionId, id != packages.first?.id,
                  let index = packages.firstIndex(where: { $0.id == id })
            else { return }
            
            withAnimation {
                selectionId = packages[index - 1].id
            }
        }
        
        var hMargin: CGFloat {
            20.0
        }
    }


    #Preview {
        PackageContentHeaderView(packages: EPackageType.allCases, selectionId: .constant(nil))
    }
