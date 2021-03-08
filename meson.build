project('llpl', 'c')
if host_machine.cpu_family() == 'x86_64' and host_machine.system() == 'linux'
  asm_format = 'elf64'
else
  error('x86_64 only')
endif
nasm = find_program('nasm', required: true)
asm_gen = generator(nasm,
  output : '@BASENAME@.o',
  arguments : [
    '-f', asm_format,
    '@INPUT@',
    '-o', '@OUTPUT@'])


add_global_arguments(language : 'c')
sdl2 = dependency('SDL2')
executable('sepia', 'main.c', 'sepia.c', dependencies: sdl2)
executable('sepia_mmx', 'main.c', asm_gen.process('sepia.asm'), dependencies: sdl2)

