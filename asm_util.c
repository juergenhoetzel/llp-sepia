/* asm helper functions */
#include "sepia.h"

void convert_to_b4g4r4(pixel *src, uint32_t dst[12]) {
  /* b */
  dst[0] = src[0].b;
  dst[1] = src[0].b;
  dst[2] = src[0].b;
  dst[3] = src[1].b;
  /* g */
  dst[4] = src[0].g;
  dst[5] = src[0].g;
  dst[6] = src[0].g;
  dst[7] = src[1].g;
  /* r */
  dst[8] = src[0].r;
  dst[9] = src[0].r;
  dst[10] = src[0].r;
  dst[11] = src[1].r;
}

void convert_from_b4g4r4(uint32_t src[12], pixel *dst) {
  /* b */
  dst[0].b = src[0] > 255 ? 255 : src[0];
  dst[0].g = src[1] > 255 ? 255 : src[1];
  dst[0].r = src[2] > 255 ? 255 : src[2];
  dst[3].b = src[3] > 255 ? 255 : src[3];
}
