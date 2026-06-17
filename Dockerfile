# 带 Azure TTS 的 Manim 镜像（生产级）
# 基础：官方 Manim CE 镜像（已含 LaTeX、ffmpeg、Cairo）
FROM manimcommunity/manim:stable

USER root

# manim-voiceover 音频处理（调速等）需要 sox
RUN apt-get update && apt-get install -y --no-install-recommends \
        sox \
        libsox-fmt-all \
    && rm -rf /var/lib/apt/lists/*

# manim-voiceover + Azure TTS service
#   - Azure 是官方付费端点 + key 认证，数据中心可用（不像 edge-tts 蹭的免费端点会被封）
#   - Azure 返回逐词时间戳，manim-voiceover 据此自动做「动画-语音对齐」+ 字幕
# 运行时需设环境变量：AZURE_SUBSCRIPTION_KEY、AZURE_SERVICE_REGION
RUN pip install --no-cache-dir --upgrade "manim-voiceover[azure]"

# root 启动，保证 Daytona sandbox 能稳定拉起
USER root
