import SwiftUI
import AVFoundation

struct audioplayerview: View {
    @ObservedObject var audio: audioservice
    @State private var expanded = false
    @State private var dragging = false
    @State private var dragoffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Spacer()
                
                if audio.currenturl != nil {
                    ZStack(alignment: .top) {
                        if expanded {
                            expandedplayer
                                .frame(height: geo.size.height * 0.7)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        } else {
                            miniplayer
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .offset(y: dragging ? dragoffset : 0)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragging = true
                                dragoffset = max(0, value.translation.height)
                            }
                            .onEnded { value in
                                dragging = false
                                if value.translation.height > 100 {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        expanded = false
                                    }
                                } else if value.translation.height < -50 && !expanded {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        expanded = true
                                    }
                                }
                                dragoffset = 0
                            }
                    )
                }
            }
            .ignoresSafeArea(.keyboard)
        }
    }
    
    private var miniplayer: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(audio.currenttitle)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(appcolors.text)
                    .lineLimit(1)
                
                Text(formattime(audio.currenttime))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(appcolors.textsecondary)
                    .monospacedDigit()
            }
            
            Spacer()
            
            Button {
                audio.toggleplay()
            } label: {
                Image(systemName: audio.playing ? "pause.fill" : "play.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(appcolors.accent)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            
            Button {
                audio.stop()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(appcolors.textsecondary)
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: -5)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 120)
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                expanded = true
            }
        }
    }
    
    private var expandedplayer: some View {
        VStack(spacing: 0) {
            draghandle
                .padding(.top, 12)
            
            Spacer()
            
            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text(audio.currenttitle)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(appcolors.text)
                        .multilineTextAlignment(.center)
                    
                    Text(audio.currentsubtitle)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(appcolors.textsecondary)
                }
                .padding(.horizontal, 32)
                
                VStack(spacing: 12) {
                    progressbar
                    
                    HStack {
                        Text(formattime(audio.currenttime))
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(appcolors.textsecondary)
                            .monospacedDigit()
                        
                        Spacer()
                        
                        Text(formattime(audio.duration))
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(appcolors.textsecondary)
                            .monospacedDigit()
                    }
                }
                .padding(.horizontal, 32)
                
                HStack(spacing: 40) {
                    Button {
                        audio.previous()
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(appcolors.text)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        audio.toggleplay()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(appcolors.accent)
                                .frame(width: 72, height: 72)
                            
                            Image(systemName: audio.playing ? "pause.fill" : "play.fill")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.black)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        audio.next()
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(appcolors.text)
                    }
                    .buttonStyle(.plain)
                }
                
                HStack(spacing: 60) {
                    Button {
                        audio.cyclespeed()
                    } label: {
                        Text("\(String(format: "%.1f", audio.speed))x")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(audio.speed == 1.0 ? appcolors.textsecondary : appcolors.accent)
                            .frame(width: 60, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(appcolors.cardbackground)
                            )
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        audio.togglerepeat()
                    } label: {
                        Image(systemName: audio.repeatmode ? "repeat.1" : "repeat")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(audio.repeatmode ? appcolors.accent : appcolors.textsecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.5), radius: 40, x: 0, y: -10)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 120)
    }
    
    private var draghandle: some View {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .fill(appcolors.texttertiary)
            .frame(width: 40, height: 5)
    }
    
    private var progressbar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(appcolors.texttertiary.opacity(0.3))
                    .frame(height: 6)
                
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(appcolors.accent)
                    .frame(width: geo.size.width * audio.progress, height: 6)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let progress = min(max(0, value.location.x / geo.size.width), 1)
                        audio.seek(to: progress)
                    }
            )
        }
        .frame(height: 6)
    }
    
    private func formattime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }
}
