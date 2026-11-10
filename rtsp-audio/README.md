# Experimental RTSP microphone audio for SXJ01ZM

Adds an AAC-LC mono track to the existing `/live/ch00_0` stream. The video-only server remains the default. No ONVIF service or talkback channel is added.

## Hardware validation

Tested on one Xiaomi Mi Home Security Camera SXJ01ZM, GM8136, stock firmware **3.3.6_0099 build 312**, running the 0.8.7 toolset. Do not assume compatibility with other firmware or camera models.

After reboot, a direct UDP RTSP decode test of 40.05 seconds produced 825 H.264 video frames and 323 AAC audio frames, with no decoder errors. The maximum timestamp step was 0.0527 s for video and 0.136 s for audio, with no repeated or backward timestamps in that sample. Microphone signal levels responded to nearby speech/noise during a separate test. This is short-duration device validation, not a long-term reliability result. The device owner also reports that Synology Surveillance Station records regularly with the new server. NAS recordings were not independently re-analyzed after this change; the automated measurements above concern the direct RTSP stream.

## Enable

Back up the SD card first. Copy `tools/rtsp_audio`, `tools/rtsp_audio_start.sh` and the updated `valhalla.sh` to the SD card. Keep your own `midgard.ini`; do not overwrite Wi-Fi settings or passwords with the sample configuration.

Set these entries in `midgard.ini`:

```ini
RTSP_ENABLED=1
RTSP_AUDIO_ENABLED=1
CLOUD_DISABLED=0
CLOUD_STREAMING_DISABLED=1
CONFIG_LINE=-b2048 -f20 -w1920 -h1080 -m1
```

Power-cycle the camera. The launcher waits up to 60 seconds for the clock to leave its initial 1970 date before RTCP reports start. If time initialization fails it starts anyway after the timeout; a later clock jump remains possible. The stream is:

```text
rtsp://CAMERA_IP:554/live/ch00_0
```

Video is H.264 1920x1080, configured at 20 fps / 2048 Kbit/s. Audio is AAC-LC, mono, 8000 Hz / 16 Kbit/s, matching the tested device's audio input rate. The stream has no authentication, like the original implementation; keep access restricted to a trusted network. The original camera SSH credentials are unrelated to RTSP.

Disabling Xiaomi streaming is required for this tested configuration: its service competes for the same media resources and is automatically restarted if merely killed. This prevents viewing video through the Xiaomi app. Wi-Fi and account settings are not changed. `CLOUD_DISABLED=1` is deliberately rejected for audio because the existing script's cloud-disabling branch does not actually stop the AV streamer.

For Surveillance Station, use User Define / Streaming - RTSP. UDP was the working NAS transport in the original device setup. Reconnect the camera and select AAC if supported by the installed NAS/client version. The speaker and the firmware `aac_player` are **not** supported alongside this server: a speaker test disturbed capture and required rebooting the camera.

## Revert

Set `RTSP_AUDIO_ENABLED=0` and restore your previous cloud and video settings, then power-cycle. `tools/rtsp_basic` is not replaced. Restore the backed-up `valhalla.sh` and `midgard.ini` for a complete configuration rollback. No flash firmware update is required.

## Implementation and attribution

`rtspd.c` preserves the Xiaomi capture path from [willthrom/rtspServer_gm](https://github.com/willthrom/rtspServer_gm/tree/ec67a35c5f9eeade7985c64dacb2cce6223ebad1), with audio capture/packetization adapted from [xurubin/gm8136_rtspd](https://github.com/xurubin/gm8136_rtspd/tree/a336655804af5395383e44d8cbfb9085e73c88d9). Original copyright notices are preserved. Vendor SDK headers, libraries and toolchain are fetched from that pinned repository during the build; this contribution does not assign a new license to them.

Changes include 8 kHz AAC configuration, frame-owned RTP buffers released through the library callback, in-band H.264 SPS/PPS instead of blocking RTSP startup on a keyframe, an optional `-pPORT` argument, and keeping the shared stream active when one client sends TEARDOWN. The camera PATH must include `/sbin`, because the vendor RTSP library invokes `devmem` for platform detection.

## Build

Build the isolated legacy ARMv5/uClibc toolchain image from the repository root:

```sh
docker build --platform linux/386 -t mijia-rtsp-audio rtsp-audio
docker create --name mijia-audio-export mijia-rtsp-audio
docker cp mijia-audio-export:/build/rtsp_audio ./sdcard/tools/rtsp_audio
docker rm mijia-audio-export
```

The checked-in binary is the exact device-tested executable, SHA-256:

```text
cd5b092c511ca5f53871ec6e1605ff05b9c49905b2ef5285438ef47ec3e20bbb
```

Rebuilds may differ in ELF metadata/toolchain paths. Test a rebuild on a separate endpoint first (`-p8554`), and do not run two competing camera capture servers simultaneously. Hardware/driver tests cannot be replaced by a successful compilation.
