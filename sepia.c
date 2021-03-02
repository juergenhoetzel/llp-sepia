static const float c[3][3] = {{.393f, .769f, .189f}, {.349f, .686f, .168f}, {.272f, .543f, .131f}};

static unsigned char sat(u_int64_t x) { return x < 256 ? x : 255; }

static void sepia_one(bmp_pixel *const pixel) {
  bmp_pixel old = *pixel;
  pixel->red = sat(old.red * c[0][0] + old.green * c[0][1] + old.blue * c[0][2]);
  pixel->green = sat(old.red * c[1][0] + old.green * c[1][1] + old.blue * c[1][2]);
  pixel->blue = sat(old.red * c[2][0] + old.green * c[2][1] + old.blue * c[2][2]);
}
