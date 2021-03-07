/* asm helper functions */
#include "sepia.h"

void convert_from_b4g4r4(uint32_t src[12], pixel *dst) {
  /* b */
  dst[0].b = src[0];
  dst[0].g = src[1];
  dst[0].r = src[2];
  dst[3].b = src[3];
}
