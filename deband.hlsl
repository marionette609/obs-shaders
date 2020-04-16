float mod289(float x)  { return x - floor(x / 289.0) * 289.0; }
float permute(float x) { return mod289((34.0*x + 1.0) * x); }
float rand(float x) { return frac(x / 41.0); }

float4 average(texture2d tex, VertData v_in, float range, inout float h)
{
    float dist = rand(h) * range;       h = permute(h);
    float dir = rand(h) * 6.2831853;    h = permute(h);
    float2 o = float2(dist/uv_size.x, dist/uv_size.y) * float2(cos(dir), sin(dir));

    float4 ref[4];

    ref[0] = tex.Sample(textureSampler, v_in.uv + float2(o.x, o.y));
    ref[1] = tex.Sample(textureSampler, v_in.uv + float2(-o.y, o.x));
    ref[2] = tex.Sample(textureSampler, v_in.uv + float2(-o.x, -o.y));
    ref[3] = tex.Sample(textureSampler, v_in.uv + float2(o.y, -o.x));

    return (ref[0] + ref[1] + ref[2] + ref[3])*0.25;
}

float4 mainImage(VertData v_in) : TARGET
{
    // settings
    float iterations = 3.0;
    float threshold = 100.0;
    float range = 16;
    float grain = 0.0;

    // seeding prng
    float2 vTexCoord = v_in.uv;
    float3 _m = float3(v_in.pos.xy, 1.0) + float3(1.0, 1.0, 1.0);
    float h = permute(permute(permute(_m.x)+_m.y)+_m.z);

    float4 avg;
    float4 diff;

    float4 color = image.Sample(textureSampler, v_in.uv);

    for (int i = 1; i <= int(iterations); i++)
    {
        avg = average(image, v_in, float(i) * range, h);
        diff = abs(color - avg);
        diff[3] = 1;
        float4 temp_one = {(threshold / (float(i) * 16384.0)), (threshold / (float(i) * 16384.0)), (threshold / (float(i) * 16384.0)), 1};
        color = lerp(avg, color, step(temp_one, diff ));
    }

    return color;
}