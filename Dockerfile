# 带 TTS 能力的 Manim 镜像
# 基础：官方 Manim CE 镜像（已含 LaTeX、ffmpeg、Cairo 等，省去一堆系统依赖）
FROM manimcommunity/manim:stable

USER root

# manim-voiceover 的系统依赖：
#   sox / libsox-fmt-all : 音频处理、调整语速（manim-voiceover 必需，版本需 >=14.4.2）
#   portaudio19-dev      : PyAudio 编译依赖（录音用，可选）
#   gettext              : 文案翻译（可选）
RUN apt-get update && apt-get install -y --no-install-recommends \
        sox \
        libsox-fmt-all \
        portaudio19-dev \
        gettext \
    && rm -rf /var/lib/apt/lists/*

# Python 依赖：
#   manim-voiceover : 给 manim 加配音 / 字幕自动对齐的框架
#   edge-tts        : 微软 Edge 免费 TTS（无需 API key，但运行时要联网调微软端点）
#   pydub           : 音频处理（manim-voiceover 依赖，显式装上更稳）
# 注意：edge-tts 7.x 有较大改动；若 manim-voiceover 报错，
#       把下面这行改成 "edge-tts<7" 再重新构建即可。
RUN pip install --no-cache-dir --upgrade \
        "manim-voiceover" \
        "edge-tts" \
        "pydub"

USER manim
