//
//  Tutorial.swift
//  snapshot
//
//  Created by cher1shRXD on 5/7/25.
//

import SwiftUI

struct Tutorial: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var page: Int = 0
    
    var body: some View {
        VStack{
            Spacer()
            VStack(spacing: 16){
                Image("Tutorial\(page + 1)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
                
                
                Text(page == 0 ? "화면 하단의 'GO!' 버튼을 눌러 촬영을 시작해요." : page == 1 ? "촬영을 시작하면 버튼이 남은 촬영 횟수로 바뀌고, 버튼을 한번 더 누르면 카운트다운과 상관없이 촬영할 수 있어요." : "카운트 다운이 0이 되면 자동으로 촬영을 진행해요.")
                    .multilineTextAlignment(.center)
                
                
                HStack{
                    if page > 0 {
                        Button{
                            page -= 1
                        } label: {
                            HStack{
                                Text("이전")
                            }
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color.container(for: colorScheme))
                            .foregroundStyle(Color.black(for: colorScheme))
                            .roundedCorners(12, corners: [.allCorners])
                        }
                    }
                    
                    if page < 2 {
                        Button{
                            page += 1
                        } label: {
                            HStack{
                                Text("다음")
                            }
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color.main)
                            .foregroundStyle(.white)
                            .roundedCorners(12, corners: [.allCorners])
                            
                        }
                        
                    }
                    
                    if page >= 2 {
                        Button{
                            UserDefaults.standard.set(true, forKey: "tutorial")
                        } label: {
                            HStack{
                                Text("확인")
                            }
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color.main)
                            .foregroundStyle(.white)
                            .roundedCorners(12, corners: [.allCorners])
                        }
                    }
                    
                }
                .foregroundStyle(Color.blue)
                
                
            }
            .foregroundStyle(Color.black(for: colorScheme))
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .background(Color.white(for: colorScheme))
            .roundedCorners(24, corners: [.allCorners])
            
            Spacer()
            
            
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(.black.opacity(0.3))
        .contentShape(Rectangle())
    }
}

#Preview {
    Tutorial()
}
