###
Colour conversion utils
Mostly nicked from the interwebs

Main source: http://blog.crondesign.com/2011/02/actionscriptjavascript-colour-mode.html
hsbToRgb conversion from: http://stackoverflow.com/questions/17242144/javascript-convert-hsb-hsv-color-to-rgb-accurately

###
class ColourConversion

  # Takes a hex color code and returns RGB vals as array
  @hexToRgb: (hex) ->
    rgb = []
    rgb.push hex >> 16
    rgb.push hex >> 8 & 0xFF
    rgb.push hex & 0xFF
    return rgb

  # takes an array of R,G,B values and returns the hex code
  @rgbToHex: (rgb) ->
    hex = rgb[0] << 16 ^ rgb[1] << 8 ^ rgb[2]
    return hex

  # takes an array of H,S,B values and returns RGB vals as array
  @hsbToRgb: (hsb) ->
    h = hsb[0] / 360
    s = hsb[1] / 100
    v = hsb[2] / 100

    i = Math.floor(h * 6)
    f = h * 6 - i
    p = v * (1 - s)
    q = v * (1 - f * s)
    t = v * (1 - (1 - f) * s)

    check = i % 6
    if check is 0
      r = v
      g = t
      b = p
    if check is 1
      r = q
      g = v
      b = p
    if check is 2
      r = p
      g = v
      b = t
    if check is 3
      r = p
      g = q
      b = v
    if check is 4
      r = t
      g = p
      b = v
    if check is 5
      r = v
      g = p
      b = q

    return [r * 255, g * 255, b * 255]

  # takes an array of R,G,B values and returns HSB vals as array
  @rgbToHsb: (rgb) ->
    rgb[0] /= 255
    rgb[1] /= 255
    rgb[2] /= 255
    x = Math.min(Math.min(rgb[0], rgb[1]), rgb[2])
    val = Math.max(Math.max(rgb[0], rgb[1]), rgb[2])
    if x is val
      return [undefined, 0, val*100]

    if x is rgb[0] then f = rgb[1] - rgb[2]
    else if x is rgb[1] then f = rgb[2] - rgb[0]
    else f = rgb[0] - rgb[1]

    if x is rgb[0] then i = 3
    else if x is rgb[1] then i = 5
    else i = 1

    hue = Math.floor(( i-f / (val - x)) * 60) % 360
    sat = Math.floor(( (val - x) / val) * 100)
    val = Math.floor(val * 100)

    return [hue, sat, val]

  # takes an array of H,S,B values and returns the hex code
  @hsbToHex: (hsb) ->
    rgb = ColourConversion.hsbToRgb hsb
    return ColourConversion.rgbToHex rgb

  # takes a hex colour code and returns HSB vals as array
  @hexToHsb: (hex) ->
    rgb = ColourConversion.hexToRgb hex
    return ColourConversion.rgbToHsb rgb

