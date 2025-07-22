
//
//  HeroPaletteScrollView.swift
//  SwiftUI Hero Scroll with Palette
//

import SwiftUI

// MARK: - Model: Represents each scrollable item
struct ScrollTargetItem: Identifiable, Hashable {
    let id = UUID()
    let color: Color
    let index: Int
}



// MARK: - Reusable Scroll Item View
struct ScrollItemView: View {
    let item: ScrollTargetItem
    let fontSize: Font

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(item.color)
            .frame(height: 120)
            .overlay(
                Text("Item \(item.index + 1)")
                    .font(fontSize)
                    .bold()
                    .foregroundColor(.white)
            )
            .id(item.id)
            .scrollTransition(.animated.threshold(.visible(0.6))) { view, phase in
                view
                    .scaleEffect(phase.isIdentity ? 1 : 0.8)
                    .opacity(phase.isIdentity ? 1 : 0.3)
            }
    }
}

// MARK: - Main Content View
struct ContentView: View {
    @State private var horizontalScrollID: UUID?
    @State private var verticalScrollID: UUID?

    let items = Color.palette.enumerated().map { index, color in
        ScrollTargetItem(color: color, index: index)
    }

    var body: some View {
        VStack(spacing: 30) {
            scrollButtons(
                title: "<< Horizontal >>",
                firstAction: { horizontalScrollID = items.first?.id },
                lastAction: { horizontalScrollID = items.last?.id }
            )
            .padding(.top)

            horizontalScrollSection

            Divider()

            scrollButtons(
                title: "<< Vertical >>",
                firstAction: { verticalScrollID = items.first?.id },
                lastAction: { verticalScrollID = items.last?.id }
            )

            verticalScrollSection
        }
        .padding()
    }

    private var horizontalScrollSection: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 20) {
                    ForEach(items) { item in
                        ScrollItemView(item: item, fontSize: .title2)
                            .frame(width: 160)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 150)
            .onChange(of: horizontalScrollID) {
                if let id = horizontalScrollID {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .center)
                    }
                }
            }
        }
    }

    private var verticalScrollSection: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3),
                    spacing: 20
                ) {
                    ForEach(items) { item in
                        ScrollItemView(item: item, fontSize: .title3)
                            .frame(height: 100)
                    }
                }
                .padding(.horizontal)
            }
            .onChange(of: verticalScrollID) {
                if let id = verticalScrollID {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .top)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func scrollButtons(title: String, firstAction: @escaping () -> Void, lastAction: @escaping () -> Void) -> some View {
        HStack(spacing: 20) {
            Button("First", action: firstAction)
            Text(title)
                .font(.headline)
                .frame(width: 135, alignment: .leading)
            Button("Last", action: lastAction)
        }
        .font(.headline)
    }
}
// MARK: - Extension: Random vibrant color
extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0.4...1),
            green: .random(in: 0.4...1),
            blue: .random(in: 0.4...1)
        )
    }

    static let palette: [Color] = [
        .red, .orange, .yellow, .green, .mint, .teal, .blue, .indigo, .purple, .pink
    ]
}

#Preview {
    ContentView()
}

