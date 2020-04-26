/* 2010: enable WebGL (Web Graphics Library) */
user_pref("webgl.disabled", false);
user_pref("webgl.enable-webgl2", true);
/* Limit webgl */
user_pref("webgl.min_capability_mode", false);
user_pref("webgl.disable-fail-if-major-performance-caveat", false);

/* 1404: enable rendering of SVG OpenType fonts */
user_pref("gfx.font_rendering.opentype_svg.enabled", true);

/* 1408: enable graphite */
user_pref("gfx.font_rendering.graphite.enabled", true);

/* 2002: limit WebRTC IP leaks if using WebRTC */
user_pref("media.peerconnection.enabled", true);

/* 1830: enable all DRM content (EME: Encryption Media Extension) */
user_pref("media.eme.enabled", true);

/* 1825: enable widevine CDM (Content Decryption Module) */
user_pref("media.gmp-widevinecdm.enabled", true);
user_pref("media.gmp-widevinecdm.visible", true);

/* Custom settings */
user_pref("mousewheel.min_line_scroll_amount", 10);
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);
user_pref("mousewheel.default.delta_multiplier_y", 300);
