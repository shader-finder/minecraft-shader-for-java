````markdown name=README.md
# Ultra Realistic Iris Shader for Java Minecraft

An ultra-realistic shader pack for Minecraft Java Edition using the **Iris** shader loader. Inspired by IntirationsT with optimized performance for smooth gameplay.

## 🎮 Features

### Visual Enhancements
- **Ultra-Realistic Lighting** - Dynamic shadows with realistic light propagation
- **PBR Materials** - Physically-based rendering for accurate material representation
- **Global Illumination** - Ambient occlusion and indirect lighting
- **Bloom & Glow** - Realistic bright light effects
- **Color Grading** - Cinematic color correction

### Shadow System
- **Realistic Block Shadows** - High-quality PCF shadow mapping
- **No Water Surface Shadows** - Water surfaces remain shadow-free for realism
- **Underwater Block Shadows** - Shadows cast on submerged blocks
- **Adjustable Shadow Distance** - 8-256 chunks (default: 32)
- **Soft Shadow Edges** - 64-sample shadow filtering

### Rain & Weather
- **Realistic Rain** - Animated rainfall with proper density
- **Rain Splashes** - Dynamic splash effects on surfaces
- **Puddle Reflections** - Water puddles reflect the environment
- **Thunder Effects** - Lightning and storm darkening
- **Wind Effects** - Vegetation movement during storms

### Water System
- **Water Caustics** - Animated underwater caustic patterns
- **Wave Animations** - Realistic water surface wave movements
- **Reflection Quality** - High-quality water reflections (adjustable)
- **Underwater Fog** - Customizable underwater visibility
- **Shadow-Free Water** - Water surfaces don't receive shadows

### Performance Optimization
- **Smooth Gameplay** - 60+ FPS on modern systems
- **Temporal Anti-Aliasing** - Smooth edges without performance hit
- **Dynamic Resolution** - Automatic resolution scaling option
- **Motion Blur** - Optional for cinematic look
- **Render Distance Limiting** - Option to cap render distance

## 📋 Requirements

- **Minecraft Java Edition** 1.20+
- **Iris Shader Loader** - [Download](https://irisshaders.net/)
- **GPU** - RTX 2060 or equivalent (min), RTX 3080 or better (recommended)
- **RAM** - 8GB+ system RAM

## 🚀 Installation

1. **Install Iris Shader Loader**
   - Download from [irisshaders.net](https://irisshaders.net/)
   - Install as a Fabric mod

2. **Download the Shader**
   - Clone this repository or download as ZIP
   - Extract to `.minecraft/shaderpacks/`

3. **Enable in Minecraft**
   - Launch Minecraft with Iris installed
   - Open Settings → Video Settings → Shader Packs
   - Select "Ultra-Realistic-Iris-Shader"
   - Click "Done"

## ⚙️ Configuration

Open `shaders.properties` to customize:

### Shadow Settings
```
shadowDistance = 32          # Chunk render distance for shadows
shadowMapResolution = 2048   # Shadow texture quality (2048/4096)
shadowSamples = 16           # Shadow filtering quality
shadowBias = 0.05            # Shadow depth adjustment
```

### Lighting
```
giQuality = 1.0              # Global illumination strength
aoStrength = 1.0             # Ambient occlusion intensity
blockLightStrength = 1.0     # Torch/lamp light brightness
skyLightStrength = 1.0       # Sky light intensity
```

### Water
```
waterShadowDisable = true    # Disable shadows on water surfaces
waterCaustics = true         # Enable underwater caustics
waterReflectionQuality = 1.0 # Reflection detail level
```

### Rain
```
rainQuality = 1.0            # Rain density and quality
rainSplash = true            # Enable splash effects
puddleReflection = true      # Enable puddle reflections
```

### Performance
```
limitRenderDistance = true   # Cap render distance for FPS
dynamicResolution = 1.0      # Resolution scaling
taa = true                   # Temporal anti-aliasing
motionBlur = 0.0             # Motion blur (0.0-0.3)
```

## 📁 File Structure

```
shaders/
├── shaders.properties        # Configuration & uniforms
├── core/
│   ├── composite.fsh/vsh     # Main lighting pass
│   ├── shadow.fsh/vsh        # Shadow depth pass
│   ├── gbuffers_solid.fsh/vsh  # Solid geometry
│   ├── gbuffers_water.fsh/vsh  # Water rendering
│   └── [other G-buffer passes]
└── textures/                 # Optional texture overrides
```

## 🎨 How It Works

### Rendering Pipeline

1. **G-Buffer Pass** (Iris Deferred Rendering)
   - Captures albedo, normals, specular, and depth
   - Special handling for water surfaces (no-shadow flag)

2. **Shadow Pass**
   - Renders scene from sun position
   - Creates shadow map for PCF filtering

3. **Composite Pass** (Main Lighting)
   - Calculates shadows with soft edges
   - Applies global illumination
   - Blends direct and indirect lighting
   - Applies rain effects
   - Adds bloom and color grading

### Shadow System Detail
- Water surfaces are flagged in G-buffer (alpha = 0)
- Composite shader checks water flag and skips shadow for water
- Underwater blocks still receive shadows normally
- PCF filtering creates smooth shadow edges

## 🐛 Troubleshooting

### Low FPS
- Reduce `shadowMapResolution` to 1024
- Decrease `shadowSamples` to 8
- Enable `limitRenderDistance`
- Lower `giQuality` and `aoStrength`

### Black Screen
- Ensure Iris is installed correctly
- Update GPU drivers
- Try disabling `colorGrading`

### Water Too Bright
- Reduce `waterReflectionQuality`
- Lower `bloomStrength`

### Shadows Not Appearing
- Increase `shadowDistance`
- Check that sun is visible (not night)
- Verify `waterShadowDisable ≠ all shadows`

## 📈 Performance Tips

- **Ultra Settings**: GTX 1080 Ti / RTX 2080 Ti
  - `shadowDistance = 128`, `shadowSamples = 64`
  - All effects enabled, full quality

- **High Settings**: RTX 3070 / RTX 4080
  - `shadowDistance = 64`, `shadowSamples = 32`
  - Most effects enabled

- **Medium Settings**: RTX 3060 / GTX 1660 Ti
  - `shadowDistance = 32`, `shadowSamples = 16`
  - Balanced performance

- **Low Settings**: GTX 1060 / RTX 3050
  - `shadowDistance = 16`, `shadowSamples = 8`
  - Minimal effects

## 🤝 Contributing

Found a bug or have a suggestion?
- Open an issue on GitHub
- Include your GPU, FPS, and settings

## 📜 License

This shader is provided as-is for personal use.

## 🙏 Credits

- **Inspiration**: IntirationsT shader
- **Framework**: Iris Shader Loader (by coderbot & IrisShaders team)
- **Minecraft**: Mojang Studios

---

**Enjoy ultra-realistic Minecraft!** 🎮✨
````