//import SwiftUI
//
//// MARK: - Models
//
//struct Palette: Identifiable, Hashable {
//    let id = UUID()
//    let name: String
//    let colors: [Color]
//}
//
//// MARK: - Sample Data
//
//let palettes: [Palette] = [
//    Palette(name: "Sunset", colors: [.orange, .pink, .purple]),
//    Palette(name: "Ocean", colors: [.blue, .teal, .cyan]),
//    Palette(name: "Forest", colors: [.green, .brown, .mint]),
//    Palette(name: "Fire", colors: [.red, .orange, .yellow]),
//    Palette(name: "Sky", colors: [.cyan, .blue, .indigo]),
//    Palette(name: "Bloom", colors: [.pink, .red, .white]),
//    Palette(name: "Lavender", colors: [.purple, .indigo, .white]),
//    Palette(name: "Earth", colors: [.brown, .green, .gray]),
//    Palette(name: "Ice", colors: [.blue.opacity(0.5), .white, .gray]),
//    Palette(name: "Coral", colors: [.orange, .pink, .yellow])
//]
//
//// MARK: - Views
//
//struct PaletteHeroView: View {
//    let palette: Palette
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text(palette.name)
//                .font(.headline)
//                .foregroundColor(.white)
//                .shadow(radius: 2)
//
//            HStack(spacing: 6) {
//                ForEach(palette.colors.indices, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 4)
//                        .fill(palette.colors[index])
//                        .frame(width: 24, height: 24)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 4)
//                                .stroke(.white.opacity(0.3), lineWidth: 1)
//                        )
//                }
//            }
//        }
//        .padding(16)
//        .frame(width: 200, height: 100)
//        .background(
//            LinearGradient(
//                colors: palette.colors,
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        )
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
//        .id(palette.id)
//        .scrollTransition(.animated.threshold(.visible(0.6))) { view, phase in
//            view
//                .scaleEffect(phase.isIdentity ? 1 : 0.85)
//                .opacity(phase.isIdentity ? 1 : 0.6)
//                .rotation3DEffect(
//                    .degrees(phase.isIdentity ? 0 : 15),
//                    axis: (x: 0, y: 1, z: 0)
//                )
//        }
//    }
//}
//
//struct ContentView: View {
//    @State private var paletteHorizontalScrollID: UUID?
//    @State private var paletteVerticalScrollID: UUID?
//
//    var body: some View {
//        VStack(spacing: 24) {
//            Text("Color Palettes")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .padding(.top)
//
//            // Horizontal Palette Section
//            VStack(spacing: 16) {
//                scrollControlHeader(
//                    title: "Horizontal Scroll",
//                    firstAction: { paletteHorizontalScrollID = palettes.first?.id },
//                    lastAction: { paletteHorizontalScrollID = palettes.last?.id }
//                )
//
//                ScrollViewReader { proxy in
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        LazyHStack(spacing: 16) {
//                            ForEach(palettes) { palette in
//                                PaletteHeroView(palette: palette)
//                            }
//                        }
//                        .padding(.horizontal, 20)
//                    }
//                    .frame(height: 130)
//                    .onChange(of: paletteHorizontalScrollID) {
//                        if let id = paletteHorizontalScrollID {
//                            withAnimation(.easeInOut(duration: 0.6)) {
//                                proxy.scrollTo(id, anchor: .center)
//                            }
//                        }
//                    }
//                }
//            }
//
//            Divider()
//                .padding(.vertical, 8)
//
//            // Vertical Palette Grid
//            VStack(spacing: 16) {
//                scrollControlHeader(
//                    title: "Grid Layout",
//                    firstAction: { paletteVerticalScrollID = palettes.first?.id },
//                    lastAction: { paletteVerticalScrollID = palettes.last?.id }
//                )
//
//                ScrollViewReader { proxy in
//                    ScrollView(.vertical, showsIndicators: false) {
//                        LazyVGrid(
//                            columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2),
//                            spacing: 16
//                        ) {
//                            ForEach(palettes) { palette in
//                                PaletteHeroView(palette: palette)
//                                    .frame(height: 110)
//                            }
//                        }
//                        .padding(.horizontal, 20)
//                    }
//                    .onChange(of: paletteVerticalScrollID) {
//                        if let id = paletteVerticalScrollID {
//                            withAnimation(.easeInOut(duration: 0.6)) {
//                                proxy.scrollTo(id, anchor: .top)
//                            }
//                        }
//                    }
//                }
//            }
//
//            Spacer()
//        }
//        .background(Color(.systemGroupedBackground))
//    }
//
//    // MARK: - Helper Views
//
//    @ViewBuilder
//    private func scrollControlHeader(
//        title: String,
//        firstAction: @escaping () -> Void,
//        lastAction: @escaping () -> Void
//    ) -> some View {
//        HStack {
//            Button(action: firstAction) {
//                HStack(spacing: 4) {
//                    Image(systemName: "arrow.left.to.line")
//                    Text("First")
//                }
//                .font(.subheadline)
//                .fontWeight(.medium)
//                .padding(.horizontal, 12)
//                .padding(.vertical, 6)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//            }
//
//            Spacer()
//
//            Text(title)
//                .font(.headline)
//                .fontWeight(.semibold)
//                .foregroundColor(.primary)
//
//            Spacer()
//
//            Button(action: lastAction) {
//                HStack(spacing: 4) {
//                    Text("Last")
//                    Image(systemName: "arrow.right.to.line")
//                }
//                .font(.subheadline)
//                .fontWeight(.medium)
//                .padding(.horizontal, 12)
//                .padding(.vertical, 6)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//            }
//        }
//        .padding(.horizontal, 20)
//    }
//}
//
//// MARK: - Preview
//
//#Preview {
//    ContentView()
//}
