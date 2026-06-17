# manim-tts

基于 [`manimcommunity/manim:stable`](https://hub.docker.com/r/manimcommunity/manim) 的镜像，
额外加上 TTS 能力（[manim-voiceover](https://voiceover.manim.community) + [edge-tts](https://github.com/rany2/edge-tts)），
用于在 [Daytona](https://daytona.io) sandbox 里渲染带配音的 Manim 视频。

## 包含什么

- 官方 Manim CE（含 LaTeX、ffmpeg、Cairo）
- `manim-voiceover` —— 配音 / 字幕自动对齐框架
- `edge-tts` —— 微软 Edge 免费 TTS（无需 API key，运行时联网）
- `sox`、`pydub` —— 音频处理

## 构建方式

push 到 `main` 或打 `v*` tag 时，GitHub Actions 自动构建 `linux/amd64` 镜像并发布到 GHCR：

```
ghcr.io/wuxiwuhen/manim-tts:<tag>
```

- 每次推 `main` → `:latest` 和 `:sha-xxxxxx`
- 打 tag（如 `v1`）→ `:v1`（推荐给 Daytona 用这个）

## 在 Daytona 里使用

1. 镜像首次发布后，到仓库的 **Packages** 页面把可见性改成 **Public**
   （这样 Daytona 拉镜像不用配 registry 凭证）。
2. Daytona → Snapshots → Create，image 填带**明确 tag** 的地址（**不要用 `latest`**）：
   ```
   ghcr.io/wuxiwuhen/manim-tts:v1
   ```
3. 或用 SDK：
   ```python
   from daytona import Daytona, CreateSnapshotParams
   Daytona().snapshot.create(CreateSnapshotParams(
       name="manim-tts",
       image="ghcr.io/wuxiwuhen/manim-tts:v1",
   ))
   ```

## 注意

- `edge-tts` 7.x 有较大改动；若 `manim-voiceover` 报错，把 Dockerfile 里的 `"edge-tts"` 改成 `"edge-tts<7"` 重新构建。
- edge-tts 运行时需联网，Daytona sandbox 默认有网络。
