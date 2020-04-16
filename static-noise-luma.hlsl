float mod289(float x)  { return x - floor(x / 289.0) * 289.0; }
float permute(float x) { return mod289((34.0*x + 1.0) * x); }
float rand(float x) { return frac(x / 41.0); }

void rgb_to_yuv(float4 rgba, out float3 yuv)
{
    yuv[0] = (0.299 * rgba.r) + (0.587 * rgba.g) + (0.114 * rgba.b);
    yuv[1] = (-0.169 * rgba.r) - (0.331 * rgba.g) + (0.499 * rgba.b) + 128;
    yuv[2] = (0.499 * rgba.r) - (0.418 * rgba.g) - (0.0813 * rgba.b) + 128;

    return;
}

void yuv_to_rgb(float3 yuv, out float4 rgba)
{
    rgba.r = yuv[0] + 1.402 * (yuv[2]-128);
    rgba.g = yuv[0] - 0.344 * (yuv[1]-128) - 0.714 * (yuv[2]-128);
    rgba.b = yuv[0] + 1.772 * (yuv[1]-128);

    rgba.r = clamp(rgba.r, 0, 255);
    rgba.g = clamp(rgba.g, 0, 255);
    rgba.b = clamp(rgba.b, 0, 255);

    rgba.a = 1.0;

    return;
}


float4 mainImage(VertData v_in) : TARGET
{
    float STRENGTH = 500.0;

    float4 rgba = image.Sample(textureSampler, v_in.uv);

    float3 _m = float3(v_in.pos.xy, 1.0) + float3(1.0, 1.0, 1.0);
    float h = permute(permute(permute(_m.x)+_m.y)+_m.z);
    float noise_t = rand(h);

    float3 yuv;
    rgb_to_yuv(rgba, yuv);

    yuv[0] = yuv[0] + (STRENGTH/8192.0) * (noise_t - 0.5);

    yuv_to_rgb(yuv, rgba);

    return rgba;
}