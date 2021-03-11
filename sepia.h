#ifndef SEPIA_H
#define SEPIA_H

#include <stdint.h>
#include <stdlib.h>

extern void sepia_all(void const *pixels, size_t pixel_count);
extern size_t sepia_one(void const *pixels);

typedef struct {
  uint8_t b;
  uint8_t g;
  uint8_t r;
} pixel;

#endif
