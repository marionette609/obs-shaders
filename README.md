# obs-shaders

These are mpv shaders that I've ported to be usable as filters in OBS via the [obs-shaderfilter plugin](https://github.com/Oncorporation/obs-shaderfilter)

Deband comes from the [debanding shader built into mpv](https://github.com/mpv-player/mpv/blob/master/video/out/gpu/video_shaders.c#L896) - you should tune the settings in this for your source

Static noise luma is based on the [mpv shader of the same name](https://pastebin.com/yacMe6EZ) (not sure who originally wrote this one) - this is probably terrible for streaming