#include <FreeImage.h>
#include <SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/resource.h>

#include "sepia.h"

int main(int argc, char **argv) {

  char *in_filename;
  char *out_filename;

  if (argc != 3) {
    fprintf(stderr, "Usage: %s input.bmp output.bmp\n", argv[0]);
    exit(1);
  }
  in_filename = argv[1];
  out_filename = argv[2];

  if (SDL_Init(SDL_INIT_VIDEO < 0)) {
    fprintf(stderr, "SDL_init failed: %s\n", SDL_GetError());
    exit(1);
  }
  SDL_Surface *image, *in_image;
  if ((in_image = SDL_LoadBMP(in_filename)) == NULL) {
    fprintf(stderr, "Failed to load %s\n", in_filename);
    exit(1);
  }
  struct rusage ru;
  struct timeval start, end;
  getrusage(RUSAGE_SELF, &ru);
  start = ru.ru_utime;

  SDL_PixelFormat *format = SDL_AllocFormat(SDL_PIXELFORMAT_RGB24);
  image = SDL_ConvertSurface(in_image, format, 0);
  SDL_FreeFormat(format);
  if (image == NULL) {
    fprintf(stderr, "Failed to convert image: %s\n", SDL_GetError());
    exit(1);
  };
  SDL_LockSurface(image);
  pixel *p = (pixel *)image->pixels;
  for (int i = 0; i < image->w * image->h;) {
    i += sepia_one(p + i);
  }
  SDL_UnlockSurface(image);
  printf("Width:%d, Height:%d\n", image->w, image->h);
  getrusage(RUSAGE_SELF, &ru);
  end = ru.ru_utime;
  printf("Elapsed microseconds: %ld\n", (end.tv_sec - start.tv_sec) * 1000000L + end.tv_usec - start.tv_usec);

  if (SDL_SaveBMP(image, out_filename) < 0) {
    fprintf(stderr, "Failed to save: %s\n", SDL_GetError());
    exit(1);
  }
  SDL_FreeSurface(image);
  SDL_Quit();
}
