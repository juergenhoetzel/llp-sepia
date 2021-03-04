#include "sepia.h"

static const float c[3][3] = {{.393f, .769f, .189f}, {.349f, .686f, .168f}, {.272f, .543f, .131f}};

static unsigned char sat(uint64_t x) { return x < 256 ? x : 255; }

size_t sepia_one(void const *pixels) {
  pixel *inp = (pixel *)pixels;
  pixel old = *inp;
  inp->r = sat(old.r * c[0][0] + old.g * c[0][1] + old.b * c[0][2]);
  inp->g = sat(old.r * c[1][0] + old.g * c[1][1] + old.b * c[1][2]);
  inp->b = sat(old.r * c[2][0] + old.g * c[2][1] + old.b * c[2][2]);
  return 1;
}
