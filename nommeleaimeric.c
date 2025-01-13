#include <stdlib.h>
#include <assert.h>
#include <cstdint>
#include <stdio.h>

uint64_t quoicoumux(uint64_t a, uint64_t b, uint64_t c) { 
    return ((uint64_t)(-a) & b) | ((uint64_t)(~((uint64_t) (-a))) & c);
}

signed main() {
   // assert((uint64_t)(0) & 43 == 43);
    printf("%ld", quoicoumux(1, 46854512, 45845));

}