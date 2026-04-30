import SwiftUI

struct ShoeCardView: View {
    let zapato: Shoe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Imagen / Icono
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: zapato.colorHex).opacity(0.25),
                                Color(hex: zapato.colorHex).opacity(0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 140)
                
                VStack(spacing: 6) {
                    Image(systemName: zapato.imagenSistema)
                        .font(.system(size: 44))
                        .foregroundStyle(Color(hex: zapato.colorHex))
                    
                    Text(zapato.tipo.icono)
                        .font(.title2)
                }
                
                // Badge disponibilidad
                VStack {
                    HStack {
                        Spacer()
                        Text(zapato.disponible ? "✓ Disponible" : "✗ Agotado")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(zapato.disponible ? Color.green : Color.red)
                            )
                            .padding(8)
                    }
                    Spacer()
                }
            }
            
            // Info
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(zapato.marca.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(zapato.genero.rawValue)
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.accentColor.opacity(0.8)))
                }
                
                Text(zapato.nombre)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                // Color dot + nombre
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color(hex: zapato.colorHex))
                        .frame(width: 10, height: 10)
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 0.5))
                    Text(zapato.color)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("SKU: \(zapato.sku)")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                
                Divider()
                
                HStack {
                    // Tallas disponibles (primeras 3)
                    HStack(spacing: 3) {
                        ForEach(zapato.tallas.prefix(3), id: \.self) { talla in
                            Text(String(format: talla.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f", talla))
                                .font(.caption2)
                                .fontWeight(.medium)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.12)))
                        }
                        if zapato.tallas.count > 3 {
                            Text("+\(zapato.tallas.count - 3)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Text(zapato.precioFormateado)
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.accentColor)
                }
            }
            .padding(12)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .opacity(zapato.disponible ? 1.0 : 0.7)
    }
}

// MARK: - Color from Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
